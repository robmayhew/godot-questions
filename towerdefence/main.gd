extends Node2D

@onready var tilemap_layer: TileMapLayer = $TileMapLayer

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_click(event.position)

func _handle_click(global_position: Vector2) -> void:
	# Convert global mouse position to tilemap coordinates
	var tilemap_pos = tilemap_layer.local_to_map(global_position)

	# Check if the click is within the defined grid bounds
	if _is_within_grid(tilemap_pos):
		# Update the tilemap cell (example: set to solid tile ID 1)
		# You can change the tile ID to whatever represents "solid" in your tileset
		tilemap_layer.set_cell(tilemap_pos, 0, Vector2i(0, 0))

		# Update the AstarGrid2D to mark this cell as solid
		Global.set_cell_solid(tilemap_pos, true)

		print("Cell at ", tilemap_pos, " set to solid")

func _is_within_grid(tilemap_pos: Vector2i) -> bool:
	return (tilemap_pos.x >= Global.GRID_START.x and tilemap_pos.x <= Global.GRID_END.x and
			tilemap_pos.y >= Global.GRID_START.y and tilemap_pos.y <= Global.GRID_END.y)
