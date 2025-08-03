extends Node2D

var hover:bool = false;
var animProgress:float = 0;
var btnHoverIndex = 0;

@onready var musicPlayer = $AudioStreamPlayer

func _ready() -> void:
	get_window().set_size(Vector2i(1280,680));

func _process(delta: float) -> void:
	if(hover):
		if(Input.is_action_just_pressed("LeftClick")):
			match btnHoverIndex:
				0:
					get_tree().change_scene_to_packed(Global.gameScene);
				1:
					get_tree().change_scene_to_packed(load("res://resources/platformLayout/Tutorial.tscn"));
				2:
					get_tree().change_scene_to_packed(Global.gameScene);
		animProgress += 40*delta;
		var btn:TextureButton =  $BtnLayer.get_child(btnHoverIndex);
		
		if(btn == null):
			return;
			
		btn.position.x += cos(animProgress)*1;
		btn.position.y += sin(animProgress)*1;

func _on_continue_mouse_entered() -> void:
	hover = true;
	btnHoverIndex = 0;
func _on_continue_mouse_exited() -> void:
	hover = false;

func _on_settings_mouse_entered() -> void:
	hover = true;
	btnHoverIndex = 2;

func _on_settings_mouse_exited() -> void:
	hover = false;

func _on_help_mouse_entered() -> void:
	hover = true;
	btnHoverIndex = 1;

func _on_help_mouse_exited() -> void:
	hover = false;
