extends Node2D

const ENEMY_SHIP = preload("res://characters/BasicShip.tscn")
const ENEMY_FIRE_SHIP = preload("res://characters/FireShip.tscn")
const POWER_UP = preload("res://weapons/Powerup.tscn")

export var spawn_time:int=3
export var powerup_spawn_time:int = 10

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$SpawnTimer.start(spawn_time)
	$PowerupTimer.start(powerup_spawn_time)
	pass



func _on_SpawnTimer_timeout():
	for child in $EnemySpawners.get_children():
#		print("Adding Enemies")
		var random_int = rng.randi_range(0, 1)
		var enemy_int = rng.randi_range(1, 2)
		if random_int == 1:
			var ship = null
			if enemy_int == 2:
				ship = ENEMY_SHIP.instance()
			else:
				ship = ENEMY_FIRE_SHIP.instance()
			child.add_child(ship)
	$SpawnTimer.start(spawn_time)
	pass


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
	pass


func _on_Player_game_over():
	$AudioStreamPlayer2D.stop()
	pass


func _on_PowerupTimer_timeout():
	var node_num = rng.randi_range(1, $PowerupSpawners.get_child_count())
	$PowerupSpawners.get_child(node_num - 1).add_child(POWER_UP.instance())
	$PowerupTimer.start(powerup_spawn_time)
	pass
