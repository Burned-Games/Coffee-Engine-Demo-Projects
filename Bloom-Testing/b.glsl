#[vertex]

#version 450 core
layout (location = 0) in vec3 aPosition;
layout (location = 1) in vec2 aTexCoord;

layout (std140, binding = 0) uniform camera
{
    mat4 projection;
    mat4 view;
    vec3 cameraPos;
};

struct VertexData
{
    vec2 TexCoords;
    vec3 WorldPos;
    vec3 camPos;
};

layout (location = 2) out VertexData Output;

uniform mat4 model;

void main()
{
    Output.TexCoords = aTexCoord;
    Output.WorldPos = vec3(model * vec4(aPosition, 1.0));
    Output.camPos = cameraPos;

    gl_Position = projection * view * vec4(Output.WorldPos, 1.0);
}

#[fragment]

#version 450 core
layout(location = 0) out vec4 FragColor;
layout(location = 1) out vec4 EntityID;

uniform vec3 entityID;

// --- Begin Shield Uniforms ---
const float MPI = 1.5707966326;
const int STEPS = 20;
const float LOWER_LIMIT = 0.01;

uniform float zoom_out;
uniform float border_decay;
uniform vec4 shield_tint;
uniform vec4 shield_saturation;
uniform float attack_angle;
uniform float attack_penetration;
uniform float attack_radius;
uniform float attack_amplitude;
uniform float wave_speed;
uniform float wave_num;

// Replaced sampler2D uniforms with procedural alternatives
// uniform sampler2D noise_texture;
// uniform sampler2D screen_tex;

uniform float noise_speed;
uniform float noise_amplitude;
uniform float noise_deformation;
uniform float TIME;
uniform vec2 SCREEN_PIXEL_SIZE;
// --- End Shield Uniforms ---

struct VertexData
{
    vec2 TexCoords;
    vec3 WorldPos;
    vec3 camPos;
};

layout (location = 2) in VertexData VertexInput;

// Simple procedural noise function (value noise)
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Fake "noise texture" as vec4
vec4 get_noise_texel(vec2 uv) {
    float n = noise(uv * 10.0 + TIME * noise_speed);
    float n2 = noise((uv + 1.234) * 10.0 - TIME * noise_speed * 0.5);
    float n3 = noise((uv - 2.345) * 10.0 + TIME * noise_speed * 0.7);
    float n4 = noise((uv + 4.567) * 10.0 - TIME * noise_speed * 0.3);
    return vec4(n, n2, n3, n4);
}

// Fake "screen texture" as a simple color gradient
vec4 get_screen_color(vec2 uv) {
    return vec4(uv, 1.0 - uv.x, 1.0);
}

float compute_z_radius(vec2 pos, float r) {
    vec3 o = vec3(pos, -1.);
    return -sqrt(1. - dot(o, o) + (r * r));
}

float compute_front_z(vec2 pos) {
    vec3 p = vec3(pos, -1.);
    return (-sqrt(2. - dot(p, p)));
}

void main()
{
    // Use VertexInput.TexCoords as UV
    vec2 UV = VertexInput.TexCoords;
    // For SCREEN_UV, assume UV (if not using MSAA or screen-space effects)
    vec2 SCREEN_UV = UV;

    // Sphere computation
    vec2 current_pos = (UV - 0.5) * (2.0 * zoom_out);
    float len = length(current_pos);
    vec2 attack_direction = vec2(cos(attack_angle), sin(attack_angle));
    vec4 noise_texel = get_noise_texel(current_pos + TIME * attack_direction * noise_speed);
    vec4 noise_amount = (noise_texel * (1. - noise_amplitude)) + noise_amplitude;
    float noise_mask = (noise_amount.r + noise_amount.g + noise_amount.b) / 3.0;
    float amplitude_decay = (1. + attack_amplitude) * border_decay * noise_mask;
    float border_mask = clamp(len - amplitude_decay, 0., 1. - border_decay) / (1. - border_decay);
    float mask = clamp(ceil(noise_mask * (1. + attack_amplitude) - len), 0., 1.);
    vec4 shield_color = mix(shield_saturation, shield_tint, 1. - border_mask) * mask;
    vec2 deformation_mask = (noise_texel.rg - vec2(.5)) * 2. * mask;

    // Waves
    if(len <= 1. + attack_amplitude) {
        vec2 attack_norm = attack_direction * (1. - attack_penetration);
        vec3 attack_position = vec3(attack_norm, compute_front_z(attack_norm));
        float retained_len = 0.;
        float retained_intensity = 0.;
        float z_step = compute_z_radius(current_pos, 1. + attack_amplitude);
        float hdiff = 1. + attack_amplitude;
        float min_diff = hdiff;
        int step_id = STEPS;
        for(int i = 0; i < STEPS; ++i) {
            vec3 current_projection = vec3(current_pos, z_step);
            vec3 pos_on_surface = normalize(current_projection);
            float att_len = length(attack_position - pos_on_surface);
            if(att_len < attack_radius) {
                float intensity = (cos(att_len * wave_num - TIME * wave_speed) + 1.)/2. * cos((att_len / attack_radius) * MPI);
                hdiff = abs(length(current_projection) - 1. - (intensity * attack_amplitude));
                if(hdiff < min_diff) {
                    retained_intensity = intensity;
                    retained_len = att_len;
                    min_diff = hdiff;
                    if (hdiff < LOWER_LIMIT) {
                        break;
                    }
                }
                float extra = pos_on_surface.z * (1. + (intensity * attack_amplitude));
                z_step += (extra - z_step) * (1. - (float(i) / float(STEPS)));
            } else {
                break;
            }
        }
        if ((hdiff < LOWER_LIMIT) || ((step_id == STEPS) && (min_diff < (1.0 + attack_amplitude)))) {
            float attenuation = cos(((1. - (len / attack_radius))) * MPI);
            shield_color = mask*mix(shield_color, shield_saturation, retained_intensity);
            deformation_mask = mask*mix(current_pos * (1. - retained_intensity), deformation_mask, cos(((1. - (len / attack_radius))) * MPI));
        }
    }

    vec4 screen_color = get_screen_color(SCREEN_UV + (noise_deformation * deformation_mask * SCREEN_PIXEL_SIZE));
    FragColor = vec4(mix(screen_color.rgb, shield_color.rgb, shield_color.a), 1.0);
    EntityID = vec4(entityID, 1.0f);
}