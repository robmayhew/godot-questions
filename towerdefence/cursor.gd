extends Node2D


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass
	
func blocking(blocking:bool):
	if blocking:
		$Error.visible = true
		$Status.color = Color(0.922, 0.0, 0.0, 0.365)
	else:
		$Error.visible = false
		$Status.color = Color(0.0, 0.945, 0.0, 0.455)
