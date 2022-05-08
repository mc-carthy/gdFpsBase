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
