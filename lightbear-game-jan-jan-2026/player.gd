extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var climb_speed := 180.0
@export var tileMapLayer: TileMapLayer

@onready var sprite = $Sprite
@export var door_scenes: Array[PackedScene]
@export var level_id:String

var is_on_ladder = false
var is_on_floor_tile = false
var is_at_door = false
var last_position:Vector2 = Vector2.ZERO
var door_number = 0
func _ready():
	print("Ready")




func _physics_process(delta: float) -> void:
	# Get the tile at the player's current position
	check_tile_properties()
	if is_on_ladder:
		handle_ladder_movement()
	else:
		# Apply gravity when not on ladder
		if not is_on_floor_tile:
			velocity += get_gravity() * delta

		# Handle floor movement
		if is_on_floor_tile:
			handle_floor_movement()
		
		if is_at_door:
			handle_door_opening()

	move_and_slide()
	update_animation()

func check_tile_properties() -> void:
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
			if d > 0:
				door_number = d;
	# Only check below for floor
	var tile_data = tileMapLayer.get_cell_tile_data(bottom_pos)
	if tile_data:
		is_on_floor_tile = tile_data.get_custom_data("floor")
		

func handle_ladder_movement() -> void:
	# Zero out gravity when on ladder
	velocity.y = 0
	
	# Vertical movement on ladder
	if Input.is_action_pressed("ui_up"):
		velocity.y = -climb_speed
	elif Input.is_action_pressed("ui_down") and not is_on_floor_tile:
		velocity.y = climb_speed

	# Horizontal movement on ladder
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func handle_door_opening():
	if Input.is_action_pressed("ui_up"):
		print("Opening door from level ", level_id, " id ", door_number)
		if door_scenes.get(0):
			print("Opening door to ", door_scenes.get(door_number-1).resource_path)
			is_at_door = false
			SceneManager.change_scene(door_scenes.get(door_number - 1).resource_path)

func handle_floor_movement() -> void:
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	velocity.y = 0
	# Get input direction and handle movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	sprite.flip_h = velocity.x > 0

func update_animation() -> void:
	if is_on_ladder:
		if velocity.y != 0:
			sprite.play("climb")
		else:
			sprite.stop()
	elif is_on_floor() or is_on_floor_tile:
		if abs(velocity.x) > 0:
			sprite.play("walk")
		else:
			sprite.play("idle")
	else:
		# In air
		sprite.play("idle")
