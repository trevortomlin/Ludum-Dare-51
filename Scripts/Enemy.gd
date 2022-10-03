extends KinematicBody2D

class_name Enemy

enum States {Idle, Patrol, Alert, Chase}

export(bool) var patrol = true
export (NodePath) var patrol_path

var current_state = States.Idle

var move_speed = 100
var run_speed = 150

var patrol_points
var patrol_index = 0
var velocity = Vector2.ZERO
var target = null
var start_pos := Vector2.ZERO

onready var sprite := $Sprite

func _ready():
	randomize()
	if patrol_path and patrol:
		current_state = States.Patrol
		patrol_points = get_node(patrol_path).curve.get_baked_points()
	else:
		start_pos = global_position
	
func _process(delta):
	
	sprite.flip_h = velocity.x > 0
	
	if target: current_state = States.Chase
	
	match current_state:
		States.Idle:
			idle()
		States.Patrol:
			patrol()
		States.Alert:
			alert()
		States.Chase:
			chase()

func idle():
	sprite.play("Idle")
	if global_position != start_pos:
		sprite.play("Walking")
		#print(global_position, start_pos)
		velocity = (start_pos - global_position).normalized() * move_speed
		velocity = move_and_slide(velocity)

func patrol():
	sprite.play("Walking")
	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	velocity = (target - position).normalized() * move_speed
	velocity = move_and_slide(velocity)

func alert():
	sprite.play("Idle")
	yield(get_tree().create_timer(randi() % 2 + 5), "timeout")
	if patrol:
		current_state = States.Patrol
	else:
		current_state = States.Idle

func chase():
	sprite.play("Walking")
	velocity = position.direction_to(target.position) * run_speed
	velocity = move_and_slide(velocity)

func _on_View_body_entered(body):
	if body is Player:
		target = body as Player
		current_state = States.Chase

func _on_View_body_exited(body):
	if body is Player:
		target = null
		current_state = States.Alert

func _on_Death_body_entered(body):
	if body is Player:
		Events.emit_signal("player_died")
