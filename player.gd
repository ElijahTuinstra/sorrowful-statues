extends CharacterBody2D


const SPEED = 900.0
const JUMP_VELOCITY = -900.0
const DOWN_SPEED = -900.0
var normal_gravity : bool = true

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if normal_gravity:
		if not is_on_floor():
			if Input.is_action_pressed("down"):
				velocity.y = DOWN_SPEED * -1
			else:
				velocity.y += get_gravity().y * delta
	else:
		if not is_on_ceiling():
			if Input.is_action_pressed("down"):
				velocity.y = DOWN_SPEED
			else:
				velocity.y += get_gravity().y * delta * -1

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if normal_gravity:
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
		else:
			if is_on_ceiling():
				velocity.y = -JUMP_VELOCITY

	# Handle gravity switch.
	if Input.is_action_just_pressed("flip-gravity"):
		if normal_gravity:
			normal_gravity = false
		else:
			normal_gravity = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
