extends CanvasLayer

@export var distance_value: Label
@export var time_value: Label
@export var points_value: Label

## Time value is 0.1 seconds
var time: int = 0
var current_distance: int = 0
var player_died: bool = false

func _ready() -> void:
    var button_name = InputMap.action_get_events("ui_accept").get(0).as_text()
    
    $DeathScreen/WhatToPress.text = "Press %s to continue" % button_name


func _on_alec_distance_changed(distance: int) -> void:
    current_distance = distance

    distance_value.text = str(distance)
    points_value.text = calculate_points()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept") and player_died:
        get_tree().reload_current_scene()
        return

func _on_timer_timeout() -> void:
    if player_died:
        return

    time += 1
    time_value.text = "%s:%s:%s" % [
        str(time / 600).pad_zeros(2),
        str((time / 10) % 60).pad_zeros(2),
        str(time % 10).pad_zeros(2)
    ]

func calculate_points() -> String:
    # Subtract 4 points per whole second
    var seconds: int = time / 10
    var points: int = (current_distance * 4) - (seconds * 4)

    return str(points)

func _on_alec_player_died() -> void:
    player_died = true

    $DeathScreen/ScoreContainer/Value.text = calculate_points()
    $DeathScreen.show()
