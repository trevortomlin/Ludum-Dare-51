extends Node2D

onready var progress_bar = get_node("UI/ProgressBar")
onready var timer = $"Every 10 Seconds"

func _ready():
	VisualServer.set_default_clear_color("1b1c2c")
	Events.connect("end_dialogue", self, "unpause")
	get_tree().paused = true

func _process(delta):
	progress_bar.value = timer.time_left

func _on_Every_10_Seconds_timeout():
	Events.emit_signal("ten_second_timeout")

func unpause():
	get_tree().paused = false
