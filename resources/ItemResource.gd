class_name ItemResource
extends Resource

enum Type{Building, Enemy, Boon};

@export var texture:Texture2D;
@export var name:String;
@export var type:Type = Type.Building;
@export var scene:PackedScene;
@export var clipToWall:bool = true;
@export var clipToFloor:bool = false;


static var enemies:Array[ItemResource] = [
	load("res://resources/Spikes.tres"),
	load("res://resources/SkullBird.tres"),
	load("res://resources/Blob.tres"),
]

static var noEnemies:Array[ItemResource] = [
	load("res://resources/Hang.tres"),
	load("res://resources/Platform.tres"),
	load("res://resources/Hearth.tres"),
];

static var items:Array[ItemResource] = [
	
]
