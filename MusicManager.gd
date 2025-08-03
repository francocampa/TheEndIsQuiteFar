extends AudioStreamPlayer

func _ready() -> void:
	finished.connect(on_music_finished)
	MusicManager.set_volume(0.4);
	MusicManager.start_music();

func set_volume(vol:float):
	volume_linear = vol;
	
func start_music():
	stream = load("res://sounds/Night of the Streets.mp3")
	play()

func on_music_finished():
	start_music();
