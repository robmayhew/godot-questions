extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_opening_door(door_number) -> void:
	if door_number == 1:
		SceneManager.change_scene("res://level_b.tscn")
	pass # Replace with function body.


func _on_player_player_offscreen() -> void:
	$Player.global_position = $PlayerSpawnPoint.global_position
	pass # Replace with function body.
