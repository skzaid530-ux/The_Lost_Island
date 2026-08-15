class_name ObjectiveHUD
extends CanvasLayer

var panel: PanelContainer
var title_label: Label
var description_label: Label
var status_label: Label
var tween: Tween


func _ready() -> void:
    layer = 40
    _build_ui()

    var objective_manager := get_node_or_null("/root/ObjectiveManager")
    if objective_manager:
        objective_manager.objective_changed.connect(_on_objective_changed)
        objective_manager.objective_completed.connect(_on_objective_completed)

        if objective_manager.current_title != "":
            _show_objective(
                objective_manager.current_title,
                objective_manager.current_description
            )


func _build_ui() -> void:
    panel = PanelContainer.new()
    panel.name = "ObjectivePanel"

    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.012, 0.018, 0.024, 0.88)
    style.border_width_left = 2
    style.border_width_top = 2
    style.border_width_right = 2
    style.border_width_bottom = 2
    style.border_color = Color(0.78, 0.68, 0.38, 0.82)
    style.corner_radius_top_left = 12
    style.corner_radius_top_right = 12
    style.corner_radius_bottom_left = 12
    style.corner_radius_bottom_right = 12
    style.content_margin_left = 22.0
    style.content_margin_right = 22.0
    style.content_margin_top = 16.0
    style.content_margin_bottom = 16.0

    panel.add_theme_stylebox_override("panel", style)
    panel.position = Vector2(36, 32)
    panel.size = Vector2(470, 118)
    panel.modulate.a = 0.0

    var container := VBoxContainer.new()
    container.add_theme_constant_override("separation", 6)

    status_label = Label.new()
    status_label.text = "CURRENT OBJECTIVE"
    status_label.add_theme_font_size_override("font_size", 13)

    title_label = Label.new()
    title_label.add_theme_font_size_override("font_size", 22)

    description_label = Label.new()
    description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    description_label.add_theme_font_size_override("font_size", 15)

    container.add_child(status_label)
    container.add_child(title_label)
    container.add_child(description_label)

    panel.add_child(container)
    add_child(panel)


func _on_objective_changed(title: String, description: String) -> void:
    _show_objective(title, description)


func _show_objective(title: String, description: String) -> void:
    if not is_instance_valid(panel):
        return

    if tween and tween.is_valid():
        tween.kill()

    title_label.text = title
    description_label.text = description
    status_label.text = "CURRENT OBJECTIVE"

    panel.visible = true
    panel.modulate.a = 0.0

    tween = create_tween()
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(panel, "modulate:a", 1.0, 0.45)


func _on_objective_completed(objective_id: String) -> void:
    if not is_instance_valid(panel):
        return

    status_label.text = "OBJECTIVE COMPLETE"
    title_label.text = "✓ " + title_label.text
    description_label.text = "A new lead has emerged."

    if tween and tween.is_valid():
        tween.kill()

    tween = create_tween()
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(panel, "modulate:a", 1.0, 0.25)

    await get_tree().create_timer(2.0).timeout

    if not is_instance_valid(panel):
        return

    tween = create_tween()
    tween.set_trans(Tween.TRANS_QUAD)
    tween.set_ease(Tween.EASE_IN)
    tween.tween_property(panel, "modulate:a", 0.0, 0.45)
