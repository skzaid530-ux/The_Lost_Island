class_name KaelInteraction
extends Node

const INTERACTABLE_SCRIPT = preload("res://game/scripts/interaction/Interactable.gd")
const PROMPT_SCRIPT = preload("res://game/scripts/interaction/InteractionPrompt.gd")

@export_category("Detection")
@export var detection_range: float = 3.0
@export var detection_radius: float = 0.75

var current_target: Node3D = null
var prompt: Node = null

@onready var actor: Node3D = get_parent()



func _ready() -> void:
    prompt = PROMPT_SCRIPT.new()
    prompt.name = "InteractionPrompt"
    actor.get_tree().root.add_child.call_deferred(prompt)


func _physics_process(_delta: float) -> void:
    _update_target()

    if InputManager.consume_interact():
        _try_interact()


func _update_target() -> void:
    var nearest: Node3D = null
    var nearest_distance: float = detection_range

    for node in get_tree().get_nodes_in_group("interactable"):
        if not is_instance_valid(node):
            continue

        if not node is Node3D:
            continue

        if not node.has_method("can_interact"):
            continue

        if not node.has_method("get_interaction_prompt"):
            continue

        if not node.has_method("interact"):
            continue

        var interactable: Node3D = node

        if not interactable.can_interact(actor):
            continue

        var distance: float = actor.global_position.distance_to(
            interactable.global_position
        )

        if distance <= nearest_distance:
            nearest = interactable
            nearest_distance = distance

    if nearest != current_target:
        current_target = nearest

        if current_target:
            var prompt_text: String = current_target.get_interaction_prompt()
            print("INTERACTION TARGET: ", prompt_text)
            if is_instance_valid(prompt):
                prompt.show_prompt(prompt_text)
        else:
            print("INTERACTION TARGET: NONE")
            if is_instance_valid(prompt):
                prompt.hide_prompt()


func _try_interact() -> void:
    if not is_instance_valid(current_target):
        return

    var distance: float = actor.global_position.distance_to(
        current_target.global_position
    )

    if distance <= current_target.interaction_range:
        current_target.interact(actor)


func has_target() -> bool:
    return is_instance_valid(current_target)


func get_current_target() -> Node3D:
    if not is_instance_valid(current_target):
        return null

    return current_target
