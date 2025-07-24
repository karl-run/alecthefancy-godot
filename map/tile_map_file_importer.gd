extends TileMapLayer
class_name TileMapFileImporter

func _ready():
	loadMap("res://assets/maps/main.map")

func loadMap(path: String) -> void:
	var data  := getMapData(path)
	var lines := data.split("\n")

	for line_index in len(lines):
		var line: String = lines[line_index]
		for char_index in len(line):
			var character := line[char_index]
			var position  := Vector2i(char_index, line_index)

			print(character, ", ", character.unicode_at(0), " - ", "A".unicode_at(0), ":", "Z".unicode_at(0))
			var charUnicode := character.unicode_at(0)
			if ((charUnicode) >= "A".unicode_at(0) and (charUnicode) <= "Z".unicode_at(0)):
				set_cell(position, 0, char_to_tile_coords(character))

func char_to_tile_coords(ch: String) -> Vector2i:
	var index  := ch.unicode_at(0) - 65
	var x: int =  index % 9
	var y: int =  index / 9

	print(ch, "(", ch.unicode_at(0) - 65, ") ", " became ", x, ":", y)
	return Vector2i(x, y)


func getMapData(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)

	assert(file != null, "Could not open file: " + path)

	var map_data: String = file.get_as_text()
	file.close()

	return map_data
