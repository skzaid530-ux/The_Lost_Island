class_name MobileHUD
extends CanvasLayer

@onready var joystick_base: Control = $Controls/JoystickBase
@onready var joystick_knob: Control = $Controls/JoystickBase/Knob

var joystick_touch_id: int = -1
var joystick_center: Vector2
var joystick_radius: float = 82.0

func _ready() -> void:
	joystick_center = joystick_base.position + joystick_base.size * 0.5
	joystick_knob.position = joystick_base.size * 0.5 - joystick_knob.size * 0.5

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _handle_touch(event: InputEventScreenTouch) -> void:
	var position := event.position

	if event.pressed:
		if joystick_touch_id == -1 and joystick_base.get_global_rect().has_point(position):
			joystick_touch_id = event.index
			_update_joystick(position)
		elif _is_jump_button(position):
			MobileInput.request_jump()
		elif _is_interact_button(position):
			MobileInput.request_interact()
		elif _is_sprint_button(position):
			MobileInput.set_sprint(true)
	else:
		if event.index == joystick_touch_id:
			joystick_touch_id = -1
			_reset_joystick()

		if _is_sprint_button(position):
			MobileInput.set_sprint(false)

func _handle_drag(event: InputEventScreenDrag) -> void:
	if event.index == joystick_touch_id:
		_update_joystick(event.position)

func _update_joystick(screen_position: Vector2) -> void:
	var center := joystick_base.get_global_position() + joystick_base.size * 0.5
	var offset := screen_position - center

	if offset.length() > joystick_radius:
		offset = offset.normalized() * joystick_radius

	MobileInput.set_move(offset / joystick_radius)

	joystick_knob.position = (
		joystick_base.size * 0.5
		+ offset
		- joystick_knob.size * 0.5
	)

func _reset_joystick() -> void:
	MobileInput.set_move(Vector2.ZERO)
	joystick_knob.position = (
		joystick_base.size * 0.5
		- joystick_knob.size * 0.5
	)

func _is_jump_button(position: Vector2) -> bool:
	var button: Control = $Controls/JumpButton
	return button.get_global_rect().has_point(position)

func _is_sprint_button(position: Vector2) -> bool:
	var button: Control = $Controls/SprintButton
	return button.get_global_rect().has_point(position)

func _is_interact_button(position: Vector2) -> bool:
	var button: Control = $Controls/InteractButton
	return button.get_global_rect().has_point(position)
