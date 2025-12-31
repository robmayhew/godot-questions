extends Node

const CELL_WIDTH:int = 64
const CELL_HEIGHT:int = 64
const GRID_START:Vector2i = Vector2i(1,1)
const GRID_END:Vector2i = Vector2i(9,18)
const CREEP_SPAWN:Vector2i = Vector2i(5,1)
const CREEP_TARGET:Vector2i = Vector2i(9,18)

var astar_grid: AStarGrid2D

func _ready() -> void:
	_initialize_astar_grid()

func _initialize_astar_grid() -> void:
	astar_grid = AStarGrid2D.new()

	# Calculate grid size
	var grid_width = GRID_END.x - GRID_START.x + 1
	var grid_height = GRID_END.y - GRID_START.y + 1

	# Set up the grid region (in grid coordinates)
	astar_grid.region = Rect2i(GRID_START, Vector2i(grid_width, grid_height))
	astar_grid.cell_size = Vector2(CELL_WIDTH, CELL_HEIGHT)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	# Initialize the grid
	astar_grid.update()

func update_points_now_solid(tilemap_layer:TileMapLayer):
	var used_cells = tilemap_layer.get_used_cells()

	for cell_pos in used_cells:
		var tile_data = tilemap_layer.get_cell_tile_data(cell_pos)

		if tile_data:
			var is_open = tile_data.get_custom_data("open")
			set_cell_solid(cell_pos, not is_open)
			
func will_block_path(cell:Vector2i):
	if astar_grid.is_point_solid(cell):
		return true
	set_cell_solid(cell, true)
	var path = astar_grid.get_id_path(CREEP_SPAWN, CREEP_TARGET)
	set_cell_solid(cell, false)
	return path.size() < 1

func set_cell_solid(grid_pos: Vector2i, solid: bool) -> void:
	if astar_grid.is_in_boundsv(grid_pos):
		astar_grid.set_point_solid(grid_pos, solid)
		
		
func is_at_target(tilemap_layer:TileMapLayer, global_poisition:Vector2):
	if global_poisition == Vector2.ZERO:
		return false
	var cell = tilemap_layer.local_to_map(global_poisition)
	return cell == CREEP_TARGET
		
func compute_next_target_position(tilemap_layer:TileMapLayer, global_position:Vector2):
	var start_pos: Vector2i
	if global_position == Vector2.ZERO:
		start_pos = CREEP_SPAWN
	else:
		start_pos = tilemap_layer.local_to_map(global_position)


	var goal_pos = CREEP_TARGET

	var path = astar_grid.get_id_path(start_pos, goal_pos)

	if path.size() > 1:
		var next_grid_pos = path[1]
		return tilemap_layer.map_to_local(next_grid_pos)
	elif path.size() == 1:
		return tilemap_layer.map_to_local(goal_pos)
	else:
		return global_position
