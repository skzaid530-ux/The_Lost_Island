extends Node

signal interaction_started(interactable: Node3D, actor: Node3D)
signal interaction_completed(interactable: Node3D, actor: Node3D)
signal discovery_triggered(discovery_id: String, actor: Node3D)

var _discoveries: Dictionary = {}


func emit_interaction_started(
        interactable: Node3D,
        actor: Node3D
) -> void:
    interaction_started.emit(interactable, actor)


func emit_interaction_completed(
        interactable: Node3D,
        actor: Node3D
) -> void:
    interaction_completed.emit(interactable, actor)


func trigger_discovery(
        discovery_id: String,
        actor: Node3D
) -> bool:
    if discovery_id.is_empty():
        return false

    if _discoveries.get(discovery_id, false):
        return false

    _discoveries[discovery_id] = true
    discovery_triggered.emit(discovery_id, actor)

    print("DISCOVERY TRIGGERED: ", discovery_id)
    return true


func has_discovered(discovery_id: String) -> bool:
    return _discoveries.get(discovery_id, false)


func reset_discoveries() -> void:
    _discoveries.clear()
