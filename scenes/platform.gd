extends StaticBody2D

class_name  Platform

@export var platform_size := Vector2(40, 40)

var resizeble:bool = false;

func _ready():
	set_platform_size(platform_size);

func set_platform_size(size:Vector2) -> void:
	var shape:RectangleShape2D = $HitBox.shape;
	shape.set_size(size);
	$Texture.size = size;
	var topLeft:Vector2 = -size*0.5;  
	$Texture.position = topLeft;
	$"Left corner/CollisionShape2D".position = Vector2(topLeft.x+2,topLeft.y + 3); #Magic 3 pixels :DD
	$"Right corner/CollisionShape2D".position = Vector2(-topLeft.x-2,topLeft.y + 3) 
