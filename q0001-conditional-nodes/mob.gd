extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var show_child: bool = true
var count:int = 0;
func _physics_process(delta: float) -> void:
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		show_child = !show_child
		print("Showing child ", show_child)
		
	if show_child:
		$child.visible = true
		$child/StaticBody3D/CollisionShape3D.disabled = false
		$child/StaticBody3D/RayCast3D.enabled = true
	else:
		$child.visible = false
		$child/StaticBody3D/CollisionShape3D.disabled = true
		$child/StaticBody3D/RayCast3D.enabled = false
	
	if $child/StaticBody3D/RayCast3D.is_colliding():
		print("Ray cast colliding ", count)
		count = count + 1

	
