extends CharacterBody2D


@export var speed := 1000.0

func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_hurtbox_body_entered(body: Node2D) -> void:
	print("HIT ", body.name)
	if body.is_in_group("creep"):
		body.hit();
	queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("HIT AREA")
		
	queue_free()
	pass # Replace with function body.


func _on_hurtbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("HIT Area")
	pass # Replace with function body.
