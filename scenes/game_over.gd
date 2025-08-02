extends Node2D

var hover:bool = false;
var animProgress:float = 0;

func _ready() -> void:
	$CanvasLayer/DayReached.text = Global.getDayText(Global.lastDay);

func _process(delta: float) -> void:
	if(hover):
		if(Input.is_action_just_pressed("LeftClick")):
			get_tree().change_scene_to_packed(load("res://scenes/MainMenu.tscn"));

		animProgress += 40*delta;
		$CanvasLayer/Continue.position.x += cos(animProgress)*1;
		$CanvasLayer/Continue.position.y += sin(animProgress)*1;

func _on_texture_button_mouse_entered() -> void:
	hover = true;


func _on_texture_button_mouse_exited() -> void:
	hover = false;
