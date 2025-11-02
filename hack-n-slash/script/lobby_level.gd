extends Node2D

@onready var player_camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_camera.enabled = true
	player_camera.limit_enabled = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_detection_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://scene/stage.tscn")
		global_script.combatStarted = true
