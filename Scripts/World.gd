extends Node2D

onready var progress_bar = get_node("UI/ProgressBar")
onready var timer = $"Every 10 Seconds"

var music = preload("res://Sound/Sketch_No.6.mp3")

func _ready():
	VisualServer.set_default_clear_color("1b1c2c")
	Events.connect("end_dialogue", self, "unpause")
	Events.connect("end_game", self, "pause_delay")
	#Events.connect("player_died", self, "pause_delay")
	AudioManager.play_music(music)
	pause()

func _process(delta):
	progress_bar.value = timer.time_left

func _on_Every_10_Seconds_timeout():
	Events.emit_signal("ten_second_timeout")

func unpause():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func pause_delay():
	yield(get_tree().create_timer(1), "timeout")
	get_tree().paused = true
