extends CharacterBody2D
class_name KillableMob

var alive: bool = true


func kill() -> void:
    alive = false

    $Animations.play("death")
    $Animations.animation_finished.connect(func (): queue_free() )
