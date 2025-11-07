extends CharacterBody2D

class_name FrogEnemy

const SPEED:int = 20
var is_frog_chase:bool = true
var hopping:bool = false
var can_hop:bool = true
const HOP_DELAY:float = 0.3
const HOP_LENGTH:float = 1.4
const ATTACK_REGISTER_LENGTH:float = 0.14

var health:int = 80
var health_max:int = 80
var health_min:int = 0

var dead:bool = false
var taking_damage:bool = false
var attack_damage:int = 20
var attacking:bool = false
var can_attack:bool = true
const ATTACK_DELAY:float = 0.2

var dir: Vector2
const gravity = 900
var knockback_force = 100


var player:CharacterBody2D
var player_touching:bool = false
var player_in_area:bool = false

func _ready() -> void:
	player = global_script.playerBody
	$CanHopTimer.wait_time = HOP_DELAY
	$AttackDelay.wait_time = ATTACK_DELAY
	$HopTimer.wait_time = HOP_LENGTH
	$AttackRegisterTimer.wait_time = ATTACK_REGISTER_LENGTH

func _physics_process(delta: float) -> void:
	global_script.frogDamageAmount = attack_damage
	
	if global_script.playerAlive:
		is_frog_chase = true
	else:
		is_frog_chase = false
	
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	
	check_can_attack_hitbox()
	move(delta)
	handle_animation()
	move_and_slide()

func check_can_attack_hitbox():
	var hitbox_areas = $FrogCanAttackHitbox.get_overlapping_areas()
	if hitbox_areas:
		for hitbox in hitbox_areas:
			if hitbox == global_script.playerHitbox and can_attack and global_script.playerAlive:
				attacking = true
				can_attack = false
				$AttackRegisterTimer.start()
				
func move(delta):
	var frog_hitbox = $FrogAttackHitbox
	var frog_can_attack_hitbox = $FrogCanAttackHitbox
	if dir.x == 1:
		if frog_hitbox.scale.x < 0:
			frog_hitbox.scale.x *= -1
		if frog_can_attack_hitbox.scale.x < 0:
			frog_can_attack_hitbox.scale.x *= -1
	else:
		if frog_hitbox.scale.x > 0:
			frog_hitbox.scale.x *= -1
		if frog_can_attack_hitbox.scale.x > 0:
			frog_can_attack_hitbox.scale.x *= -1
	if dead:
		velocity.x = 0
	elif taking_damage:
		var knockback_dir = position.direction_to(player.position).x * knockback_force * -1
		velocity.x = knockback_dir
	elif hopping:
		if !is_frog_chase:
			velocity += dir * SPEED * delta
		if is_frog_chase and global_script.playerAlive:
			velocity.x = position.direction_to(player.position).x * SPEED
			if velocity.x < 0:
				dir.x = -1
			else:
				dir.x = 1
	elif !hopping and !attacking and !taking_damage:
		velocity.x = 0
	

const DEATH_ANIMATION_LENGTH:float =1.12
const HURT_ANIMATION_LENGTH:float = 0.8
const ATTACK_ANIMATION_LENGTH:float = 0.7

func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if dir.x == -1:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	if dead:
		animated_sprite.play("death")	
		await get_tree().create_timer(DEATH_ANIMATION_LENGTH).timeout
		handle_death()
	elif taking_damage:
		animated_sprite.play("hurt")
		await get_tree().create_timer(HURT_ANIMATION_LENGTH).timeout
		taking_damage = false
	elif attacking:
		animated_sprite.play("attack")
		await get_tree().create_timer(ATTACK_ANIMATION_LENGTH).timeout
		attacking = false
		$FrogAttackHitbox/CollisionShape2D.disabled = true
		$AttackDelay.start()
	elif can_hop:
		can_hop = false
		hopping = true
		animated_sprite.play("hop")
		$HopTimer.start()
	elif !animated_sprite.is_playing():
		animated_sprite.play("idle")

func handle_death():
	self.queue_free()
		


func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.0,1.5,2.0])
	if !is_frog_chase:
		dir = choose([Vector2.LEFT,Vector2.RIGHT])
	
func choose(array):
	array.shuffle()
	return array.front()

func _on_hop_timer_timeout() -> void:
	hopping = false
	$CanHopTimer.start()

func _on_can_hop_timer_timeout() -> void:
	can_hop = true

func _on_frog_hitbox_area_entered(area: Area2D) -> void:
	var damage = global_script.playerDamageAmount
	if area == global_script.playerAttackZone:
		taking_damage = true
		take_damage(damage)
		
func take_damage(damage:int):
	health -= damage
	taking_damage = true
	if health <= health_min:
		health = health_min
		dead = true
	
func _on_frog_attack_hitbox_area_entered(area: Area2D) -> void:
	pass

func _on_frog_can_attack_hitbox_area_entered(area: Area2D) -> void:
	if area == global_script.playerHitbox and can_attack:
		attacking = true
		can_attack = false
		$AttackRegisterTimer.start()
	
func _on_attack_register_timer_timeout() -> void:
	$FrogAttackHitbox/CollisionShape2D.disabled = false

func _on_attack_delay_timeout() -> void:
	can_attack = true
