extends Camera2D

@export var target: Node2D


func _process(delta: float) -> void:
    global_position.x = target.global_position.x
