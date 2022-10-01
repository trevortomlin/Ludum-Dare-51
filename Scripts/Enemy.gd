extends KinematicBody2D

enum States {Idle, Patrol, Alert}

var current_state = States.Idle

func _ready():
	pass

func _process(delta):
	match current_state:
		States.Idle:
			idle()
		States.Patrol:
			patrol()
		States.Alert:
			alert()

func idle():
	pass

func patrol():
	pass

func alert():
	pass
