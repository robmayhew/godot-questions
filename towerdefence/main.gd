extends Node2D

@onready var tilemap_layer: TileMapLayer = $TileMapLayer

func _ready() -> void:
	# Update astar grid with solid tiles based on "open" custom data
	Global.update_points_now_solid(tilemap_layer)
	_on_creep_ready_for_next_cell(Vector2.ZERO)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_click(event.position)
	if event is InputEventMouseMotion:
		var pos = event.position
		var cell = tilemap_layer.local_to_map(pos)
		
		$Cursor.blocking(Global.will_block_path(cell))
		$Cursor.position = tilemap_layer.map_to_local(cell)

func _handle_click(global_position: Vector2) -> void:
	# Convert global mouse position to tilemap coordinates
	var tilemap_pos = tilemap_layer.local_to_map(global_position)
	var data = tilemap_layer.get_cell_tile_data(tilemap_pos)
	if data.get_custom_data("open"):
		if not Global.will_block_path(tilemap_pos):
		
			# Update the tilemap cell (example: set to solid tile ID 1)
			# You can change the tile ID to whatever represents "solid" in your tileset
			tilemap_layer.set_cell(tilemap_pos, 1, Vector2i(19,10))
		
			# Update the AstarGrid2D to mark this cell as solid
			Global.set_cell_solid(tilemap_pos, true)
			# Check if grid is now blocked
		else:
			$ErrorSound.play()


func _on_creep_ready_for_next_cell(global_position:Vector2) -> void:
	if Global.is_at_target(tilemap_layer, global_position):
		var new_position = tilemap_layer.map_to_local(Global.CREEP_SPAWN)
		$Creep.global_position = new_position
		$Creep.target_position = new_position;
		$CreepScored.play()
		return
	var new_position = Global.compute_next_target_position(tilemap_layer, global_position)
	if global_position == Vector2.ZERO:
		$Creep.global_position = new_position
	$Creep.target_position = new_position;
