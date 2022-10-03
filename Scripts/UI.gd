extends CanvasLayer

onready var progress_bar := $ProgressBar
onready var death_screen := $Death
onready var end_game := $"End Game"

var dead := false

func _ready():
	death_screen.hide()
	end_game.hide()
	progress_bar.value = 10
	Events.connect("player_died", self, "death_screen")
	Events.connect("end_game", self, "end_game")

func _process(delta):
	#print(dead)
	if dead:
		if Input.is_action_pressed("restart"):
			get_tree().reload_current_scene()
	
func death_screen():
	#yield(get_tree().create_timer(1), "timeout")
	progress_bar.hide()
	dead = true
	death_screen.show()

func end_game():
	dead = true
	end_game.show()
