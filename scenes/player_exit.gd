extends TextureButton

var hover:bool = false;
var animProgress:float = 0;
func _process(delta: float) -> void:
	var mouse:Vector2 = get_global_mouse_position();
	if(mouse.x < position.x || mouse.x > position.x + size.x ||
		mouse.y < position.y || mouse.y > position.y + size.y):
		return
	if(Input.is_action_just_pressed("LeftClick")):
		get_tree().change_scene_to_packed(load("res://scenes/MainMenu.tscn"));
		
	animProgress += 40*delta;
		
	self.position.x += cos(animProgress)*1;
	self.position.y += sin(animProgress)*1;
