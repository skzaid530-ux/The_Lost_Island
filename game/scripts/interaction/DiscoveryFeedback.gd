class_name DiscoveryFeedback
extends CanvasLayer

var label: Label


func _ready() -> void:
    var event_bus := get_node_or_null("/root/InteractionEventBus")
    if event_bus:
        event_bus.register_feedback(self)
    label = Label.new()
    label.name = "DiscoveryLabel"
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    label.position = Vector2(-420, -80)
    label.size = Vector2(840, 160)
    label.add_theme_font_size_override("font_size", 28)
    label.visible = false
    add_child(label)


func show_discovery(title: String, message: String) -> void:
    label.text = title + "\n\n" + message
    label.visible = true

    await get_tree().create_timer(4.0).timeout

    if is_instance_valid(label):
        label.visible = false
