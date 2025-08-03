extends Node2D

@onready var level:Node2D = get_parent().get_parent();

func _process(delta: float) -> void:
	if($Spring2.time_left == 0):
		scale.y = 1;
		return;
	
	#scale.y = 0.7 + 0.3 * $Spring2.time_left/$Spring2.wait_time;

func _on_area_2d_body_entered(body: Node2D) -> void:
	$Spring2.start();

func _on_spring_2_timeout() -> void:
	level.player.spring_jump();
