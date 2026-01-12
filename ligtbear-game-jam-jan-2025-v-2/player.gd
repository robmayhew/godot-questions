extends PlatformAwareCharacter


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var climb_speed := 180.0
var tileMapLayer: TileMapLayer

@onready var sprite = $Sprite



signal opening_door
signal player_offscreen

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
	check_if_offscreen()


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
		if door_number != opening_door_number:
			print("Opening door number ", door_number)
			opening_door_number = door_number
			opening_door.emit(door_number)
		
		#if door_scenes.get(0):
			#print("Opening door to ", door_scenes.get(door_number-1).resource_path)
			#is_at_door = false
			#SceneManager.change_scene(door_scenes.get(door_number - 1).resource_path)

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
		

func check_if_offscreen() -> void:
	var viewport_rect = get_viewport_rect()
	var screen_pos = global_position

	# Check if player is outside viewport bounds
	if screen_pos.x < viewport_rect.position.x or \
	   screen_pos.x > viewport_rect.position.x + viewport_rect.size.x or \
	   screen_pos.y < viewport_rect.position.y or \
	   screen_pos.y > viewport_rect.position.y + viewport_rect.size.y:
		player_offscreen.emit()
	
