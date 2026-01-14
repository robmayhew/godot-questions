extends PlatformAwareCharacter


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Get the tile at the player's current position
	check_tile_properties()
	if is_on_ladder:
		print("Box on ladder")
	else:
		# Apply gravity when not on ladder
		if not is_on_floor_tile:
			velocity += get_gravity() * delta
		else:
			velocity.y = 0



	move_and_slide()
