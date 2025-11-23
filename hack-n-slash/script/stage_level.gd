extends Node2D

var currentWave:int
@export var batScene:PackedScene
@export var frogScene:PackedScene

var startingNodes:int
var currentNodes:int
var waveSpawnEnded:bool

@onready var SceneTransitionAnimation = $SceneTransitionAnimation/AnimationPlayer
@onready var player_camera = $Player/Camera2D
@onready var BatSpawnTopLeft = $BatSpawnTopLeft
@onready var BatSpawnBottomRight = $BatSpawnBottomRight
@onready var FrogSpawnTopLeft = $BatSpawnTopLeft
@onready var FrogSpawnBottomRight = $FrogSpawnBottomRight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	SceneTransitionAnimation.play("fade_out")
	global_script.playerWeaponEquip = true
	player_camera.enabled = true
	player_camera.limit_enabled = true
	player_camera.limit_left = -17
	player_camera.limit_right = 885
	player_camera.limit_bottom = 27
	player_camera.limit_top = -10000000
	
	
	
	currentWave = 0
	global_script.currentWave = currentWave
	startingNodes = get_child_count()
	currentNodes = get_child_count()	
	
	position_to_next_wave()
	
func position_to_next_wave() -> void:
	if currentNodes == startingNodes:
		if currentWave != 0:
			global_script.movingToNextWave = true
			SceneTransitionAnimation.play("betweenWave")
			await get_tree().create_timer(1).timeout
		currentWave += 1
		prepare_spawn("bat",3,3)
		prepare_spawn("frog",3,3)
		global_script.currentWave = currentWave	
		

func prepare_spawn(type:String,multiplier:float, spawnRoundAmount:int) -> void:
	var mobAmount:int = int(currentWave * multiplier)
	var spawnTime: float = 2.0
	var initialWaitTime:float = 2.5
	var mobSpawnPerRound:int = int(ceil(mobAmount / spawnRoundAmount))
	print("mobAmount:" + str(mobAmount))
	print("mobSpawnPerRound:" + str(mobSpawnPerRound))
	print("spawnRoundAmount:" + str(spawnRoundAmount))
	await get_tree().create_timer(2.5).timeout
	spawn_enemy(type,spawnRoundAmount,mobSpawnPerRound,spawnTime)

func spawn_enemy(type:String,spawnRoundAmount:int,mobSpawnPerRound:int,spawnTime:float):
	for a in range(spawnRoundAmount):
		if type == "bat":
			for b in range(mobSpawnPerRound):
				var positionX:int = randi_range(BatSpawnTopLeft.global_position.x, BatSpawnBottomRight.global_position.x)
				var positionY:int = randi_range(BatSpawnBottomRight.global_position.y, BatSpawnTopLeft.global_position.y)
				var bat = batScene.instantiate()
				bat.global_position.x = positionX
				bat.global_position.y = positionY
				add_child(bat)
		elif type == "frog":
			for b in range(mobSpawnPerRound):
				var positionX:int = randi_range(FrogSpawnTopLeft.global_position.x, FrogSpawnBottomRight.global_position.x)
				var positionY:int = randi_range(FrogSpawnBottomRight.global_position.y, FrogSpawnTopLeft.global_position.y)
				var frog = frogScene.instantiate()
				frog.global_position.x = positionX
				frog.global_position.y = positionY
				add_child(frog)
		await get_tree().create_timer(spawnTime).timeout
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_script.playerAlive == false:
		go_to_lobby()

func go_to_lobby():
	global_script.combatStarted = false
	global_script.playerWeaponEquip = false
	
	get_tree().change_scene_to_file("res://scene/lobby_level.tscn")

func restart_combat():
	
	get_tree().change_scene_to_file("res://scene/stage.tscn")
	
