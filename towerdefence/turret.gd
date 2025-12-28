extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var targets: Array[Node2D] = []
var target: Node2D = null
const BULLET_SCENE:= preload("res://bullet.tscn")
@export var fire_rate := 0.5

var _cooldown := 0.0

func _physics_process(delta: float) -> void:
	target = _pick_target()
	_cooldown -= delta
	if target:
		$Barrel.look_at(target.global_position)
		if _cooldown <= 0.0:
			fire()
			_cooldown = fire_rate
			
func fire():
	var projectile = BULLET_SCENE.instantiate()
	projectile.global_position = global_position
	projectile.rotation = $Barrel.rotation
	get_tree().current_scene.add_child(projectile)
	$ShootSound.play()

func _pick_target():
	# Remove freed targets
	targets = targets.filter(func(x): return is_instance_valid(x))
	if targets.is_empty():
		return null
	var best := targets[0]
	var best_d := global_position.distance_squared_to(best.global_position)
	for t in targets:
		var d := global_position.distance_squared_to(t.global_position)
		if d < best_d:
			best_d = d
			best = t
	return best	
	
func _on_range_body_entered(body: Node2D) -> void:
	targets.append(body as Node2D)


func _on_range_body_exited(body: Node2D) -> void:
	targets.erase(body)
