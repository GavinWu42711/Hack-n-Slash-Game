extends CharacterBody2D

const SPEED = 30
var dir: Vector2
var is_bat_chase: bool
var is_roaming:bool 
var player: CharacterBody2D
var health:int = 50
var health_max:int = 50
var health_min:int = 0	
var dead:bool = false
var taking_damage:bool = false

func _ready():
	is_bat_chase = true
	
func _physics_process(delta: float) -> void:
	move(delta)
	handle_animation()
	
func move(delta):
	player = global_script.playerBody
	if dead:
		velocity.y += 10 * delta 
		velocity.x = 0
	elif taking_damage:
		var knockback_dir = position.direction_to(player.position) * -50
		velocity = knockback_dir
	else:
		if !is_bat_chase:
			velocity += dir * SPEED * delta
		elif is_bat_chase:
			velocity = position.direction_to(player.position) * SPEED
			if velocity.x < 0:
				dir.x = -1
			else:
				dir.x = 1
	move_and_slide()

func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if dead:
		animated_sprite.play("death")
	elif taking_damage:
		animated_sprite.play("hurt")
		await get_tree().create_timer(1.0).timeout
		taking_damage = false
	else: 
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


func _on_bat_hitbox_area_entered(area: Area2D) -> void:
	if area == global_script.playerAttackZone:
		var damage = global_script.playerDamageAmount
		take_damage(damage)
	
func take_damage(damage):
	taking_damage = true
	health -= damage
	if health <= health_min:
		health = health_min
		dead = true
	print(str(self), "current health is", str(health))
