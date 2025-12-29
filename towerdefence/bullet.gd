extends CharacterBody2D


@export var speed := 1000.0

func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_hurtbox_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("creep"):
		body.hit();
	queue_free()
