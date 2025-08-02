extends Node2D

var vel:float = 100;
var angle:float = 0;
var angleSpeed:float = 10;
var dir:int = -1;

var initialPos:Vector2 = Vector2();
var paused:bool = true;
@onready var level:Node2D = get_parent().get_parent();

func init(initialPos:Vector2) -> void:
	self.initialPos = initialPos;

func reset():
	position = initialPos;

func pause():
	paused = true;
	
func unpause():
	paused = false;

func _process(delta: float) -> void:
	if(paused):
		return;
	angle+=angleSpeed*delta;
	
	if(position.x < 0 || position.x > 640):
		dir*=-1;
	
	position.x += dir*vel*delta;
	position.y += sin(angle);
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	level.rip_bro();
