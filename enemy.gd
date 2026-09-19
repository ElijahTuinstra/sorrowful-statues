extends CharacterBody2D

const SPEED = 250.0

@onready var animated_sprite = $StatueSprites

var player: CharacterBody2D = null

func _ready() -> void:
	player = get_parent().get_node_or_null("Player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		
		if direction.x > 0:
			velocity.x = SPEED
			$StatueSprites.flip_h = false
		elif direction.x < 0:
			velocity.x = -SPEED
			$StatueSprites.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
