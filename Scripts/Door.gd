extends Area2D

var player: Player = null

func _ready():
	Events.connect("interact", self, "interact")
	Events.connect("end_game", self, "open")
	
func interact():
	if player and player.ondoor and player.current_state == player.States.Human:
		Events.emit_signal("end_game")

func _on_Door_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Player:
		body.ondoor = true
		player = body as Player

func _on_Door_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is Player:
		body.ondoor = false
		player = null

func open():
	$Sprite.play("Opening")
