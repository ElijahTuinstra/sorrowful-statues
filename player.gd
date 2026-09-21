extends CharacterBody2D

const SPEED = 900.0
const JUMP_VELOCITY = -900.0
const DOWN_SPEED = -900.0

var normal_gravity : bool = true
var scaled_gravity : float = 1.0
var level_scaled_gravity_default : float = 1
var double_jumped : bool = false
var wall_jump_timer : float = 0.0

@onready var animated_sprite = $PlayerSprites
@onready var StillLight = $StillLight2D

func _physics_process(delta: float) -> void:
	StillLight.energy = 2.0
	
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	
	if not is_on_floor() and not is_on_ceiling() and Input.is_action_pressed("jump"):
		scaled_gravity = 0.5
	elif not is_on_floor() and not is_on_ceiling() and Input.is_action_pressed("down"):
		scaled_gravity = 5
	else:
		scaled_gravity = level_scaled_gravity_default
		
	# Add the gravity.
	if normal_gravity:
		if not is_on_floor():
				velocity.y += get_gravity().y * delta * scaled_gravity
	else:
		if not is_on_ceiling():
				velocity.y += get_gravity().y * delta * scaled_gravity * -1

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if normal_gravity:
			if is_on_floor():
				double_jumped = false
				velocity.y = JUMP_VELOCITY
			elif is_on_wall():
				var wall_normal_x = get_wall_normal().x
				velocity.y = JUMP_VELOCITY
				velocity.x = wall_normal_x * SPEED * 0.5
				wall_jump_timer = 0.2
			elif not double_jumped:
				velocity.y = JUMP_VELOCITY
				double_jumped = true
		else:
			if is_on_ceiling():
				double_jumped = false
				velocity.y = -JUMP_VELOCITY
			elif is_on_wall():
				var wall_normal_x = get_wall_normal().x
				velocity.y = -JUMP_VELOCITY
				velocity.x = wall_normal_x * abs(JUMP_VELOCITY)
			elif not double_jumped:
				velocity.y = -JUMP_VELOCITY
				double_jumped = true

	# Handle gravity switch.
	if Input.is_action_just_pressed("flip-gravity"):
		if normal_gravity:
			normal_gravity = false
		else:
			normal_gravity = true

	# Get the input direction and handle the movement/deceleration.
	if wall_jump_timer <= 0:
		var direction := Input.get_axis("move-left", "move-right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if normal_gravity:
		animated_sprite.flip_v = false
		if is_on_floor():
			if velocity.x == 0:
				animated_sprite.play("idle")
			elif velocity.x > 0:
				animated_sprite.play("moving-right")
			elif velocity.x < 0:
				animated_sprite.play("moving-left")
		else:
			if velocity.y < 0:
				animated_sprite.play("jump")
			else:
				animated_sprite.play("fall")
	else:
		animated_sprite.flip_v = true
		if is_on_ceiling():
			if abs(velocity.x) < 10:
				animated_sprite.play("idle")
			elif velocity.x > 0:
				animated_sprite.play("moving-right")
			elif velocity.x < 0:
				animated_sprite.play("moving-left")
		else:
			if velocity.y > 0:
				animated_sprite.play("jump")
			else:
				animated_sprite.play("fall")
