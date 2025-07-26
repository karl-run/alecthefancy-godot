extends CanvasLayer

@export var score_label: Label


func _on_alec_score_changed(score: int) -> void:
    score_label.text = str(score)

