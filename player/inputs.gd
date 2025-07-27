class_name PlayerInputs

static func left() -> bool:
    return Input.is_action_pressed('move_left')

static func right() -> bool:
    return Input.is_action_pressed('move_right')

static func jump() -> bool:
    return Input.is_action_just_pressed('jump')

static func run() -> bool:
    return Input.is_action_pressed('run')
