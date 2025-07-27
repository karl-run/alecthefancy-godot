extends Node2D

func _is_mob_node(node: Node) -> bool:
    return node is KillableMob

func _is_processing_node(node: Node) -> bool:
    return node.process_mode == Node.PROCESS_MODE_INHERIT

func _process(_delta: float) -> void:
    var map: WorldMap = get_parent().get_node("MainMap")
    var active_mobs := map.tile_map.get_parent().get_children().filter(_is_mob_node).filter(_is_processing_node)
    var flying_mobs = active_mobs.filter(func(mob: Node): return mob is FlyingMob)
    var jumping_mobs = active_mobs.filter(func(mob: Node): return mob is JumpingMob)
    var walking_mobs = active_mobs.filter(func(mob: Node): return mob is WalkingMob)

    $CanvasLayer/Label.text = "Active Mobs: %s\nFlying: %s\nJumping: %s\nWalking: %s" % [
        active_mobs.size(),
        flying_mobs.size(),
        jumping_mobs.size(),
        walking_mobs.size()
    ]
