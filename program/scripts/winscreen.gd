extends Control

var win_sound: AudioStreamPlayer
var bg: ColorRect
var escaped_label: Label
var title_label: Label
var subtitle_label: Label
var divider: ColorRect
var time_label: Label
var hint_box: PanelContainer  # stored directly now
var hint_bright = true

func _ready():
	visible = false
	modulate.a = 1.0
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	build_ui()

func build_ui():
	bg = ColorRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.024, 0.016, 0.008, 1.0)
	add_child(bg)

	var outer = CenterContainer.new()
	outer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(outer)

	win_sound = AudioStreamPlayer.new()
	win_sound.stream = load("res://music/win_sound.mp3")
	win_sound.volume_db = -6.0
	add_child(win_sound)

	var vbox = VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(600, 0)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	outer.add_child(vbox)

	var panel = PanelContainer.new()
	panel.add_theme_stylebox_override("panel", make_panel_style())
	vbox.add_child(panel)

	var inner = VBoxContainer.new()
	inner.alignment = BoxContainer.ALIGNMENT_CENTER
	inner.add_theme_constant_override("separation", 0)
	panel.add_child(inner)

	add_space(inner, 32)
	inner.add_child(make_rule())
	add_space(inner, 28)

	escaped_label = make_label("you made it out alive", 13, Color("#7a5530"))
	inner.add_child(escaped_label)
	add_space(inner, 22)

	title_label = make_label("Still Breathing", 58, Color("#e8c97a"))
	inner.add_child(title_label)
	add_space(inner, 22)

	subtitle_label = make_label(
		"The walls watched you.\nThe dark followed close.\nBut you are free.",
		16, Color("#a07850")
	)
	inner.add_child(subtitle_label)
	add_space(inner, 28)

	var dc = CenterContainer.new()
	dc.custom_minimum_size = Vector2(0, 6)
	divider = ColorRect.new()
	divider.custom_minimum_size = Vector2(140, 1)
	divider.color = Color("#6b3d1e")
	divider.modulate.a = 0.0
	dc.add_child(divider)
	inner.add_child(dc)
	add_space(inner, 24)

	time_label = make_label("survived in   0:00", 22, Color("#c8a060"))
	inner.add_child(time_label)
	add_space(inner, 32)

	# Build hint box and store reference directly
	hint_box = build_hint_box()
	hint_box.modulate.a = 0.0
	inner.add_child(hint_box)
	add_space(inner, 30)

	inner.add_child(make_rule())
	add_space(inner, 32)

func build_hint_box() -> PanelContainer:
	var box = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.04, 0.01, 0.9)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = Color("#a05a1e")
	style.set_corner_radius_all(0)
	style.content_margin_left = 32
	style.content_margin_right = 32
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	box.add_theme_stylebox_override("panel", style)

	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 8)
	box.add_child(hbox)

	var press = Label.new()
	press.text = "press"
	var ls1 = LabelSettings.new()
	ls1.font_size = 15
	ls1.font_color = Color("#b08040")
	press.label_settings = ls1
	hbox.add_child(press)

	# ENTER key styled box
	var key_box = PanelContainer.new()
	var key_style = StyleBoxFlat.new()
	key_style.bg_color = Color(0.16, 0.08, 0.01, 1.0)
	key_style.border_width_left = 1
	key_style.border_width_right = 1
	key_style.border_width_top = 1
	key_style.border_width_bottom = 2
	key_style.border_color = Color("#e8982a")
	key_style.set_corner_radius_all(3)
	key_style.content_margin_left = 14
	key_style.content_margin_right = 14
	key_style.content_margin_top = 4
	key_style.content_margin_bottom = 4
	key_box.add_theme_stylebox_override("panel", key_style)

	var key_label = Label.new()
	key_label.text = "ENTER"
	var ls2 = LabelSettings.new()
	ls2.font_size = 14
	ls2.font_color = Color("#ffcc66")
	key_label.label_settings = ls2
	key_box.add_child(key_label)
	hbox.add_child(key_box)

	var after = Label.new()
	after.text = "to dare return"
	var ls3 = LabelSettings.new()
	ls3.font_size = 15
	ls3.font_color = Color("#b08040")
	after.label_settings = ls3
	hbox.add_child(after)

	return box

func make_rule() -> CenterContainer:
	var div_wrap = CenterContainer.new()
	div_wrap.custom_minimum_size = Vector2(0, 4)
	var r = ColorRect.new()
	r.custom_minimum_size = Vector2(400, 1)
	r.color = Color("#4a2a0e")
	div_wrap.add_child(r)
	return div_wrap

func make_panel_style() -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = Color(0.024, 0.016, 0.008, 0.88)
	s.border_width_left = 1
	s.border_width_right = 1
	s.border_width_top = 1
	s.border_width_bottom = 1
	s.border_color = Color("#3a2010")
	s.set_corner_radius_all(0)
	s.content_margin_left = 70
	s.content_margin_right = 70
	s.content_margin_top = 10
	s.content_margin_bottom = 10
	return s

func add_space(parent: Control, height: int):
	var s = Control.new()
	s.custom_minimum_size = Vector2(0, height)
	parent.add_child(s)

func make_label(txt: String, size: int, color: Color) -> Label:
	var l = Label.new()
	l.text = txt
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var ls = LabelSettings.new()
	ls.font_size = size
	ls.font_color = color
	l.label_settings = ls
	l.modulate.a = 0.0
	return l

func show_win(time_seconds: float):
	var minutes = int(time_seconds) / 60
	var seconds = int(time_seconds) % 60
	time_label.text = "survived in   %d:%02d" % [minutes, seconds]

	visible = true
	modulate.a = 1.0
	
	win_sound.play()

	_delayed_fade(escaped_label,  0.3)
	_delayed_fade(title_label,    0.7)
	_delayed_fade(subtitle_label, 1.2)
	_delayed_fade(divider,        1.6)
	_delayed_fade(time_label,     1.9)
	_delayed_fade(hint_box,       2.4)  # direct reference — no searching

	var pt = Timer.new()
	pt.one_shot = true
	pt.wait_time = 3.5
	add_child(pt)
	pt.timeout.connect(_begin_pulse)
	pt.start()

func _delayed_fade(node: Control, delay: float):
	var t = Timer.new()
	t.one_shot = true
	t.wait_time = max(delay, 0.05)
	add_child(t)
	t.timeout.connect(func():
		node.modulate.a = 1.0
		t.queue_free()
	)
	t.start()

func _begin_pulse():
	var rt = Timer.new()
	rt.one_shot = false
	rt.wait_time = 1.1
	add_child(rt)
	rt.timeout.connect(_toggle_hint)
	rt.start()

func _toggle_hint():
	hint_bright = !hint_bright
	hint_box.modulate.a = 1.0 if hint_bright else 0.4
