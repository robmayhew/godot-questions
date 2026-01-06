extends Node


var current_scene = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func change_scene(packed_scene):
	goto_scene(packed_scene)
	


func _deferred_goto_scene(packed_scene:PackedScene):
	
	if not packed_scene:
		return
	current_scene.free()
	var path = packed_scene.resource_path
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
