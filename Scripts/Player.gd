extends KinematicBody2D

export (int) var human_speed = 200
export (int) var snail_speed = 50

var velocity = Vector2()

enum States {Human, Snail}
var current_state = States.Human

onready var sprite_node := $Sprite

var human_sprite = preload("res://Art/kenney_tinydungeon/Tiles/tile_0096.png")
var snail_sprite = preload("res://Art/kenney_tinydungeon/Tiles/tile_0121.png")

func _ready():
	Events.connect("ten_second_timeout", self, "switch_states")

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

func _physics_process(delta):
	
	match current_state:
		States.Human:
			human_state()
		States.Snail:
			snail_state()

func move(speed):
	get_input()
	velocity = move_and_slide(velocity * speed)

func switch_states():
	if current_state == States.Human:
		current_state = States.Snail
	else:
		current_state = States.Human

func human_state():
	sprite_node.texture = human_sprite
	move(human_speed)

func snail_state():
	sprite_node.texture = snail_sprite
	move(snail_speed)
