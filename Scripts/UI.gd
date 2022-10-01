extends CanvasLayer

onready var progress_bar := $ProgressBar
onready var timer := $"Every 10 Seconds"

func _ready():
	progress_bar.value = 10
