extends CanvasLayer

onready var progress_bar := $ProgressBar
onready var death_screen := $Death

var dead := false

func _ready():
	death_screen.hide()
	progress_bar.value = 10
	Events.connect("player_died", self, "death_screen")

func _process(delta):
	#print(dead)
	if dead:
		if Input.is_action_pressed("restart"):
			get_tree().reload_current_scene()
	
func death_screen():
	#yield(get_tree().create_timer(1), "timeout")
	dead = true
	death_screen.show()
