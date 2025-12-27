extends Node

const CELL_WIDTH:int = 32
const CELL_HEIGHT:int = 32
const GRID_START:Vector2i = Vector2i(17,2)
const GRID_END:Vector2i = Vector2i(33,17)
const CREEP_SPAWN:Vector2i = Vector2i(26,2)
const CREEP_TARGET:Vector2i = Vector2i(30,17)

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

func set_cell_solid(grid_pos: Vector2i, solid: bool) -> void:
	if astar_grid.is_in_boundsv(grid_pos):
		astar_grid.set_point_solid(grid_pos, solid)
