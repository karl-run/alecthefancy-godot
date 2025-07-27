@tool

extends Node2D

@export_tool_button("Clear map", "Callable") var clear_map_action = clear_map
@export_tool_button("Load map", "Callable") var load_map_action = load_map
@export_tool_button("Load mobs", "Callable") var load_mobs_action = load_mobs
@export_tool_button("Debug Mobs", "Callable") var debug_mobs_action = debug_mobs

## The target tile map where the cells will be set
@export var tile_map: TileMapLayer
@export var mobs_map: TileMapLayer

func clear_map() -> void:
    tile_map.clear()
    mobs_map.clear()


func debug_mobs() -> void:
    #for cell in mobs_map.get_used_cells():
    #    print(mobs_map.get_cell_atlas_coords(0, cell))
    pass

func load_map() -> void:
    var lines := get_map_lines()

    for line_index in len(lines):
        var line: String = lines[line_index]
        for char_index in len(line):
            var character := line[char_index]
            var pos := Vector2i(char_index, line_index)

            # Tiles are between "A" and "Z"
            var charUnicode := character.unicode_at(0)
            if ((charUnicode) >= "A".unicode_at(0) and (charUnicode) <= "Z".unicode_at(0)):
                set_tile(character, pos)
            else: # Clear any tiles already set in editor
                tile_map.erase_cell(pos)


func load_mobs() -> void:
    var lines := get_map_lines()

    for child in get_children():
        if child is KillableMob:
            child.queue_free()

    for line_index in len(lines):
        var line: String = lines[line_index]
        for char_index in len(line):
            var character := line[char_index]
            var pos := Vector2i(char_index, line_index)

            # Mobs are between "1" and "3"
            match character:
                # Mobs:
                "1", "2", "3":
                    spawn_mob(character, pos)


func set_tile(character: String, pos: Vector2i) -> void:
    tile_map.set_cell(pos, 0, char_to_tile_coords(character))


func spawn_mob(character: String, pos: Vector2i) -> void:
    if (["1", "2", "3"].has(character) == false):
        print("Invalid character for mob spawn: " + character)
        return

    match character:
        "1":
            mobs_map.set_cell(pos, 0, Vector2i.ZERO, 3)
        "2":
            mobs_map.set_cell(pos, 0, Vector2i.ZERO, 1)
        "3":
            mobs_map.set_cell(pos, 0, Vector2i.ZERO, 2)


func char_to_tile_coords(ch: String) -> Vector2i:
    var index := ch.unicode_at(0) - 65
    var x: int = index % 9
    var y: int = index / 9

    return Vector2i(x, y)


func get_map_lines() -> PackedStringArray:
    print("Getting map from file...")

    var file: FileAccess = FileAccess.open("res://assets/maps/main.map", FileAccess.READ)

    assert(file != null, "Could not open file: " + "res://assets/maps/main.map")

    var map_data: String = file.get_as_text()
    file.close()

    return map_data.split("\n")
