class_name MobileInput
extends Node

static var move_vector: Vector2 = Vector2.ZERO
static var camera_vector: Vector2 = Vector2.ZERO
static var jump_requested: bool = false
static var interact_requested: bool = false
static var sprint_pressed: bool = false

static func set_move(value: Vector2) -> void:
	move_vector = value.limit_length(1.0)

static func set_camera(value: Vector2) -> void:
	camera_vector = value

static func request_jump() -> void:
	jump_requested = true

static func consume_jump() -> bool:
	if jump_requested:
		jump_requested = false
		return true
	return false

static func request_interact() -> void:
	interact_requested = true

static func consume_interact() -> bool:
	if interact_requested:
		interact_requested = false
		return true
	return false

static func set_sprint(value: bool) -> void:
	sprint_pressed = value

static func reset() -> void:
	move_vector = Vector2.ZERO
	camera_vector = Vector2.ZERO
	jump_requested = false
	interact_requested = false
	sprint_pressed = false
