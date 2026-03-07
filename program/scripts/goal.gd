extends Area3D

func _on_body_entered(body):
	if body.name == "Player":
		var scene = get_tree().current_scene
		
		# Show win message
		scene.get_node("UI/Winmessage").visible = true
		
		# Stop timer
		scene.timer_running = false
		
		# Stop player movement
		body.set_process(false)
		body.set_physics_process(false)
func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
