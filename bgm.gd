extends Node

const SR := 44100.0

var _player: AudioStreamPlayer

func _ready() -> void:
	var stream: AudioStreamMP3 = load("res://sound/Retro Soccer Synthwave Loop.mp3")
	stream.loop = true
	_player = AudioStreamPlayer.new()
	_player.stream    = stream
	_player.volume_db = -6.0
	add_child(_player)
	_player.play()

func stop() -> void:
	_player.stop()
