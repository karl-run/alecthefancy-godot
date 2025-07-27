extends KillableMob
class_name WalkingMob

@export var run_speed: int = 99
@export var gravity: int = 2500

var left: bool = true


func _ready() -> void:
    $Animations.play("default")
    $Animations.flip_h = false


func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    velocity.x = 0

    if get_wall_normal() == Vector2.RIGHT:
        left = true
        $Animations.flip_h = false
    elif get_wall_normal() == Vector2.LEFT:
        left = false
        $Animations.flip_h = true

    if left:
        velocity.x += run_speed
    else:
        velocity.x -= run_speed

    move_and_slide()
