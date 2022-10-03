extends Area2D

export(NodePath) onready var other_vent = get_node(other_vent) as Node
export(int) var vent_time := 3

onready var timer = $Timer
onready var e := $E

onready var e_start = e.position

var in_vent = false

var player: Player = null

var accum_delta := 0.0

func _process(delta):
	
	accum_delta += delta
	
	if e.visible and player and player.current_state == player.States.Snail:
		e.position = Vector2(0, e_start.y + sin(accum_delta) * 15)
		
	if player and player.onvent and player.current_state == player.States.Snail:
		e.visible = true
	else:
		e.visible = false

func _ready():
	e.visible = false
	Events.connect("ten_second_timeout", self, "timeout_vent_check")
	Events.connect("interact", self, "interact")
	
func interact():
	if player and player.current_state == player.States.Snail:
		AudioManager.in_vent()
		in_vent = true
		timer.start(vent_time)
		Events.emit_signal("enter_vent", other_vent.global_position, vent_time)

func _on_Timer_timeout():
	in_vent = false
	AudioManager.leave_vent()

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
