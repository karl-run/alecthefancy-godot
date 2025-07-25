extends KillableMob

@export var run_speed: int = 70

var left: bool = true


func _ready() -> void:
	$Animations.play("default")
	$Animations.flip_h = true


func _physics_process(delta: float) -> void:
	velocity.x = 0

	if get_wall_normal() == Vector2.RIGHT:
		left = true
		$Animations.flip_h = true
	elif get_wall_normal() == Vector2.LEFT:
		left = false
		$Animations.flip_h = false

	if left:
		velocity.x += run_speed
	else:
		velocity.x -= run_speed

	move_and_slide()


func kill() -> void:
	super.kill()
	$Animations.flip_h = !$Animations.flip_h
