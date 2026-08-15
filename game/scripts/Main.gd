extends Node3D


func _ready() -> void:
    print("================================")
    print("THE LOST ISLAND")
    print("FORGOTTEN BEACH")
    print("================================")
    print("Player: Kael")
    print("Movement system: READY")
    print("Beach environment: READY")
    print("Playable slice: BOOTING")

    var story_manager := get_node_or_null("/root/StoryManager")

    if story_manager:
        print("STORY SYSTEM: CONNECTED")

        story_manager.story_ended.connect(_on_story_ended)
        story_manager.discovery_story_started.connect(_on_discovery_story_started)

        await get_tree().process_frame
        await get_tree().process_frame

        if not story_manager.is_completed("kael_wakes"):
            story_manager.play_story("kael_wakes")
    else:
        print("WARNING: STORY MANAGER NOT FOUND")


func _on_discovery_story_started(discovery_id: String) -> void:
    print("DISCOVERY STORY: ", discovery_id)


func _on_story_ended(story_id: String) -> void:
    if story_id == "kael_wakes":
        print("OPENING STORY: COMPLETE")
        print("PLAYER CONTROL: AVAILABLE")
