extends Node2D

var hover:bool = false;
var animProgress:float = 0;

func _ready() -> void:
	get_window().set_size(Vector2i(1280,680));

func _process(delta: float) -> void:
	if(hover):
		if(Input.is_action_just_pressed("LeftClick")):
			get_tree().change_scene_to_packed(Global.gameScene);

		animProgress += 40*delta;
		$CanvasLayer/Continue.position.x += cos(animProgress)*1;
		$CanvasLayer/Continue.position.y += sin(animProgress)*1;

func _on_continue_mouse_entered() -> void:
	hover = true;


func _on_continue_mouse_exited() -> void:
	hover = false;
