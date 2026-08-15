class_name Interactable
extends Node3D

@export_category("Interaction")
@export var interaction_name: String = "Interact"
@export var interaction_range: float = 3.0
@export var enabled: bool = true


func _ready() -> void:
    add_to_group("interactable")


func can_interact(_actor: Node3D) -> bool:
    return enabled


func interact(_actor: Node3D) -> void:
    print("INTERACTION: ", interaction_name)


func get_interaction_prompt() -> String:
    return interaction_name
