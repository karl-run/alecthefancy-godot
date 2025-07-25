extends CharacterBody2D

signal player_died
@export var run_speed: int = 350
@export var jump_speed: int = -1000
@export var gravity: int = 2500

var is_alive: bool = true


func get_input():
    velocity.x = 0

    var right: bool = Input.is_action_pressed('move_right')
    var left: bool  = Input.is_action_pressed('move_left')
    var jump: bool  = Input.is_action_just_pressed('jump')

    if is_on_floor() and jump:
        velocity.y = jump_speed
    if right:
        velocity.x += run_speed
    if left:
        velocity.x -= run_speed


func _physics_process(delta) -> void:
    if not is_alive:
        return

    velocity.y += gravity * delta
    get_input()
    move_and_slide()
    do_animations()


func die():
    is_alive = false

    $Animations.play("death")

    player_died.emit()


func do_animations() -> void:
    if is_on_floor():
        if velocity.x == 0:
            $Animations.play("idle")
        else:
            $Animations.play("run")
            # Flip based on direction
            $Animations.flip_h = velocity.x < 0
    else:
        if velocity.y < 0:
            $Animations.play("jump")


func _on_body_area_body_entered(body: Node2D) -> void:
    if body is KillableMob and not body.alive:
        return

    die()


func _on_jump_area_entered(area: Area2D) -> void:
    if area.name == "KillArea":
        area.get_parent().kill()
        velocity.y = jump_speed
