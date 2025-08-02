extends CharacterBody2D

enum PlayerStates { Flooring,Jumping,Falling,Hanging,Paused }

var state:PlayerStates = PlayerStates.Flooring;
var jumps:int = 1;
var timeLeft:float = 30; 

@onready var level:Node2D = get_parent();

@export var grav:float = 20;
@export var xAcc:float = 50;
@export var xFricFactor:float = 0.5;
@export var jumpHeight:float = -400;
@export var minVel:Vector2 = Vector2(-1000,-1000);
@export var maxVel:Vector2 = Vector2(1000,1000);
@export var walkSpeed:float = 200;
@export var lives:int = 3;

var vel:Vector2 = Vector2();
var lastDir:int = 1;
var crouching:bool = false;
var hangFall:bool = false;
var platform:Node2D = null;
var day:int = 0;
var money:int = 0;
var daylyIncome:int = 1000;

func _ready() -> void:
	update_hud();

func _physics_process(delta: float) -> void:
	if(state == PlayerStates.Paused):
		return;
	
	update_hud();
	
	var isOnFloor = is_on_floor();
	
	handle_crouch();
	
	if(state == PlayerStates.Hanging):
		handle_hang();
	else:
		if(!isOnFloor):
			vel.y += grav;
			if(crouching):
				vel.y += grav;
		handle_horizontal_movement();
		handle_jump();
	
	if(state != PlayerStates.Jumping):
		if(isOnFloor):
			if(state == PlayerStates.Falling):
				jumps = 1;
			state = PlayerStates.Flooring;
			vel.y = 0;
			var collission:KinematicCollision2D = get_slide_collision(0);
			if(collission != null):
				platform = collission.get_collider();
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
	if(state == PlayerStates.Hanging):
		if(Input.is_action_pressed("Left") && lastDir == -1):
			vel.x = jumpHeight;
			vel.y = jumpHeight/1.5;
		else: if(Input.is_action_pressed("Right") && lastDir == 1):
			vel.x = -jumpHeight;
			vel.y = jumpHeight/1.5;
		else:
			vel.y = jumpHeight;
	else:
		vel.y = jumpHeight;
	state = PlayerStates.Jumping;

func start_falling():
	vel.y = 0;
	state = PlayerStates.Falling;
	if(crouching):
		var oldSpeed:float = vel.x;
		vel.x = 0;
		hangFall = true;
		if(platform != null):
			if(oldSpeed > 0):
				vel.x = position.x - platform.position.x - platform.platform_size.x;
			else: 
				vel.x =  platform.position.x - position.x ;
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
		vel.x += 0 if (abs(vel.x) > walkSpeed && x * vel.x > 0) || hangFall else x*xAcc;

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
		if(state == PlayerStates.Hanging):
			%HangBuffer.start();
			state = PlayerStates.Falling;
		%CrouchAnim.start();
	
	if(Input.is_action_just_released("Crouch")):
		crouching = false;
		hangFall = false;
		%CrouchAnim.start();

func try_to_hang(side:Area2D) -> void:
	if(%HangBuffer.time_left > 0):
		return;
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
	$Animations.scale.x = lastDir;
	#$Animations.skew = deg_to_rad(20) *  vel.x / maxVel.x;
	
	if(vel.x != 0):
		lastDir = abs(vel.x)/vel.x;
	#$Sprite.scale.y = 0.7 * vel.y / maxVel.y
	
	if(crouching && is_on_floor()):
		scale.y = 0.6 + 0.4 * (%CrouchAnim.time_left/%CrouchAnim.wait_time);
	else:
		scale.y = 1;
		
	$Animations.scale.y = 1;
	match state:
		PlayerStates.Flooring:
			if(vel.x == 0):
				$Animations.play("idle")
			else:
				$Animations.play("walking")
		PlayerStates.Jumping:
			$Animations.play("jump")
		PlayerStates.Falling:
				$Animations.play("jump")
	
func rip():
	lives-=1;
	update_hud();

func update_hud():
	$Hud/LivesText.text = "x " + str(lives);
	$Hud/Timer.text = str(%Life.time_left).substr(0,5);
	
	$Hud/Day.text = Global.getDayText(day);
	
func pause():
	state = PlayerStates.Paused;
	%Life.paused = true;
	
func unpause():
	state = PlayerStates.Flooring;
	%Life.paused = false;
	%Life.start(timeLeft);

func beat_level():
	day += 1;

func _on_life_timeout() -> void:
	level.rip_bro();
	timeLeft = 30;
	
func add_income(obstacleName:String):
	match obstacleName:
		"Spikes":
			daylyIncome+=1000;
		"SkullBird":
			daylyIncome+=2000;
		"Blob":
			daylyIncome+=2000;
	
