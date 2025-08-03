extends Node2D

var hover:bool = false;
var animProgress:float = 0;

func _ready() -> void:
	var money:int = Global.lastMoney;
	$CanvasLayer/Money.text = str(money);
	if(money >= 1000000):
		$CanvasLayer/FinalMessage.text = "Congrats on being a millionare, too bad you can't spend it";
	else: if(money >= 500000):
		$CanvasLayer/FinalMessage.text = "You got over the half way mark! Either way, everyone's dead";
	else:
		$CanvasLayer/FinalMessage.text = "You are as poor as were at the start, but now you're also dead";

func _process(delta: float) -> void:
	if(hover):
		if(Input.is_action_just_pressed("LeftClick")):
			get_tree().change_scene_to_packed(load("res://scenes/MainMenu.tscn"));

		animProgress += 40*delta;
		$CanvasLayer/Continue.position.x += cos(animProgress)*1;
		$CanvasLayer/Continue.position.y += sin(animProgress)*1;

func _on_continue_mouse_entered() -> void:
	hover = true;

func _on_continue_mouse_exited() -> void:
	hover = false;
