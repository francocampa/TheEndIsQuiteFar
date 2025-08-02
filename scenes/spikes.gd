extends Area2D

@onready var level:Node2D = get_parent().get_parent();

func _on_player_entered(body: Node2D) -> void:
	level.rip_bro();
