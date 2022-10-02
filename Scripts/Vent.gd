extends Area2D

export(NodePath) onready var other_vent = get_node(other_vent) as Node
export(int) var vent_time := 3

onready var timer = $Timer

var in_vent = false

var player: Player = null

func _ready():
	Events.connect("ten_second_timeout", self, "timeout_vent_check")
	Events.connect("interact", self, "interact")
	
func interact():
	if player:
		in_vent = true
		timer.start(vent_time)
		Events.emit_signal("enter_vent", other_vent.global_position, vent_time)

func _on_Timer_timeout():
	in_vent = false

func timeout_vent_check():
	if in_vent:
		Events.emit_signal("player_died")		
		
func _on_Vent_body_entered(body):
	if body is Player:
		body.onvent = true
		player = body as Player

func _on_Vent_body_exited(body):
	if body is Player:
		body.onvent = false
		player = null
