extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func blocking(blocking:bool):
	if blocking:
		$Error.visible = true
		$Status.color = Color(0.922, 0.0, 0.0, 0.365)
	else:
		$Error.visible = false
		$Status.color = Color(0.0, 0.945, 0.0, 0.455)
