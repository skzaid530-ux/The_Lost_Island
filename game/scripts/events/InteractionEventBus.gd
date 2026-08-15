extends Node

signal interaction_started(interactable: Node3D, actor: Node3D)
signal interaction_completed(interactable: Node3D, actor: Node3D)
signal discovery_triggered(discovery_id: String, actor: Node3D)

var _discoveries: Dictionary = {}
var _feedback: Node = null


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

    if is_instance_valid(_feedback):
        _feedback.show_discovery(
            "DISCOVERY FOUND",
            _get_discovery_message(discovery_id)
        )
    return true


func has_discovered(discovery_id: String) -> bool:
    return _discoveries.get(discovery_id, false)


func reset_discoveries() -> void:
    _discoveries.clear()


func _get_discovery_message(discovery_id: String) -> String:
    match discovery_id:
        "forgotten_beach_strange_stone":
            return "The markings are unfamiliar. Someone was here before Kael."
        "forgotten_beach_wreckage":
            return "The wreckage is fresh. A torn piece of cloth suggests someone may still be nearby."
        _:
            return "Something about this place feels strangely familiar."


func register_feedback(feedback: Node) -> void:
    _feedback = feedback
