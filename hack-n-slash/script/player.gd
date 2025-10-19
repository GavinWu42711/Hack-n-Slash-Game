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
			handle_attack_animation(attack_type)
	move_and_slide()

func handle_attack_animation(attack_type:String):
	if weapon_equip:
		if attack_type == "single":
			animated_sprite.play("single_attack")
		elif attack_type == "double":
			animated_sprite.play("double_attack")
		elif attack_type == "air":
			animated_sprite.play("air_attack")
	else:
		pass
		


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
	if dir == -1:
		animated_sprite.flip_h = true
		
	
func _on_animated_sprite_2d_animation_finished() -> void:
	current_attack = false
