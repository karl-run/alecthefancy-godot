extends CanvasLayer

@export var distance_value: Label
@export var time_value: Label
@export var points_value: Label

## Time value is 0.1 seconds
var time: int = 0


func _on_alec_distance_changed(distance: int) -> void:
    distance_value.text = str(distance)
    points_value.text = calculate_points(distance, time)


func _on_timer_timeout() -> void:
    time += 1
    time_value.text = "%s:%s:%s" % [
    str(time / 600).pad_zeros(2),
    str((time / 10) % 60).pad_zeros(2),
    str(time % 10).pad_zeros(2)
    ]


func calculate_points(distance: int, time: int) -> String:
    # Subtract 4 points per whole second
    var seconds: int = time / 10
    var points: int  = (distance * 4) - (seconds * 4)

    return str(points)