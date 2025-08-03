extends Area2D

enum Type{ Start, End  };

@export var type:Type = Type.Start;
@onready var level:Node2D = get_parent();

var finishing:bool = false;

func _ready():
	if(type == Type.Start):
		$Sprite.modulate = Color("#f9f900");
	else: if(type == Type.End):
		$Sprite.modulate = Color("#ff6bd6");


func _on_player_entered(body: Node2D) -> void:
	if(type == Type.Start):
		return;
	
	level.beat_level();
