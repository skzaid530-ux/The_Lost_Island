class_name InputManager
extends Node

static func get_move_vector() -> Vector2:
	var keyboard := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	if keyboard.length_squared() > 0.001:
		return keyboard.limit_length(1.0)

	return MobileInput.move_vector

static func is_sprinting() -> bool:
	return Input.is_key_pressed(KEY_SHIFT) or MobileInput.sprint_pressed

static func consume_jump() -> bool:
	if Input.is_action_just_pressed("jump"):
		return true

	return MobileInput.consume_jump()
