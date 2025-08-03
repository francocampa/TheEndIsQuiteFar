extends Node2D

@onready var player:CharacterBody2D = %Player;
@onready var startPortal:Area2D = %Start;
@onready var exitPortal:Area2D = %Exit;

var rng:RandomNumberGenerator;

var continueHover = false;
var editing:bool = false;
var placed:int = 0;

var maxPlatformHeight:int = 0;

func _ready() -> void:
	rng = RandomNumberGenerator.new();
	var level:Node2D = Global.levels[rng.randi()%Global.levels.size()].instantiate();
	for p in level.get_child(0).get_children():
		$Platforms.add_child(p.duplicate());
	for e in level.get_child(1).get_children():
		$Elements.add_child(e.duplicate());

	start_level();
	for p in $Platforms.get_children():
		maxPlatformHeight = max(p.position.y, maxPlatformHeight);

func start_level() -> void:
	%ItemCards.visible = false;
	$ItemPreview.visible = false;
	$CanvasLayer2/Continue.visible = false;
	$CanvasLayer/GRID.visible = false;
	placed = 0;
	
	var elements:Array[Node] = $Elements.get_children(); 
	for e in elements:
		if(e.has_method("pause")):
			e.unpause();
		if(e.has_method("reset")):
			e.reset();
			
	player.position = startPortal.position;
	player.unpause();
	
	
func beat_level() -> void:
	player.pause();
	player.beat_level();
	if(player.day / 7 == 4):
		Global.ended_run(player.day, player.money);
		get_tree().change_scene_to_packed(Global.gameWonScene);
		
	editing = true;
	$CanvasLayer/GRID.visible = true;
	var itemCards:Array[Node] = %ItemCards.get_children(); 
	for iC in itemCards:
		iC.set_item(ItemResource.allItems[rng.randi()%ItemResource.allItems.size()]);
		iC.visible = true;
	%ItemCards.visible = true;
	
	var elements:Array[Node] = $Elements.get_children(); 
	for e in elements:
		if(e.has_method("pause")):
			e.pause();
		if(e.has_method("reset")):
			e.reset();
	

func rip_bro() -> void:
	player.rip();
	if(player.lives < 0):
		Global.ended_run(player.day, player.money);
		get_tree().change_scene_to_packed(Global.gameOverScene);
	start_level();

func select_item(itemCard) -> void:
	var itemCards:Array[Node] = %ItemCards.get_children(); 
	for iC in itemCards:
		iC.disable();
	var itemRes:ItemResource = itemCard.item;
	$ItemPreview.visible = true;
	$ItemPreview.set_item_resource(itemRes);
	$ItemPreview.start();
	itemCard.visible = false;
	
var platformSize:Vector2 = Vector2();

func place_element(itemRes:ItemResource,pos:Vector2,dir:int):
	var itemInstance:Node2D = itemRes.scene.instantiate();
	if(itemInstance.has_method("init")):
		itemInstance.init(pos);
	itemInstance.position = pos;
	
	if(itemRes.clipToWall):
		match dir:
			0:
				pass;
			2:
				itemInstance.apply_scale(Vector2(-1,1));
			1:
				itemInstance.rotate(PI/2);
			3:
				itemInstance.rotate(-PI/2);
	
	if(itemRes.type == ItemResource.Type.Enemy):
		player.add_income(itemRes.name);
	
	if(itemRes.name == "Platform"):
		$Platforms.add_child(itemInstance);
		itemInstance.set_platform_size(platformSize);
		maxPlatformHeight = max(pos.y, maxPlatformHeight);
	else:
		$Elements.add_child(itemInstance);
	
	placed += 1;
	
	if(placed >= 2):
		$CanvasLayer2/Continue.visible = true;
	
	var itemCards:Array[Node] = %ItemCards.get_children(); 
	for iC in itemCards:
		iC.enable();

func get_platforms() -> Array[Node]:
	return $Platforms.get_children();
	
func set_platform_size(size) ->void:
	self.platformSize = size;

var animProgress:float = 0;
func _process(delta: float) -> void:
	if(continueHover):
		if(Input.is_action_just_pressed("LeftClick")):
			start_level();
		animProgress += 40*delta;
		$CanvasLayer2/Continue.position.x += cos(animProgress)*1;
		$CanvasLayer2/Continue.position.y += sin(animProgress)*1;
		
func _on_continue_mouse_entered() -> void:
	continueHover = true;
func _on_continue_mouse_exited() -> void:
	continueHover = false;


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	rip_bro();
