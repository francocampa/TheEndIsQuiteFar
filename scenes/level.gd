extends Node2D

@onready var player:CharacterBody2D = %Player;
@onready var startPortal:Area2D = %Start;
@onready var exitPortal:Area2D = %Exit;

var rng:RandomNumberGenerator;

func _ready() -> void:
	start_level();
	rng = RandomNumberGenerator.new();

func start_level() -> void:
	$ItemCards.visible = false;
	$ItemPreview.visible = false;
	
	player.position = startPortal.position;
	player.unpause();
	
	
func beat_level() -> void:
	player.pause();
	var itemCards:Array[Node] = $ItemCards.get_children(); 
	for iC in itemCards:
		iC.set_item(ItemResource.allItems[rng.randi()%3]);
	$ItemCards.visible = true;

func rip_bro() -> void:
	player.rip();
	start_level();

func select_item(itemCard) -> void:
	start_level();
	return;
	
	var itemCards:Array[Node] = $ItemCards.get_children(); 
	for iC in itemCards:
		iC.disable();
	
	var itemRes:ItemResource = itemCard.item;
	var itemInstance = itemRes.scene.instantiate();
	if(itemInstance.has_method("init")):
		itemInstance.init();
	itemCard.queue_free();
	
	
	
