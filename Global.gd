class_name Global

static var menuScene:PackedScene = load("res://scenes/MainMenu.tscn")
static var gameScene:PackedScene = load("res://scenes/level.tscn")
static var gameOverScene:PackedScene = load("res://scenes/GameOver.tscn")
static var gameWonScene:PackedScene = load("res://scenes/WinScreen.tscn")
static var tutorialScene:PackedScene = load("res://scenes/Tutorial.tscn")

static var lastDay:int = 0;
static var dayRecords:Array[int] = [];
static var lastMoney:int = 0;
static var moneyRecords:Array[int] = [];

static func getDayText(day:int) -> String:
	var week:int = day/7;
	var weekDay:int = day - 7*week
	var dayText:String = "";
	match weekDay:
		0:
			dayText = "Mon";
		1:
			dayText = "Tue";
		2:
			dayText = "Wed";
		3:
			dayText = "Thu";
		4:
			dayText = "Fri";
		5:
			dayText = "Sat";
		6:
			dayText = "Sun";
	
	return "Week " + str(week+1) + ", "+dayText;

static func ended_run(day:int,money:int):
	lastDay = day;
	lastMoney = money;
	for i in dayRecords.size()+1:
		if(i == dayRecords.size()):
			dayRecords.append(day);
		if(day > dayRecords[i]):
			dayRecords.insert(i,day);
			
	for i in moneyRecords.size()+1:
		if(i == moneyRecords.size()):
			moneyRecords.append(money);
		if(money > moneyRecords[i]):
			moneyRecords.insert(i,money);
	
	
static var levels:Array[PackedScene] = [
	load("res://resources/platformLayout/1.tscn"),
	load("res://resources/platformLayout/2.tscn"),
	load("res://resources/platformLayout/3.tscn"),
];

static var volume:float = 100;
static var musicPlayer:AudioStreamPlayer = AudioStreamPlayer.new();
static func startMusic():
	musicPlayer.stream = load("res://sounds/Night of the Streets.mp3");
	musicPlayer.volume_linear = 1.0;
	musicPlayer.play();
