extends Node

signal story_started(story_id: String)
signal story_ended(story_id: String)
signal dialogue_started(character: String, text: String)
signal dialogue_finished(character: String, text: String)
signal story_state_changed(state: String)

signal discovery_story_started(discovery_id: String)

var _discovery_reactions: Dictionary = {
    "forgotten_beach_strange_stone": false,
    "forgotten_beach_wreckage": false,
}

var current_story_id: String = ""
var current_state: String = "idle"
var _completed_stories: Dictionary = {}
var _running: bool = false


func _ready() -> void:
    print("STORY MANAGER: READY")

    var event_bus := get_node_or_null("/root/InteractionEventBus")
    if event_bus:
        event_bus.discovery_triggered.connect(_on_discovery_triggered)


func play_story(story_id: String) -> bool:
    if story_id.is_empty():
        return false

    if _running:
        return false

    if _completed_stories.get(story_id, false):
        return false

    _running = true
    _set_player_control(false)

    current_story_id = story_id
    current_state = "starting"

    story_started.emit(story_id)
    story_state_changed.emit(current_state)

    print("STORY STARTED: ", story_id)

    match story_id:
        "kael_wakes":
            await _play_kael_wakes()
        _:
            print("STORY NOT FOUND: ", story_id)
            _running = false
            current_state = "idle"
            return false

    _completed_stories[story_id] = true
    current_state = "completed"

    story_state_changed.emit(current_state)
    story_ended.emit(story_id)

    print("STORY COMPLETED: ", story_id)

    _running = false
    current_state = "idle"

    return true


func is_busy() -> bool:
    return _running


func _set_player_control(enabled: bool) -> void:
    var player := get_tree().get_first_node_in_group("player")

    if player and player.has_method("set_movement_enabled"):
        player.set_movement_enabled(enabled)


func is_completed(story_id: String) -> bool:
    return _completed_stories.get(story_id, false)


func reset_story(story_id: String) -> void:
    _completed_stories.erase(story_id)


func reset_all_stories() -> void:
    _completed_stories.clear()


func _play_kael_wakes() -> void:
    current_state = "opening"
    story_state_changed.emit(current_state)

    await _say("KAEL", "Where... am I?")

    await get_tree().create_timer(0.8).timeout

    await _say("KAEL", "My head...")

    await get_tree().create_timer(0.7).timeout

    await _say("KAEL", "I don't remember the crash.")

    await get_tree().create_timer(0.8).timeout

    await _say("KAEL", "The sea. The storm...")

    await get_tree().create_timer(0.9).timeout

    await _say("KAEL", "Someone brought me here.")

    await get_tree().create_timer(0.8).timeout

    current_state = "exploration_unlocked"
    story_state_changed.emit(current_state)
    _set_player_control(true)


func _say(character: String, text: String) -> void:
    print("STORY SAY START: ", character, ": ", text)

    var dialogue_ui := get_tree().get_first_node_in_group("story_dialogue")

    if dialogue_ui and dialogue_ui.has_method("play_dialogue"):
        await dialogue_ui.play_dialogue(character, text)
    else:
        print("WARNING: StoryDialogue UI not available")
        dialogue_started.emit(character, text)

    print("STORY SAY FINISHED: ", character, ": ", text)


func _on_discovery_triggered(discovery_id: String, _actor: Node3D) -> void:
    if _discovery_reactions.get(discovery_id, false):
        return

    # Do not interrupt the opening cinematic.
    if _running:
        return

    _discovery_reactions[discovery_id] = true
    discovery_story_started.emit(discovery_id)

    match discovery_id:
        "forgotten_beach_strange_stone":
            await _play_strange_stone_reaction()

        "forgotten_beach_wreckage":
            await _play_wreckage_reaction()


func _play_strange_stone_reaction() -> void:
    _running = true
    current_story_id = "stone_discovery"
    current_state = "discovery"
    story_state_changed.emit(current_state)

    print("STORY STARTED: stone_discovery")

    await _say("KAEL", "These markings...")
    await _say("KAEL", "They're not natural.")
    await _say("KAEL", "Someone carved this.")

    current_state = "exploration"
    story_state_changed.emit(current_state)
    _set_player_control(true)

    print("STORY COMPLETED: stone_discovery")
    _running = false
    current_story_id = ""


func _play_wreckage_reaction() -> void:
    _running = true
    current_story_id = "wreckage_discovery"
    current_state = "discovery"
    story_state_changed.emit(current_state)

    print("STORY STARTED: wreckage_discovery")

    await _say("KAEL", "The wreckage is fresh.")
    await _say("KAEL", "This wasn't here for long.")
    await _say("KAEL", "And that means I'm not alone.")

    current_state = "clue_search"
    story_state_changed.emit(current_state)
    _set_player_control(true)

    print("STORY COMPLETED: wreckage_discovery")
    _running = false
    current_story_id = ""
