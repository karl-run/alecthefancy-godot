extends Node2D

## The target tile map where the cells will be set
@export var tile_map: TileMapLayer

var walking_mob: PackedScene = preload("res://mobs/walking_mob.tscn")
var flying_mob: PackedScene  = preload("res://mobs/flying_mob.tscn")
var jumping_mob: PackedScene = preload("res://mobs/jumping_mob.tscn")


func _ready():
	load_map("res://assets/maps/main.map")


func load_map(path: String) -> void:
	var data  := get_map_data(path)
	var lines := data.split("\n")

	for line_index in len(lines):
		var line: String = lines[line_index]
		for char_index in len(line):
			var character := line[char_index]
			var position  := Vector2i(char_index, line_index)

			# Tiles are between "A" and "Z"
			var charUnicode := character.unicode_at(0)
			if ((charUnicode) >= "A".unicode_at(0) and (charUnicode) <= "Z".unicode_at(0)):
				set_tile(character, position)
			else: # Clear any tiles already set in editor
				tile_map.erase_cell(position)

			# Mobs are between "1" and "3"
			match character:
				# Mobs:
				"1", "2", "3":
					spawn_mob(character, position)


func set_tile(character: String, position: Vector2i) -> void:
	tile_map.set_cell(position, 0, char_to_tile_coords(character))


func spawn_mob(character: String, position: Vector2i) -> void:
	if (["1", "2", "3"].has(character) == false):
		print("Invalid character for mob spawn: " + character)
		return

	var mob: Node2D
	match character:
		"1":
			mob = walking_mob.instantiate()
			mob.position = position * 32
			mob.position.y += 32
		"2":
			mob = flying_mob.instantiate()
			mob.position = position * 32
		"3":
			mob = jumping_mob.instantiate()
			mob.position = position * 32

	add_child(mob)


func char_to_tile_coords(ch: String) -> Vector2i:
	var index  := ch.unicode_at(0) - 65
	var x: int =  index % 9
	var y: int =  index / 9

	return Vector2i(x, y)


func get_map_data(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)

	assert(file != null, "Could not open file: " + path)

	var map_data: String = file.get_as_text()
	file.close()

	return map_data
