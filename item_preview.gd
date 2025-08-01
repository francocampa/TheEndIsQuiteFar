extends Node2D

var texture:Texture2D;
var working:bool = false;

func _process(delta: float) -> void:
	
	get_global_mouse_position()

func set_texture(texture:Texture2D) ->void:
	$TextureRect.size = texture.get_size();
	$TextureRect.texture = texture;

func start():
	working = true;
