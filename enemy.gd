extends CharacterBody2D

const SPEED = 250.0
@onready var animated_sprite = $StatueSprites
var direction: float = 1.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if is_on_wall() or not test_move(global_transform.translated(Vector2(direction * 12, 0)), Vector2(0, 10)): #forgive this ungodly long line of code, I could not figure out raytracing so we do what we have to do
			direction *= -1

	velocity.x = direction * SPEED
	animated_sprite.flip_h = (direction < 0)
	move_and_slide()
