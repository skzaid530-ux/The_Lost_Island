class_name BeachInteractable
extends Interactable

@export_category("Beach Interaction")
@export var interaction_message: String = "You found something."
@export var discovery_id: String = ""


func _get_event_bus() -> Node:
    return get_node_or_null("/root/InteractionEventBus")


func interact(actor: Node3D) -> void:
    var event_bus := _get_event_bus()

    if event_bus:
        event_bus.emit_interaction_started(self, actor)

    var discovery_triggered := false

    if not discovery_id.is_empty() and event_bus:
        discovery_triggered = event_bus.trigger_discovery(
            discovery_id,
            actor
        )

    print(
        "BEACH INTERACTION: ",
        interaction_message,
        " | Actor: ", actor.name,
        " | Discovery: ", discovery_triggered
    )

    if event_bus:
        event_bus.emit_interaction_completed(self, actor)
