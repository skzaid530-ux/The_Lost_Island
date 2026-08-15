class_name InteractionPrompt
extends CanvasLayer

var panel: PanelContainer
var label: Label


func _ready() -> void:
    layer = 20

    panel = PanelContainer.new()
    panel.name = "PromptPanel"

    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.02, 0.03, 0.04, 0.88)
    style.corner_radius_top_left = 12
    style.corner_radius_top_right = 12
    style.corner_radius_bottom_left = 12
    style.corner_radius_bottom_right = 12
    style.content_margin_left = 18.0
    style.content_margin_right = 18.0
    style.content_margin_top = 10.0
    style.content_margin_bottom = 10.0

    panel.add_theme_stylebox_override("panel", style)
    panel.position = Vector2(0, 0)
    panel.size = Vector2(320, 64)

    label = Label.new()
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 18)
    label.text = "E  Interact"

    panel.add_child(label)
    add_child(panel)

    hide_prompt()


func show_prompt(text: String) -> void:
    if not label:
        return

    label.text = "E  " + text
    panel.visible = true


func hide_prompt() -> void:
    if panel:
        panel.visible = false
