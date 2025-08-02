extends Node2D

@onready var level:Node2D = get_parent().get_parent().get_parent(); #i'm un poquititito loco 

@export var item:ItemResource;
@export var ammount:int = 1;

var hover:bool = false;
var disabled:bool = false;
var animProgress:float = 0;

func _ready() -> void:
	set_item(item);

func _process(delta: float) -> void:
	if(hover):
		if(Input.is_action_just_pressed("LeftClick")):
			level.select_item(self);
		animProgress += 40*delta;
		
		position.x += cos(animProgress)*1;
		position.y += sin(animProgress)*1;

	
func _on_mouse_entered() -> void:
	hover = true && !disabled;

func _on_mouse_exited() -> void:
	hover = false;
	
func disable()->void:
	disabled = true;
func enable()->void:
	disabled = false;

func set_item(item:ItemResource)->void:
	self.item = item;
	disabled = false;
	match item.type:
		ItemResource.Type.Building:
			$Card.self_modulate = Color("2e9ac2");
		ItemResource.Type.Enemy:
			$Card.self_modulate = Color("ff2c00");
		ItemResource.Type.Boon:
			$Card.self_modulate = Color("d1e300");
	
	$ItemTexture.texture = item.texture;
