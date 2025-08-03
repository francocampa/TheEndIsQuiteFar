extends Node2D

var rng:RandomNumberGenerator = RandomNumberGenerator.new();
@onready var player:Node2D = $Player;

func _ready() -> void:
	$Elements/Blob.init(Vector2(300,201));
	$Elements/Blob.unpause();
	$Elements/SkullBird.init(Vector2(557,249));
	$Elements/SkullBird.unpause();

func _process(delta: float) -> void:
	handle_button(delta);

func _on_area_2d_body_entered(body: Node2D) -> void:
	rip_bro();
	
func rip_bro():
	$Player.position = Vector2(62,303);
	

var hover:bool = false;
var animProgress:float = 0;
func handle_button(delta:float):
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


func add_live():
	player.add_live();
