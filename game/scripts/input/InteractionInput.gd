class_name InteractionInput
extends Node

static var interact_requested: bool = false

static func request_interact() -> void:
        interact_requested = true

static func consume_interact() -> bool:
        if interact_requested:
                interact_requested = false
                return true

        return false

static func reset() -> void:
        interact_requested = false
