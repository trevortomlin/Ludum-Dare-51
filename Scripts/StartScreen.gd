extends Control

onready var screens = [$"Title Screen", $Settings, $Credits]

var music = preload("res://Sound/Sketch_No.6.mp3")

func _ready():
	show_screen(0)
	AudioManager.play_music(music)
			
func show_screen(idx: int):
	for index in range(len(screens)):
		if index == idx:
			screens[index].show()
		else:
			screens[index].hide()

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")

func _on_Settings_pressed():
	show_screen(1)

func _on_Credits_pressed():
	show_screen(2)

func _on_Exit_pressed():
	get_tree().quit()

func _on_Back_pressed():
	show_screen(0)

func _on_Back2_pressed():
	show_screen(0)

func _on_Master_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))


func _on_Music_SLider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))


func _on_SFX_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
