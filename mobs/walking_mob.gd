extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: int = 100

var left: bool = false


func _ready() -> void:
	$Animations.play("default")
	$Animations.flip_h = true


func _physics_process(delta: float) -> void:
	var motion := Vector2(0, 0)
	if (!is_on_floor()):
		motion.y += gravity * delta
	motion.x += (1.0 if left else -1.0) * speed * delta
	move_and_collide(motion)
	move_and_slide()


func _on_body_entered(body: Node) -> void:
	if (body is TileMapLayer):
		print("Colliding with bodies: ", body)
		flip_direction()


func flip_direction() -> void:
	if (left):
		$Animations.flip_h = true
		left = false
	else:
		$Animations.flip_h = false
		left = true
