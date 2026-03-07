extends Area3D

func _on_body_entered(body):
	if body.name == "Player":
		var ui = get_tree().get_root().get_node("main/UI/WinMessage")
		ui.visible = true
