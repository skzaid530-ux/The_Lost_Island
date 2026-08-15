extends Node

signal objective_changed(title: String, description: String)
signal objective_completed(objective_id: String)

var current_objective_id: String = ""
var current_title: String = ""
var current_description: String = ""

var _completed: Dictionary = {}


func _ready() -> void:
	var event_bus := get_node_or_null("/root/InteractionEventBus")

	if event_bus:
		event_bus.discovery_triggered.connect(_on_discovery_triggered)

	start_objective(
		"explore_forgotten_beach",
		"EXPLORE THE FORGOTTEN BEACH",
		"Search the beach and investigate anything unusual."
	)


func start_objective(
	objective_id: String,
	title: String,
	description: String
) -> void:
	if objective_id.is_empty():
		return

	if _completed.get(objective_id, false):
		return

	current_objective_id = objective_id
	current_title = title
	current_description = description

	objective_changed.emit(title, description)

	print("OBJECTIVE STARTED: ", objective_id)
	print("OBJECTIVE: ", title)


func complete_objective(objective_id: String) -> bool:
	if objective_id.is_empty():
		return false

	if _completed.get(objective_id, false):
		return false

	_completed[objective_id] = true

	objective_completed.emit(objective_id)

	print("OBJECTIVE COMPLETED: ", objective_id)

	return true


func is_completed(objective_id: String) -> bool:
	return _completed.get(objective_id, false)


func _on_discovery_triggered(
	discovery_id: String,
	_actor: Node3D
) -> void:
	if current_objective_id != "explore_forgotten_beach":
		return

	if (
		discovery_id != "forgotten_beach_strange_stone"
		and discovery_id != "forgotten_beach_wreckage"
	):
		return

	var event_bus := get_node_or_null("/root/InteractionEventBus")

	if event_bus == null:
		return

	if not event_bus.has_discovered("forgotten_beach_strange_stone"):
		return

	if not event_bus.has_discovered("forgotten_beach_wreckage"):
		return

	if complete_objective("explore_forgotten_beach"):
		start_objective(
			"search_wreckage_clues",
			"SEARCH THE WRECKAGE FOR CLUES",
			"Examine the fresh wreckage and find out who was here."
		)
