extends VisibleOnScreenNotifier2D


@export var default_mode := ProcessMode.PROCESS_MODE_DISABLED


func _ready() -> void:
    get_parent().process_mode = default_mode


func _on_screen_entered() -> void:
    print("Mob %s entered the screen" % get_parent().name)
    get_parent().process_mode = ProcessMode.PROCESS_MODE_INHERIT


func _on_screen_exited() -> void:
    print("Mob %s exited the screen" % get_parent().name)
    get_parent().process_mode = ProcessMode.PROCESS_MODE_DISABLED
