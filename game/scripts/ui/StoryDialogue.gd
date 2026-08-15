class_name StoryDialogue
extends CanvasLayer

var panel: PanelContainer
var character_label: Label
var dialogue_label: Label
var continue_label: Label
var backdrop: ColorRect
var input_receiver: Control

var _visible: bool = false
var _typing: bool = false
var _waiting_for_advance: bool = false
var _advance_requested: bool = false

var _story_manager: Node = null
var _dialogue_completed: bool = false
var _dialogue_serial: int = 0


func _ready() -> void:
    layer = 100
    add_to_group("story_dialogue")

    _build_ui()
    hide_dialogue()

    _story_manager = get_node_or_null("/root/StoryManager")

    if _story_manager:
        _story_manager.dialogue_started.connect(_on_dialogue_started)
        _story_manager.story_ended.connect(_on_story_ended)

    print("STORY DIALOGUE: READY")


func _on_dialogue_started(character: String, text: String) -> void:
    print("DIALOGUE UI: SHOW REQUEST -> ", character, ": ", text)
    show_dialogue(character, text)


func _on_story_ended(_story_id: String) -> void:
    hide_dialogue()


func _build_ui() -> void:
    backdrop = ColorRect.new()
    backdrop.color = Color(0.0, 0.0, 0.0, 0.0)
    backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(backdrop)

    input_receiver = Control.new()
    input_receiver.name = "DialogueInputReceiver"
    input_receiver.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    input_receiver.mouse_filter = Control.MOUSE_FILTER_STOP
    input_receiver.gui_input.connect(_on_gui_input)
    add_child(input_receiver)

    panel = PanelContainer.new()
    panel.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
    panel.position = Vector2(-540, -205)
    panel.size = Vector2(1080, 165)
    panel.modulate.a = 0.0
    panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.015, 0.018, 0.022, 0.94)

    style.border_width_left = 2
    style.border_width_top = 2
    style.border_width_right = 2
    style.border_width_bottom = 2

    style.border_color = Color(0.78, 0.68, 0.38, 0.72)

    style.corner_radius_top_left = 12
    style.corner_radius_top_right = 12
    style.corner_radius_bottom_left = 12
    style.corner_radius_bottom_right = 12

    style.content_margin_left = 30.0
    style.content_margin_right = 30.0
    style.content_margin_top = 20.0
    style.content_margin_bottom = 18.0

    panel.add_theme_stylebox_override("panel", style)

    var container := VBoxContainer.new()
    container.add_theme_constant_override("separation", 8)

    character_label = Label.new()
    character_label.add_theme_font_size_override("font_size", 18)
    character_label.text = "KAEL"

    dialogue_label = Label.new()
    dialogue_label.add_theme_font_size_override("font_size", 25)
    dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    dialogue_label.custom_minimum_size = Vector2(1000, 65)

    continue_label = Label.new()
    continue_label.text = "TAP TO CONTINUE"
    continue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    continue_label.add_theme_font_size_override("font_size", 13)
    continue_label.modulate.a = 0.55

    container.add_child(character_label)
    container.add_child(dialogue_label)
    container.add_child(continue_label)

    panel.add_child(container)
    add_child(panel)


func play_dialogue(character: String, text: String) -> void:
    _dialogue_completed = false

    show_dialogue(character, text)

    while not _dialogue_completed:
        await get_tree().process_frame


func show_dialogue(character: String, text: String) -> void:
    # Ignore duplicate show requests while this dialogue is active.
    if _visible:
        print("DIALOGUE UI: DUPLICATE SHOW IGNORED")
        return

    _dialogue_serial += 1
    var my_serial := _dialogue_serial

    _visible = true
    _typing = true
    _waiting_for_advance = false
    _advance_requested = false

    character_label.text = character
    dialogue_label.text = ""
    continue_label.visible = false

    panel.visible = true
    panel.modulate.a = 0.0
    backdrop.color = Color(0.0, 0.0, 0.0, 0.0)

    input_receiver.mouse_filter = Control.MOUSE_FILTER_STOP

    var fade := create_tween()
    fade.set_parallel(true)
    fade.set_trans(Tween.TRANS_QUAD)
    fade.set_ease(Tween.EASE_OUT)

    fade.tween_property(panel, "modulate:a", 1.0, 0.3)
    fade.tween_property(backdrop, "color:a", 0.28, 0.3)

    await fade.finished

    if my_serial != _dialogue_serial:
        return

    # Fast frame-based typewriter effect.
    var type_speed := 90.0
    var visible_characters := 0.0

    while visible_characters < text.length():
        if _advance_requested:
            break

        visible_characters += type_speed * get_process_delta_time()
        dialogue_label.visible_characters = min(
            int(visible_characters),
            text.length()
        )

        await get_tree().process_frame

    if my_serial != _dialogue_serial:
        return

    # Always show the complete line.
    dialogue_label.text = text
    dialogue_label.visible_characters = -1
    _typing = false
    continue_label.visible = true

    # If the player tapped during typing, that tap completes the line.
    if _advance_requested:
        print("DIALOGUE UI: TAP DURING TYPING -> COMPLETE")
        _advance_requested = false
        _finish_dialogue(character, text)
        return

    # Wait for a completely new tap.
    _waiting_for_advance = true

    print("DIALOGUE UI: WAITING FOR NEXT TAP")

    while _waiting_for_advance:
        await get_tree().process_frame

    if my_serial != _dialogue_serial:
        return

    _advance_requested = false
    _finish_dialogue(character, text)


func _finish_dialogue(character: String, text: String) -> void:
    if not _visible:
        return

    print("DIALOGUE UI: FINISH -> ", character, ": ", text)

    _waiting_for_advance = false
    _typing = false

    _dialogue_completed = true

    hide_dialogue()


func hide_dialogue() -> void:
    _dialogue_serial += 1

    _visible = false
    _typing = false
    _waiting_for_advance = false
    _advance_requested = false

    if panel:
        panel.visible = false
        panel.modulate.a = 0.0

    if backdrop:
        backdrop.color.a = 0.0


func is_showing() -> bool:
    return _visible


func _on_gui_input(event: InputEvent) -> void:
    if not _visible:
        return

    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            print("DIALOGUE INPUT: MOUSE CLICK RECEIVED")

            if _typing:
                _advance_requested = true
            elif _waiting_for_advance:
                _waiting_for_advance = false
                _advance_requested = true

            get_viewport().set_input_as_handled()

    elif event is InputEventScreenTouch:
        if event.pressed:
            print("DIALOGUE INPUT: SCREEN TOUCH RECEIVED")

            if _typing:
                _advance_requested = true
            elif _waiting_for_advance:
                _waiting_for_advance = false
                _advance_requested = true

            get_viewport().set_input_as_handled()


func _input(event: InputEvent) -> void:
    if not _visible:
        return

    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
            print("DIALOGUE INPUT: KEY RECEIVED")

            if _typing:
                _advance_requested = true
            elif _waiting_for_advance:
                _waiting_for_advance = false
                _advance_requested = true

            get_viewport().set_input_as_handled()
