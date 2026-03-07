extends Node3D

var time_elapsed = 0.0
var timer_running = true

@onready var timer_label = $UI/TimerLabel

func _process(delta):
	if timer_running:
		time_elapsed += delta
		timer_label.text = "Time: " + str(int(time_elapsed))

