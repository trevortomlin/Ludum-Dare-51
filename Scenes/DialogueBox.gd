extends CanvasLayer

export(String, FILE, "*.json") var dialogue_file

var dialogues = []
var dialogue_index = 0

onready var dialogue_name = $DialogueBox/Name
onready var message = $DialogueBox/Message
onready var portrait = $DialogueBox/TextureRect

var human_portrait = preload("res://Art/human_portrait.png")
var snail_portrait = preload("res://Art/snail_portrait.png")

var finished := false

func _ready():
	
	dialogues.append({"name":"Gale", "message":"How do we get out of this place?", "portrait":"Human"})
	dialogues.append({"name":"Snail Gale", "message":"Hm... You will run past the guards and I am small enough to sneak through the vents.", "portrait":"Snail"})
	dialogues.append({"name":"Gale", "message":"Got it. I will open the doors.", "portrait":"Human"})
	dialogues.append({"name":"Gale", "message":"But watch out... if you transform in the vent you will die.", "portrait":"Human"})
	
	play()
	
func play():
	#dialogues = load_dialogue()
	advance()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed == true:
			advance()

func advance():
	
	if finished: return
	
	if dialogue_index >= len(dialogues):
		hide()
		Events.emit_signal("end_dialogue")
		finished = true
		return
	
	dialogue_name.text = dialogues[dialogue_index]['name'] + ":"
	message.text = dialogues[dialogue_index]['message']
	
	var portrait_text = dialogues[dialogue_index]['portrait']
	if portrait_text == "Human":
		portrait.texture = human_portrait
	elif portrait_text == "Snail":
		portrait.texture = snail_portrait
	
	dialogue_index += 1

func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())
