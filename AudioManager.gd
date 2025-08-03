extends Node

enum Audios { Blob,Bird,Death,FloorHit };

var audios:Array[AudioStream] = [
	load("res://sounds/bird.mp3"),
	load("res://sounds/blob.mp3"),
	load("res://sounds/death.mp3"),
	load("res://sounds/FloorHit.mp3"),
];
var players:Array[AudioStreamPlayer] = [];

func _ready() -> void:
	for a in audios:
		var player:AudioStreamPlayer = AudioStreamPlayer.new();
		player.stream = a;
		player.volume_linear = 1.0;
		players.append(player);
		
func play_audio(audio:Audios):
	match audio:
		Audios.Bird:
			players[0].play();
		Audios.Blob:
			players[1].play();
		Audios.Death:
			players[2].play();
		Audios.FloorHit:
			players[3].play();
	
