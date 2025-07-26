extends CharacterBody2D

# Player wiring
@export var map: WorldMap


# Player events
signal distance_changed(distance: int)
signal player_died


# Player configuration
const walk_acceleration: int = 100
const walk_deceleration: int = 50
const run_acceleration: int = 200
const run_deceleration: int = 100
const max_speed: int = 350
const max_walk_speed: int = 200
const jump_speed: int = -1000
const gravity: int = 2500

# Player state
var is_alive: bool = true


func handle_movement(delta: float) -> void:
    var right: bool = Input.is_action_pressed('move_right')
    var left: bool = Input.is_action_pressed('move_left')
    var run: bool = Input.is_action_pressed('run')
    var jump: bool = Input.is_action_just_pressed('jump')

    #velocity.x -= 1

    if is_on_floor():
        if jump: # Normal jump
            velocity.y = jump_speed

        if left:
            velocity.x -= walk_acceleration
            if abs(velocity.x) >= max_speed: velocity.x = -max_speed

        if right:
            velocity.x += walk_acceleration
            if abs(velocity.x) >= max_speed: velocity.x = max_speed

        if not left and not right: # Decelerate
            if (velocity.x > 0):
                velocity.x -= walk_deceleration
                if velocity.x < 0: velocity.x = 0
            elif (velocity.x < 0):
                velocity.x += walk_deceleration
                if velocity.x > 0: velocity.x = 0


    else: # Is in the air
        pass

    # Wall jump
    if is_on_wall_only() and jump:
        velocity.y = jump_speed
        velocity.x = - get_wall_normal().x * (jump_speed * 2)


#    if right:
#        velocity.x += max_speed
#    if left:
#        velocity.x -= max_speed

func _process(delta: float) -> void:
    var distance: int = map.tile_map.local_to_map(position).x
    distance_changed.emit(distance - 15)


func _physics_process(delta) -> void:
    if not is_alive:
        return

    velocity.y += gravity * delta
    handle_movement(delta)
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
