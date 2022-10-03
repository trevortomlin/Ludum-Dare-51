extends Node

onready var audioPlayers := $AudioStreamPlayers
onready var musicPlayer := $Music
onready var snail_player := $"Snail Sound"

var snail_walk_sound = preload("res://Sound/snail trail.wav")

func _ready():
	AudioManager.snail_player.stream = snail_walk_sound
	AudioManager.snail_player.bus = "SFX"

func play_music(sound):
	musicPlayer.stream = sound
	musicPlayer.bus = "Music"
	musicPlayer.play()

func play_sound(sound, bus):

	for audio_player in audioPlayers.get_children():
		if not audio_player.playing:
			audio_player.stream = sound
			audio_player.bus = bus
			
			audio_player.play()
			break

func in_vent():
	var effect: AudioEffectFilter = AudioServer.get_bus_effect(0, 0)
	AudioServer.set_bus_effect_enabled(0, 0, true)


func leave_vent():
	AudioServer.set_bus_effect_enabled(0, 0, false)
