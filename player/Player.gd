extends KinematicBody

export var max_speed: int = 12
export var acceleration: int = 60
export var friction: int = 50
export var air_friction: int = 10
export var jump_impulse: int = 20
export var gravity: int = -40

export var mouse_sensitivity: float = 0.1
export var controller_sensitivity: float = 3.0

var velocity: Vector3 = Vector3.ZERO
var snap_vector: Vector3 = Vector3.ZERO

onready var head: Spatial = $Head

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('click'):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed('toggle_mouse_mode'):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))

func _physics_process(delta: float) -> void:
	var input_vector: Vector3 = get_input_vector()
	var direction: Vector3 = get_direction(input_vector)
	apply_movement(direction, delta)
	apply_gravity(delta)
	apply_friction(direction, delta)
	# Move this jump functionality into input function
	jump()
	velocity = move_and_slide(velocity, Vector3.UP)

func get_input_vector() -> Vector3:
	var input_vector: Vector3 = Vector3.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	
	return input_vector.normalized() if input_vector.length() > 1 else input_vector

func get_direction(input_vector: Vector3) -> Vector3:
	var direction = Vector3.ZERO
	
	direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	
	return direction

func apply_movement(direction: Vector3, delta: float) -> void:
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z

func apply_friction(direction: Vector3, delta: float) -> void:
	if direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(direction * max_speed, air_friction * delta).x
			velocity.z = velocity.move_toward(direction * max_speed, air_friction * delta).z

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jump_impulse)

func jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse / 2:
		velocity.y = jump_impulse / 2
