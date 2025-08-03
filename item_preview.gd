extends Node2D

var itemRes:ItemResource;
var working:bool = false;
var nextTickWorking:bool = false;
@onready var level:Node2D = get_parent();
var dir:int = -1;
var platformSize:Vector2 = Vector2();

func _process(delta: float) -> void:
	if(!working):
		if(nextTickWorking):
			working = true;
			nextTickWorking = false;
		return;
	
	handle_error_message(delta);
	
	var mousePos:Vector2 = get_global_mouse_position();
	self.position = mousePos;
	if(itemRes.clipToWall):
		handle_clip_to_wall();
	if(itemRes.clipToFloor):
		handle_clip_to_floor();
		
	var offset:Vector2 = $Preview.size*-0.5;
	self.position += offset;
	
	var invalidReason:String = validate_placement();
	if(invalidReason != ""):
		$Preview.modulate = Color("ff0a3c");
		$CanvasLayer/ErrorMessage.text = invalidReason;
		return;
	
	$Preview.modulate = Color("ffffff");
	$CanvasLayer/ErrorMessage.text = "";
	if(Input.is_action_just_pressed("LeftClick")):
		working = false;
		if(itemRes.name == "Platform"):
			level.set_platform_size(platformSize);
		level.place_element(itemRes,position - offset,dir);
		$Preview.scale.x = 1;
		$Preview.rotation = 0;
		dir = 0;
		self.position = Vector2(-20,20);
		self.visible = false;

func set_item_resource(itemRes:ItemResource) ->void:
	if(itemRes.name == "Platform"):
		platformSize = 16 * Vector2(max(1,level.rng.randi()%5),max(1,level.rng.randi()%5));
		$Preview.size = platformSize;
		$Preview.stretch_mode = 0;
	else:
		$Preview.stretch_mode = 2;
		$Preview.size = itemRes.texture.get_size();
	$Preview.texture = itemRes.texture;
	self.itemRes = itemRes;

func start():
	nextTickWorking = true;

func handle_clip_to_wall():
	var platforms:Array[Node] = level.get_platforms();
	var closestPlatform:Node = null;
	var dir:int = 0; # 0,1,2,3 left,up,right,down this is shit
	var distance:float = 50;
	for p in platforms:
		var p_size:Vector2 = p.platform_size;
		var p_pos:Vector2 = p.position - p_size/2;
		
		if(p_pos.y < position.y && p_pos.y + p_size.y > position.y):
			var newDis:float = Vector2(p_pos.x,position.y).distance_to(position);
			if(newDis < distance):
				distance = newDis;
				closestPlatform = p;
				dir = 2
			newDis = Vector2(p_pos.x+p_size.x,position.y).distance_to(position);
			if(newDis < distance):
				distance = newDis;
				dir = 0
				closestPlatform = p;
				
		if(p_pos.x < position.x && p_pos.x + p_size.x > position.x):
			var newDis:float = Vector2(position.x,p_pos.y).distance_to(position);
			if(newDis < distance):
				distance = newDis;
				closestPlatform = p;
				dir = 3
			newDis = Vector2(position.x,p_pos.y + p_size.y).distance_to(position);
			if(newDis < distance):
				distance = newDis;
				dir = 1
				closestPlatform = p;
		
		p.modulate = Color("ffffff");
	$Preview.scale.x = 1;
	$Preview.rotation = 0;
	if(closestPlatform != null):
		var p_size:Vector2 = closestPlatform.platform_size;
		var p_pos:Vector2 = closestPlatform.position - p_size/2;
		var t_size:Vector2 = $Preview.get_size();
		var offset:Vector2 = $Preview.size*0.5;
		match dir:
			0:
				position = Vector2(p_pos.x+p_size.x+t_size.x - offset.x,position.y);
			2: 
				position = Vector2(p_pos.x - offset.x,position.y);
				$Preview.scale.x = -1;
			1:
				position = Vector2(position.x,p_pos.y+p_size.y+t_size.y - offset.y);
				$Preview.rotation = PI/2;
			3: 
				position = Vector2(position.x,p_pos.y - offset.y);
				$Preview.rotation = -PI/2;
	
		self.dir = dir;
	else:
		self.dir = -1;
		#closestPlatform.modulate =  Color("ff0000");

func handle_clip_to_floor():
	var platforms:Array[Node] = level.get_platforms();
	var closestPlatform:Node = null;
	var dir:int = 0; # 0,1,2,3 left,up,right,down this is shit
	var distance:float = 50;
	for p in platforms:
		var p_size:Vector2 = p.platform_size;
		var p_pos:Vector2 = p.position - p_size/2;
		
		if(p_pos.x < position.x && p_pos.x + p_size.x > position.x):
			var newDis:float = Vector2(position.x,p_pos.y).distance_to(position);
			if(newDis < distance):
				distance = newDis;
				closestPlatform = p;
				dir = 3
		
	$Preview.scale.x = 1;
	$Preview.rotation = 0;
	if(closestPlatform != null):
		var p_size:Vector2 = closestPlatform.platform_size;
		var p_pos:Vector2 = closestPlatform.position - p_size/2;
		var t_size:Vector2 = $Preview.get_size();
		var offset:Vector2 = $Preview.size*0.5;
		position = Vector2(position.x,p_pos.y - offset.y);
		self.dir = dir;
	else:
		self.dir = -1;

func validate_placement() -> String:
	var t_size:Vector2 = $Preview.get_size();
	var pos:Vector2 = position; #the offset was used before wtf is this shit
	var thisRect:Rect2 = Rect2(pos,t_size);
	if(position.x < 0 || position.x > 640):
		return "Out of range";
	if(position.y < 0 || position.y > 340):
		return "Out of range";
	if(itemRes.clipToFloor):
		if(dir < 0):
			return "Must be in the floor"

	if(itemRes.clipToWall):
		if(dir < 0):
			return "Must be in a wall"
	
	var elements:Array[Node] = level.get_elements();
	for el in elements:
		var e_size:Vector2 = Vector2(16,16); #Don't have time
		var e_pos:Vector2 = el.position - e_size/2;
		var eRect:Rect2 = Rect2(e_pos,e_size);
		if(thisRect.intersects(eRect)):
			return "Can't overlap elements!"
	
	match itemRes.name:
		"Platform":
			if(position.x < 20 || position.x + $Preview.size.x > 640):
				return "Out of range";
			
			var platforms:Array[Node] = level.get_platforms();
			for p in platforms:
				var p_size:Vector2 = p.platform_size;
				var p_pos:Vector2 = p.position - p_size/2;
				var pRect:Rect2 = Rect2(p_pos,p_size);
				if(thisRect.intersects(pRect)):
					return "Can't overlap platforms!"
		"SkullBird":
			var birdsInLine:int = 0;
			for el in elements:
				if(el.has_method("imabird")): #peak coding
					if abs(el.position.y - (pos.y + t_size.y/2)) < 8:
						birdsInLine+=1;
			if(birdsInLine >= 2):
				return "Too many birds in that height"
		"SkullBird":
			var blobsInLine:int = 0;
			for el in elements:
				if(el.has_method("imablob")): #peak coding
					if abs(el.position.y - (pos.y + t_size.y/2)) < 8:
						blobsInLine+=1;
			if(blobsInLine >= 5):
				return "Too many blobs in that platform"

	return "";
	
var angle:float = 0;
func handle_error_message(delta:float) -> void:
	angle+=5*delta;
	var sin:float = sin(angle);
	$CanvasLayer/ErrorMessage.visible = sin > 0;
		
