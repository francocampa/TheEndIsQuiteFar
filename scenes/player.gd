extends CharacterBody2D

enum PlayerStates { Flooring,Jumping,Falling,Hanging,Paused }

var state:PlayerStates = PlayerStates.Flooring;
var jumps:int = 1;

@export var grav:float = 20;
@export var xAcc:float = 50;
@export var xFricFactor:float = 0.5;
@export var jumpHeight:float = -400;
@export var minVel:Vector2 = Vector2(-200,-4000);
@export var maxVel:Vector2 = Vector2(200,1000);
@export var lives:int = 3;

var vel:Vector2 = Vector2();
var lastDir:int = 1;
var crouching:bool = false;

func _ready() -> void:
	get_window().set_size(Vector2i(1280,680));
	update_hud();

func _physics_process(delta: float) -> void:
	if(state == PlayerStates.Paused):
		return;
		
	var isOnFloor = is_on_floor();
	
	handle_crouch();
	
	if(state == PlayerStates.Hanging):
		handle_hang();
	else:
		if(!isOnFloor):
			vel.y += grav;
		handle_horizontal_movement();
		handle_jump();
	
	if(state != PlayerStates.Jumping):
		if(isOnFloor):
			if(state == PlayerStates.Falling):
				jumps = 1;
			state = PlayerStates.Flooring;
			vel.y = 0;
			if(%JumpBuffer.time_left > 0):
				start_jump();
		else: if(state == PlayerStates.Flooring):
			start_falling()
	
	vel = vel.clamp(minVel,maxVel);
	velocity = vel;
	
	handle_sprite_squish();
	
	move_and_slide();

func start_jump():
	jumps-=1;
	vel.y = jumpHeight;
	state = PlayerStates.Jumping;

func start_falling():
	vel.y = 0;
	state = PlayerStates.Falling;
	%CoyoteTime.start();

func _on_coyote_time_timeout() -> void:
	if(state == PlayerStates.Falling):
		jumps = 0;

func handle_horizontal_movement() -> void:
	var x:float = 0;
	if(Input.is_action_pressed("Right")):
		x += 1;
	if(Input.is_action_pressed("Left")):
		x +=-1;
	if(x == 0):
		vel.x = 0 if abs(vel.x) < 50 else vel.x-vel.x*xFricFactor;
	else:
		vel.x += x*xAcc;

func handle_jump() -> void:
	if(Input.is_action_just_pressed("Jump")):
		if(jumps > 0):
			start_jump();
		else: if(state == PlayerStates.Falling):
			%JumpBuffer.start();

	if(state == PlayerStates.Jumping):
		if(!Input.is_action_pressed("Jump") || is_on_ceiling()):
			vel.y /= 2;
		if(vel.y > 0):
			state = PlayerStates.Falling;

func handle_hang():
	vel = Vector2();
	handle_jump();

func handle_crouch():
	if(Input.is_action_just_pressed("Crouch")):
		crouching = true;
		%CrouchAnim.start();
	
	if(Input.is_action_just_released("Crouch")):
		crouching = false;
		%CrouchAnim.start();

func try_to_hang(side:Area2D) -> void:
	if(vel.y < 0): #Going up
		return;
	if((vel.x > 0 && %Left == side) ||
	   (vel.x < 0 && %Right == side)):
		return;
	
	jumps = 1;
	state = PlayerStates.Hanging;
	lastDir = -1 if %Right == side else 1;

func _on_left_area_entered(area: Area2D) -> void:
	try_to_hang(%Left);

func _on_right_area_entered(area: Area2D) -> void:
	try_to_hang(%Right);

func handle_sprite_squish()->void:
	$Sprite.scale.x = lastDir;
	$Sprite.skew = deg_to_rad(20) *  vel.x / maxVel.x;
	
	if(vel.x != 0):
		lastDir = abs(vel.x)/vel.x;
	#$Sprite.scale.y = 0.7 * vel.y / maxVel.y
	
func rip():
	lives-=1;
	update_hud();

func update_hud():
	$Hud/LivesText.text = "Lives: " + str(lives);

func pause():
	state = PlayerStates.Paused;
	
func unpause():
	state = PlayerStates.Flooring;
