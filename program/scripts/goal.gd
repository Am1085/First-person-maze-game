extends Area3D

var game_finished = false

func _ready():
	print("GOAL READY - monitoring for player")
	# Connect signal manually in case it's not connected in editor
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("SOMETHING ENTERED: ", body.name)
	if body.name == "Player" and not game_finished:
		game_finished = true
		print("PLAYER HIT GOAL")

		var scene = get_tree().current_scene
		scene.timer_running = false

		var footsteps = body.get_node_or_null("Footsteps")
		if footsteps:
			footsteps.stop()
			footsteps.volume_db = -80.0

		body.velocity = Vector3.ZERO
		body.game_over = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		var win_screen = scene.get_node_or_null("UI/WinScreen")
		print("WinScreen found: ", win_screen)
		if win_screen:
			win_screen.show_win(scene.time_elapsed)
		else:
			print("ERROR - WinScreen missing at UI/WinScreen")

		body.call_deferred("set_physics_process", false)
		body.call_deferred("set_process", false)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
