extends CharacterBody2D

@export var speed := 200.0
var target_position:Vector2 = Vector2.ZERO
signal ready_for_next_cell

func _physics_process(delta: float) -> void:
	if target_position == Vector2.ZERO:
		ready_for_next_cell.emit(Vector2.ZERO)
		return
	if global_position.distance_to(target_position) < 2.0:
		velocity = Vector2.ZERO
		ready_for_next_cell.emit(global_position)
		return

	var direction := (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
