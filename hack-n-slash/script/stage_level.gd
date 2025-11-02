extends Node2D

@onready var player_camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_script.playerWeaponEquip = true
	player_camera.enabled = true
	player_camera.limit_enabled = true
	player_camera.limit_left = -17
	player_camera.limit_right = 885
	player_camera.limit_bottom = 27
	player_camera.limit_top = -10000000
	pass # Replace with function body.


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
	
