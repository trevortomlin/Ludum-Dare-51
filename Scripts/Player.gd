extends KinematicBody2D

class_name Player

export (int) var human_speed = 200
export (int) var snail_speed = 50

var velocity = Vector2()

enum States {Human, Snail}
var current_state = States.Human

onready var sprite_node := $Sprite
onready var collision_shape := $CollisionShape2D

#var human_sprite = preload("res://Art/kenney_tinydungeon/Tiles/tile_0096.png")
#var snail_sprite = preload("res://Art/kenney_tinydungeon/Tiles/tile_0121.png")

var human_frames = preload("res://Resources/PlayerSpriteFrames.tres")
var snail_frames = preload("res://Resources/SnailSpriteFrames.tres")
	
#var human_sprite = preload("res://Art/human.png")
#var snail_sprite = preload("res://Art/snail_1.png")

var onvent := false
var can_move := true
var dead = false

var snail_walk = false

var accum_delta = 0.0

func _ready():
	Events.connect("ten_second_timeout", self, "switch_states")
	Events.connect("player_died", self, "die")
	Events.connect("enter_vent", self, "enter_vent")

func die():
	can_move = false
	dead = true
	#yield(get_tree().create_timer(5), "timeout")
	#get_tree().reload_current_scene()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		
	sprite_node.flip_h = velocity.x < 0
	
	velocity = velocity.normalized()
	
	if velocity == Vector2.ZERO:
		sprite_node.play("Idle")
		snail_walk = false
	else:
		if current_state != States.Snail:
			sprite_node.play("Walking")
			snail_walk = false
		else:
			snail_walk = true

func _physics_process(delta):

	accum_delta += delta
	
	if snail_walk:
		#print(sin(accum_delta))
		sprite_node.scale.x += sin(accum_delta * 10) * .003
	
	if dead: return
	
	if Input.is_action_pressed("interact") and onvent and can_move:
		Events.emit_signal("interact")
	
	match current_state:
		States.Human:
			human_state()
		States.Snail:
			snail_state()

func vent_tween(pos, time):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "global_transform:origin",
									 global_position, pos, time,
									 Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	exit_vent()

func enter_vent(pos, time):
	visible = false
	can_move = false
	collision_shape.disabled = true
	vent_tween(pos, time)

func exit_vent():
	visible = true
	can_move = true
	collision_shape.disabled = false

func move(speed):
	if not can_move: return
	get_input()
	velocity = move_and_slide(velocity * speed)

func switch_states():
	can_move = false
	yield(get_tree().create_timer(1), "timeout")
	can_move = true
	
	if current_state == States.Human:
		collision_shape.rotate(PI/2)
		#swap_collision_shape()
		current_state = States.Snail
		sprite_node.set_sprite_frames(snail_frames)
	else:
		#wap_collision_shape()
		collision_shape.rotate(-PI/2)
		current_state = States.Human
		sprite_node.set_sprite_frames(human_frames)

#func swap_collision_shape():
#	collision_shape.rotate(PI/2)
	

func human_state():
	#sprite_node.texture = human_sprite
	move(human_speed)

func snail_state():
	#sprite_node.texture = snail_sprite
	move(snail_speed)
