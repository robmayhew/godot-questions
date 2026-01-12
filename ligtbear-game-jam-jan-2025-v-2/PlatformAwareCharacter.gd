extends CharacterBody2D
class_name PlatformAwareCharacter


var is_on_ladder = false
var is_on_floor_tile = false
var is_at_door = false
var door_number = 0
var opening_door_number = 0
var last_position:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func check_tile_properties() -> void:
	var tileMapLayer = get_tilemap_layer();
	if not tileMapLayer:
		return
	if global_position == last_position:
		return
	
	last_position = global_position
	# Get tile coordinates at player position
	var tile_pos = tileMapLayer.local_to_map(global_position)

	# Get custom data for this tile
	
	var bottom_pos = tileMapLayer.get_neighbor_cell(tile_pos, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	var top_pos = tileMapLayer.get_neighbor_cell(tile_pos, TileSet.CELL_NEIGHBOR_TOP_SIDE)
	is_on_ladder = false
	is_on_floor_tile = false
	is_at_door = false
	door_number = 0
	opening_door_number = 0
	var points:Array[Vector2i] = [
		tile_pos,
		#top_pos,
		bottom_pos		
	];
	
	for c in points:
		var tile_data = tileMapLayer.get_cell_tile_data(c)
		if tile_data:
			if tile_data.get_custom_data("ladder"):
				is_on_ladder = true
			if tile_data.get_custom_data("door"):
				is_at_door = true
			var d = tile_data.get_custom_data("door_number")
			if d and d > 0:
				door_number = d;
	# Only check below for floor
	var tile_data = tileMapLayer.get_cell_tile_data(bottom_pos)
	if tile_data:
		is_on_floor_tile = tile_data.get_custom_data("floor")

		
func get_tilemap_layer() -> TileMapLayer:
	var nodes := get_tree().get_nodes_in_group("level_map")
	return nodes[0] if not nodes.is_empty() else null
