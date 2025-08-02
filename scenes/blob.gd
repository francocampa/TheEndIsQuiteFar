extends RigidBody2D

var dir:int = -1;
var xSpeed:float = 100;
var initialPos:Vector2 = Vector2();
var paused:bool = true;
@onready var level:Node2D = get_parent().get_parent();

func init(initialPos:Vector2) -> void:
	self.initialPos = initialPos;
	
func reset():
	position = initialPos;

func pause():
	linear_velocity.x = 0;
	paused = true;
	
func unpause():
	paused = false;
	
func _process(delta: float) -> void:
	angular_velocity = 0;
	if(paused):
		return;
	
	linear_velocity.x = dir*xSpeed;

func _on_area_2d_area_entered(area: Area2D) -> void:
	dir*=-1;

func _on_body_entered(body: Node) -> void:
	level.rip_bro();
