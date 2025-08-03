extends AudioStreamPlayer

func _ready() -> void:
	MusicManager.set_volume(1.0);
	MusicManager.start_music();

func set_volume(vol:float):
	volume_linear = vol;
	
func start_music():
	stream = load("res://sounds/Night of the Streets.mp3")
	play()
