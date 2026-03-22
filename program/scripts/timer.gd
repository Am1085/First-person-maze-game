extends Node3D

var time_elapsed = 0.0
var timer_running = true
var minimap_hint_shown = false
var minimap_visible = false

@onready var timer_label = $UI/TimerLabel
@onready var minimap = $UI/Minimap
@onready var minimap_hint = $UI/MinimapHint

func _ready():
	minimap.visible = false
	minimap_hint.visible = false
	minimap_hint.text = "Press H for minimap"

	# Size and position
	minimap_hint.size = Vector2(400, 50)
	minimap_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	# Style
	var ls = LabelSettings.new()
	ls.font_size = 18
	ls.font_color = Color("#c9a96e")
	minimap_hint.label_settings = ls

	# Position it — we do this after one frame so viewport size is ready
	await get_tree().process_frame
	var vp = get_viewport().get_visible_rect().size
	minimap_hint.position = Vector2((vp.x / 2) - 200, vp.y - 80)

func _process(delta):
	if timer_running:
		time_elapsed += delta
		timer_label.text = "Time: " + str(int(time_elapsed))

		if time_elapsed >= 10.0 and not minimap_hint_shown:
			minimap_hint_shown = true
			show_hint()

func show_hint():
	minimap_hint.text = "Press  H  to reveal the minimap"
	minimap_hint.visible = true
	minimap_hint.modulate.a = 0.0

	var t = create_tween()
	t.tween_property(minimap_hint, "modulate:a", 1.0, 0.8)
	t.tween_interval(4.0)
	t.tween_property(minimap_hint, "modulate:a", 0.0, 1.0)
	t.tween_callback(func(): minimap_hint.visible = false)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_H and time_elapsed >= 10.0:
			minimap_visible = !minimap_visible
			minimap.visible = minimap_visible
