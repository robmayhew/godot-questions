extends Node2D

@onready var tilemap_layer: TileMapLayer = $TileMapLayer
const TURRET_SCENE := preload("res://turret.tscn")
var availiable_turrets = 5
var death_boost = 2
var placed_turrets: Dictionary = {}  # Maps Vector2i tilemap position to turret node
func _ready() -> void:
	# Update astar grid with solid tiles based on "open" custom data
	Global.update_points_now_solid(tilemap_layer)
	_on_creep_ready_for_next_cell(Vector2.ZERO)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_click(event.position)
	elif event is InputEventScreenTouch:
		#if event.pressed:
		#	_handle_click(event.position)
		_update_cursor(event.position)
	if event is InputEventMouseMotion:
		_update_cursor(event.position)
	elif event is InputEventScreenDrag:
		_update_cursor(event.position)

func _update_cursor(pos: Vector2) -> void:
	var cell = tilemap_layer.local_to_map(pos)
	$Cursor.blocking(Global.will_block_path(cell))
	$Cursor.position = tilemap_layer.map_to_local(cell)

func _handle_click(global_position: Vector2) -> void:
	# Convert global mouse position to tilemap coordinates
	var tilemap_pos = tilemap_layer.local_to_map(global_position)
	var data = tilemap_layer.get_cell_tile_data(tilemap_pos)
	if data.get_custom_data("open"):
		if not Global.will_block_path(tilemap_pos):
			if availiable_turrets > 0:
				availiable_turrets -= 1
			# Update the tilemap cell (example: set to solid tile ID 1)
			# You can change the tile ID to whatever represents "solid" in your tileset
				tilemap_layer.set_cell(tilemap_pos, 1, Vector2i(19,10))
				var turret = TURRET_SCENE.instantiate()
				turret.global_position = tilemap_layer.map_to_local(tilemap_pos)
				tilemap_layer.add_child(turret)
				# Store turret in dictionary for later removal
				placed_turrets[tilemap_pos] = turret
				# Update the AstarGrid2D to mark this cell as solid
				Global.set_cell_solid(tilemap_pos, true)
				# Check if grid is now blocked
		else:
			$ErrorSound.play()
	elif data.get_custom_data("turret"):
		# Remove the turret sprite if it exists
		if placed_turrets.has(tilemap_pos):
			var turret = placed_turrets[tilemap_pos]
			turret.queue_free()  # Remove from scene
			placed_turrets.erase(tilemap_pos)  # Remove from dictionary
		# Reset the tile
		tilemap_layer.set_cell(tilemap_pos,1, Vector2i(1,10))
		Global.set_cell_solid(tilemap_pos, false)
		availiable_turrets += 1


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


func _on_creep_dead() -> void:
	var new_position = tilemap_layer.map_to_local(Global.CREEP_SPAWN)
	$Creep.global_position = new_position
	$Creep.target_position = new_position;
	death_boost *= 2
	$Creep.health = 10 + death_boost
	pass # Replace with function body.
