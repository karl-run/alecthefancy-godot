extends VisibleOnScreenNotifier2D

@export var default_mode := Node.PROCESS_MODE_DISABLED

func _ready() -> void:
    process_mode = default_mode

func _on_screen_entered() -> void:
    get_parent().process_mode = Node.PROCESS_MODE_INHERIT


func _on_screen_exited() -> void:
    get_parent().process_mode = Node.PROCESS_MODE_DISABLED
