extends CharacterBody2D

const SPEED = 30
var dir: Vector2
var is_bat_chase: bool
var player: CharacterBody2D

func _ready():
	is_bat_chase = true
	
func _physics_process(delta: float) -> void:
	move(delta)
	handle_animation()
	
func move(delta):
	if !is_bat_chase:
		velocity += dir * SPEED * delta
	elif is_bat_chase:
		player = global_script.playerBody
		velocity = position.direction_to(player.position) * SPEED
		if velocity.x < 0:
			dir.x = -1
		else:
			dir.x = 1
	move_and_slide()

func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play("fly")
	if dir.x == -1:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5,1.0])
	if is_bat_chase:
		pass
	else:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2.LEFT])
	
func choose(array):
	array.shuffle()
	return array.front()
