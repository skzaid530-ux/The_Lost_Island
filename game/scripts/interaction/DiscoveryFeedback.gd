class_name DiscoveryFeedback
extends CanvasLayer

var panel: PanelContainer
var title_label: Label
var message_label: Label
var tween: Tween


func _ready() -> void:
    layer = 50

    var event_bus := get_node_or_null("/root/InteractionEventBus")
    if event_bus:
        event_bus.register_feedback(self)

    _build_ui()
    hide_discovery()


func _build_ui() -> void:
    panel = PanelContainer.new()
    panel.name = "DiscoveryPanel"

    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.015, 0.02, 0.025, 0.94)
    style.border_width_left = 2
    style.border_width_top = 2
    style.border_width_right = 2
    style.border_width_bottom = 2
    style.border_color = Color(0.78, 0.68, 0.38, 0.9)
    style.corner_radius_top_left = 14
    style.corner_radius_top_right = 14
    style.corner_radius_bottom_left = 14
    style.corner_radius_bottom_right = 14
    style.content_margin_left = 28.0
    style.content_margin_right = 28.0
    style.content_margin_top = 20.0
    style.content_margin_bottom = 20.0

    panel.add_theme_stylebox_override("panel", style)
    panel.set_anchors_preset(Control.PRESET_CENTER)
    panel.position = Vector2(-330, -105)
    panel.size = Vector2(660, 210)
    panel.modulate.a = 0.0

    var container := VBoxContainer.new()
    container.alignment = BoxContainer.ALIGNMENT_CENTER
    container.add_theme_constant_override("separation", 12)

    title_label = Label.new()
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 30)
    title_label.text = "DISCOVERY FOUND"

    message_label = Label.new()
    message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    message_label.custom_minimum_size = Vector2(600, 90)
    message_label.add_theme_font_size_override("font_size", 19)

    container.add_child(title_label)
    container.add_child(message_label)
    panel.add_child(container)
    add_child(panel)


func show_discovery(title: String, message: String) -> void:
    if not is_instance_valid(panel):
        return

    if tween and tween.is_valid():
        tween.kill()

    title_label.text = title
    message_label.text = message

    panel.visible = true
    panel.modulate.a = 0.0

    tween = create_tween()
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(panel, "modulate:a", 1.0, 0.35)

    await get_tree().create_timer(3.5).timeout

    if not is_instance_valid(panel):
        return

    tween = create_tween()
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_IN)
    tween.tween_property(panel, "modulate:a", 0.0, 0.5)

    await tween.finished

    if is_instance_valid(panel):
        panel.visible = false


func hide_discovery() -> void:
    if panel:
        panel.visible = false
        panel.modulate.a = 0.0
