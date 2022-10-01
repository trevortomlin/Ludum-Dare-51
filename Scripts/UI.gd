extends CanvasLayer

onready var progress_bar := $ProgressBar
onready var timer := $"Every 10 Seconds"

func _ready():
	progress_bar.value = 10
	
func _process(delta):
	progress_bar.value = timer.time_left


func _on_Every_10_Seconds_timeout():
	Events.emit_signal("ten_second_timeout")
