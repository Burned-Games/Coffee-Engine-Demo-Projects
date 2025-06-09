-- Log functions
function log(message) end
function log_warning(message) end
function log_error(message) end
function log_critical(message) end

-- Input functions
Input = {
    keycode = {},
    mousecode = {},
    controllercode = {},
    axiscode = {},
    action = {},
    state = {},
    is_key_pressed = function(key) end,
    is_mouse_button_pressed = function(button) end,
    is_button_pressed = function(button) end,
    get_axis_position = function(axis) end,
    get_mouse_position = function() return 0, 0 end,
    get_axis = function(action) end,
    get_direction = function(action) end,
    get_button = function(action) end
}

-- Timer and Stopwatch classes
Stopwatch = {
    start = function() end,
    stop = function() end,
    reset = function() end,
    get_elapsed_time = function() end,
    get_precise_elapsed_time = function() end
}

Timer = {
    start = function() end,
    stop = function() end,
    set_wait_time = function(time) end,
    get_wait_time = function() end,
    set_one_shot = function(oneShot) end,
    is_one_shot = function() end,
    set_auto_start = function(autoStart) end,
    is_auto_start = function() end,
    set_paused = function(paused) end,
    is_paused = function() end,
    get_time_left = function() end,
    set_callback = function(callback) end
}

function create_timer(waitTime, autoStart, oneShot, callback) end

-- GLM functions
Vector2 = {
    x = 0,
    y = 0,
    normalize = function(a) return a end,
    length = function(a) return 0 end,
    length_squared = function(a) return 0 end,
    distance_to = function(a, b) return 0 end,
    distance_squared_to = function(a, b) return 0 end,
    lerp = function(a, b, t) return a end,
    dot = function(a, b) return 0 end,
    angle_to = function(a, b) return 0 end,
    max = function(a, b) return a end,
    min = function(a, b) return a end,
    abs = function(a) return a end
}

Vector3 = {
    x = 0,
    y = 0,
    z = 0,
    cross = function(a, b) return a end,
    dot = function(a, b) return 0 end,
    normalize = function(a) return a end,
    length = function(a) return 0 end,
    length_squared = function(a) return 0 end,
    distance_to = function(a, b) return 0 end,
    distance_squared_to = function(a, b) return 0 end,
    lerp = function(a, b, t) return a end,
    dot = function(a, b) return 0 end,
    angle_to = function(a, b) return 0 end,
    max = function(a, b) return a end,
    min = function(a, b) return a end,
    abs = function(a) return a end
}

Vector4 = {
    x = 0,
    y = 0,
    z = 0,
    w = 0,
    normalize = function(a) return a end,
    length = function(a) return 0 end,
    length_squared = function(a) return 0 end,
    distance_to = function(a, b) return 0 end,
    distance_squared_to = function(a, b) return 0 end,
    lerp = function(a, b, t) return a end,
    dot = function(a, b) return 0 end,
    angle_to = function(a, b) return 0 end,
    max = function(a, b) return a end,
    min = function(a, b) return a end,
    abs = function(a) return a end
}

Mat4 = {
    identity = function() return {} end,
    inverse = function(mat) return mat end,
    transpose = function(mat) return mat end,
    translate = function(mat, vec) return mat end,
    rotate = function(mat, angle, axis) return mat end,
    scale = function(mat, vec) return mat end,
    perspective = function(fovy, aspect, nearPlane, farPlane) return {} end,
    ortho = function(left, right, bottom, top, zNear, zFar) return {} end
}

Quaternion = {
    x = 0,
    y = 0,
    z = 0,
    w = 0,
    from_euler = function(euler) return {} end,
    to_euler_angles = function(q) return {} end,
    toMat4 = function(q) return {} end,
    normalize = function(q) return q end,
    slerp = function(a, b, t) return a end
}

-- Entity functions
Entity = {
    add_component = function(self, componentName) end,
    get_component = function(self, componentName) return {} end,
    has_component = function(self, componentName) return false end,
    remove_component = function(self, componentName) end,
    set_parent = function(self, parent) end,
    get_parent = function(self) return {} end,
    get_next_sibling = function(self) return {} end,
    get_prev_sibling = function(self) return {} end,
    get_child = function(self, index) return {} end,
    get_children = function(self) return {} end,
    is_valid = function(self) return false end
}

-- Components functions
TagComponent = {
    tag = ""
}

TransformComponent = {
    position = {},
    rotation = {},
    scale = {},
    get_local_transform = function() return {} end,
    set_local_transform = function(transform) end,
    get_world_transform = function() return {} end,
    set_world_transform = function(transform) end
}

CameraComponent = {
    camera = {}
}

MeshComponent = {
    mesh = {},
    drawAABB = false,
    get_mesh = function() return {} end
}

MaterialComponent = {
    material = {}
}

LightComponent = {
    color = {},
    direction = {},
    position = {},
    range = 0,
    attenuation = 0,
    intensity = 0,
    angle = 0,
    type = 0
}

NavigationAgentComponent = {
    path = {},
    find_path = function() end
}

ScriptComponent = {
    __index = function(self, key) return {} end,
    __newindex = function(self, key, value) end,
    __call = function(self, functionName, ...) end
}

ParticlesSystemComponent = {
    emit = function() end,
    set_looping = function(looping) end,
    get_emitter = function() return {} end
}

RigidbodyComponent = {
    rb = {},
    on_collision_enter = function(self, fn) end,
    on_collision_stay = function(self, fn) end,
    on_collision_exit = function(self, fn) end
}

AnimatorComponent = {
    set_current_animation = function(self, animation) end
}

AudioSourceComponent = {
    set_volume = function(self, volume) end,
    play = function(self) end,
    pause = function(self) end
}

-- Scene functions
Scene = {
    create_entity = function(self) return {} end,
    destroy_entity = function(self, entity) end,
    duplicate_entity = function(self, entity) return {} end,
    get_entity_by_name = function(self, name) return {} end,
    get_all_entities = function(self) return {} end
}

SceneManager = {
    preload_scene = function(scenePath) return {} end,
    preload_scene_async = function(scenePath) return {} end,
    change_scene = function(scenePath) end,
    change_scene_async = function(scenePath) end
}

-- Physics functions
RigidBodyType = {
    Static = 0,
    Dynamic = 1,
    Kinematic = 2
}

RigidBodyProperties = {
    type = 0,
    mass = 0,
    useGravity = false,
    freezeX = false,
    freezeY = false,
    freezeZ = false,
    freezeRotX = false,
    freezeRotY = false,
    freezeRotZ = false,
    isTrigger = false,
    velocity = {},
    friction = 0,
    linearDrag = 0,
    angularDrag = 0
}

RigidBody = {
    set_position = function(self, position) end,
    get_position = function(self) return {} end,
    set_rotation = function(self, rotation) end,
    get_rotation = function(self) return {} end,
    set_velocity = function(self, velocity) end,
    get_velocity = function(self) return {} end,
    add_velocity = function(self, velocity) end,
    apply_force = function(self, force) end,
    apply_impulse = function(self, impulse) end,
    reset_velocity = function(self) end,
    clear_forces = function(self) end,
    apply_torque = function(self, torque) end,
    apply_torque_impulse = function(self, torqueImpulse) end,
    set_angular_velocity = function(self, angularVelocity) end,
    get_angular_velocity = function(self) return {} end,
    set_trigger = function(self, isTrigger) end,
    get_body_type = function(self) return 0 end,
    set_body_type = function(self, bodyType) end,
    get_mass = function(self) return 0 end,
    set_mass = function(self, mass) end,
    get_use_gravity = function(self) return false end,
    set_use_gravity = function(self, useGravity) end,
    get_freeze_x = function(self) return false end,
    set_freeze_x = function(self, freezeX) end,
    get_freeze_y = function(self) return false end,
    set_freeze_y = function(self, freezeY) end,
    get_freeze_z = function(self) return false end,
    set_freeze_z = function(self, freezeZ) end,
    get_freeze_rot_x = function(self) return false end,
    set_freeze_rot_x = function(self, freezeRotX) end,
    get_freeze_rot_y = function(self) return false end,
    set_freeze_rot_y = function(self, freezeRotY) end,
    get_freeze_rot_z = function(self) return false end,
    set_freeze_rot_z = function(self, freezeRotZ) end,
    get_friction = function(self) return 0 end,
    set_friction = function(self, friction) end,
    get_linear_drag = function(self) return 0 end,
    set_linear_drag = function(self, linearDrag) end,
    get_angular_drag = function(self) return 0 end,
    set_angular_drag = function(self, angularDrag) end,
    get_is_trigger = function(self) return false end
}

Collider = {}

BoxCollider = {
    __base = Collider
}

SphereCollider = {
    __base = Collider
}

CapsuleCollider = {
    __base = Collider
}

function create_box_collider(size) return {} end
function create_sphere_collider(radius) return {} end
function create_capsule_collider(radius, height) return {} end
function create_rigidbody(props, collider) return {} end

Physics = {
    Raycast = function(origin, direction, maxDistance) return {} end,
    RaycastAll = function(origin, direction, maxDistance) return {} end,
    RaycastAny = function(origin, direction, maxDistance) return false end,
    DebugDrawRaycast = function(origin, direction, maxDistance, rayColor, hitColor) end
}

RaycastHit = {
    hasHit = false,
    hitEntity = {},
    hitPoint = {},
    hitNormal = {},
    hitFraction = 0
}
