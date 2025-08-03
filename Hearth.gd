extends Node2D

@onready var level:Node2D = get_parent().get_parent();

var angle:float = 0;
var vel:float = 20;
var grabbed:bool = false;
func _process(delta: float) -> void:
	angle += 10*delta;
	position.y += vel*sin(angle)*delta;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(grabbed):
		return;
	grabbed = true;
	level.add_live();
	$Sprite2D.visible = false;
	$CPUParticles2D.emitting = true;

func _on_cpu_particles_2d_finished() -> void:
	queue_free();
