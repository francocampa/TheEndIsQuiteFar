class_name ItemResource
extends Resource

enum Type{Building, Enemy, Boon};

@export var texture:Texture2D;
@export var name:String;
@export var type:Type = Type.Building;
@export var scene:PackedScene;


static var allItems:Array[ItemResource] = [
	load("res://resources/Hang.tres"),
	load("res://resources/Spikes.tres"),
	load("res://resources/Platform.tres"),
];
