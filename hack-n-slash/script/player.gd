extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_zone = $AttackZone

const SPEED = 300.0
const JUMP_VELOCITY = -350.0

var attack_type: String
var current_attack: bool	
var weapon_equip: bool

func _ready() -> void:
	global_script.playerBody = self

func _physics_process(delta: float) -> void:
	global_script.playerAttackZone = attack_zone
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	handle_movement_animation(direction)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if weapon_equip and !current_attack:
		var normal_attack = Input.is_action_just_pressed("normal_attack")
		var double_attack = Input.is_action_just_pressed("double_attack")
		if normal_attack or double_attack:
			current_attack = true
			if is_on_floor():
				if normal_attack:
					attack_type = "single"
				else:
					attack_type = "double"
			else:
				attack_type = "air"
			set_attack_damage(attack_type)
			handle_attack_animation(attack_type)
	move_and_slide()

func set_attack_damage(attack:String):
	var damage:int
	if attack == "single":
		damage = 8
	elif attack == "double":
		damage = 16
	elif attack == "air":
		damage =20
	global_script.playerDamageAmount = damage

func handle_attack_animation(attack:String):
	if weapon_equip:
		if attack == "single":
			animated_sprite.play("single_attack")
		elif attack == "double":
			animated_sprite.play("double_attack")
		elif attack == "air":
			animated_sprite.play("air_attack")
		toggle_damage_collision(attack)
	
		
func toggle_damage_collision(attack):
	var damage_zone_collision = attack_zone.get_node("CollisionShape2D")
	var wait_time : float
	if attack == "single":
		wait_time = 0.33
	elif attack == "double":
		wait_time = 0.9
	elif attack == "air":
		wait_time = 0.4	
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true

func handle_movement_animation(dir):
	toggle_flip_sprite(dir)
	if !current_attack:
		weapon_equip = global_script.playerWeaponEquip
		if !weapon_equip:
			if !velocity:
				animated_sprite.play("idle")
			elif velocity.y:
				animated_sprite.play("fall")
			else:
				animated_sprite.play("run")
		else:
			if !velocity:
				animated_sprite.play("weapon_idle")
			elif velocity.y:
				animated_sprite.play("weapon_fall")
			else:
				animated_sprite.play("weapon_run")

func toggle_flip_sprite(dir):
	if dir == 1:
		animated_sprite.flip_h = false
		attack_zone.scale.x = 1
	if dir == -1:
		animated_sprite.flip_h = true
		attack_zone.scale.x = -1
		
		
	
func _on_animated_sprite_2d_animation_finished() -> void:
	current_attack = false
