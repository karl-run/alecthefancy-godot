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
const gravity: int = 50

# Player state
var is_alive: bool = true


func _process(_delta: float) -> void:
    if not is_alive:
        return

    var distance: int = map.tile_map.local_to_map(position).x
    distance_changed.emit(distance - 15)


func _physics_process(_delta: float) -> void:
    if not is_alive:
        return

    _handle_movement()
    _do_animations()
    move_and_slide()


func _on_body_area_body_entered(body: Node2D) -> void:
    if not is_alive:
        return

    if body is KillableMob and not body.alive:
        return

    _die()


func _on_jump_area_entered(area: Area2D) -> void:
    if area.name == "KillArea":
        area.get_parent().kill()
        velocity.y = jump_speed


func _handle_air_movement() -> void:
    pass


func _handle_floor_movement() -> void:
    if PlayerInputs.jump(): # Normal jump
        velocity.y = jump_speed

    if PlayerInputs.left():
        velocity.x -= walk_acceleration
        if abs(velocity.x) >= max_speed: velocity.x = - max_speed

    if PlayerInputs.right():
        velocity.x += walk_acceleration
        if abs(velocity.x) >= max_speed: velocity.x = max_speed

    if not PlayerInputs.left() and not PlayerInputs.right(): # Decelerate
        if (velocity.x > 0):
            velocity.x -= walk_deceleration
            if velocity.x < 0: velocity.x = 0
        elif (velocity.x < 0):
            velocity.x += walk_deceleration
            if velocity.x > 0: velocity.x = 0
    
    
func _handle_movement() -> void:
    velocity.y += gravity

    if is_on_floor():
        _handle_floor_movement()

    else: # Is in the air
        _handle_air_movement()

    # Wall jump
    if is_on_wall_only() and PlayerInputs.jump():
        velocity.y = jump_speed
        velocity.x = - get_wall_normal().x * (jump_speed * 2)


func _die():
    is_alive = false

    $Animations.play("death")

    player_died.emit()


func _do_animations() -> void:
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
