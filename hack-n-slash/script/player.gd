extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -350.0

var weapon_equip: bool

func _ready() -> void:
	weapon_equip = false

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

	move_and_slide()

func handle_movement_animation(dir):
	if !weapon_equip:
		if !velocity:
			animated_sprite.play("idle")
		elif velocity.y:
			animated_sprite.play("fall")
			toggle_flip_sprite(dir)
		else:
			animated_sprite.play("run")
			toggle_flip_sprite(dir)
	else:
		if !velocity:
			animated_sprite.play("weapon_idle")
		elif velocity.y:
			animated_sprite.play("weapon_fall")
			toggle_flip_sprite(dir)
		else:
			animated_sprite.play("weapon_run")
			toggle_flip_sprite(dir)

func toggle_flip_sprite(dir):
	if dir == 1:
		animated_sprite.flip_h = false
	if dir == -1:
		animated_sprite.flip_h = true
	
