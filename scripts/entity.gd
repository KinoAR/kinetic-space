extends KinematicBody2D

class_name Entity

export var speed:int = 200
export var health:int = 2
export var max_health:int = 2
export var def:int = 1

signal dead
signal health_update(health, max_health)

# Called when the node enters the scene tree for the first time.
func _ready():
	max_health = health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move_vector(direction:Vector2)->Vector2:
	return (direction * speed)
	pass


func add_health(value:int)->void:
	health = clamp(health + value, 0, max_health)
	emit_signal("health_update", health, max_health)
	if health <= 0:
		emit_signal("dead")
