extends RigidBody2D

@export var speed: float = 100.0
@export var direction: Vector2i = Vector2i.LEFT


func _ready() -> void:
	linear_damp = 0
	linear_damp_mode = DAMP_MODE_REPLACE

	$Animations.play("default")
	$Animations.flip_h = true

	linear_velocity = Vector2.RIGHT * speed


func _on_body_entered(body: Node) -> void:
	if (body is TileMapLayer):
		flip_direction()


func flip_direction() -> void:
	if (direction == Vector2i.LEFT):
		$Animations.flip_h = true
		direction = Vector2i.RIGHT
		linear_velocity = Vector2.RIGHT * speed
	else:
		$Animations.flip_h = false
		direction = Vector2i.LEFT
		linear_velocity = Vector2.LEFT * speed
