extends Node2D

@export var enemy_scene: PackedScene 

@export var spawn_points: Array[Vector2] = [
	Vector2(0, 500),
	Vector2(-500, 850),
	Vector2(350, 6600)
]

func spawn_enemies() -> void:
	if enemy_scene == null:
		return
	
	for point in spawn_points:
		var new_enemy = enemy_scene.instantiate()
		add_child(new_enemy)
		new_enemy.global_position = point


func _ready() -> void:
	spawn_enemies()
