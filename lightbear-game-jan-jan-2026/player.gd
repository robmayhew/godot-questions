extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var climb_speed := 180.0
@export var tileMapLayer: TileMapLayer

@onready var sprite = $Sprite

var is_on_ladder = false
var is_on_floor_tile = false

func _physics_process(delta: float) -> void:
	# Get the tile at the player's current position
	check_tile_properties()

	# Handle ladder climbing
	if is_on_ladder:
		handle_ladder_movement()
	else:
		# Apply gravity when not on ladder
		if not is_on_floor_tile:
			velocity += get_gravity() * delta

		# Handle floor movement
		if is_on_floor_tile:
			handle_floor_movement()

	move_and_slide()
	update_animation()

func check_tile_properties() -> void:
	if not tileMapLayer:
		return

	# Get tile coordinates at player position
	var tile_pos = tileMapLayer.local_to_map(global_position)

	# Get custom data for this tile
	var tile_data = tileMapLayer.get_cell_tile_data(tile_pos)
	var bottom_pos = tileMapLayer.get_neighbor_cell(tile_pos, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)

	if tile_data:
		is_on_ladder = tile_data.get_custom_data("ladder")	
	
	else:
		is_on_ladder = false
		
	
	tile_data = tileMapLayer.get_cell_tile_data(bottom_pos)
	if tile_data:
		is_on_floor_tile = tile_data.get_custom_data("floor")
	else:
		is_on_floor_tile = false
		

func handle_ladder_movement() -> void:
	# Zero out gravity when on ladder
	velocity.y = 0

	# Vertical movement on ladder
	if Input.is_action_pressed("ui_up"):
		velocity.y = -climb_speed
	elif Input.is_action_pressed("ui_down"):
		velocity.y = climb_speed

	# Horizontal movement on ladder
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_floor_movement() -> void:
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	velocity.y = 0
	# Get input direction and handle movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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
