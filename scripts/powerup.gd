extends KinematicBody2D

export var speed:int = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("powerup")
	pass # Replace with function body.


func _physics_process(_delta):
	process_movement()
#	process_collision()
	pass

func process_movement()->Vector2:
	var direction = Vector2(-1, 0)
	return move_and_slide(direction * speed)


#func process_collision()->void:
#	if get_slide_count() > 0:
#		var collision = get_slide_collision(get_slide_count() - 1)
#		if collision != null and collision.collider != null:
#			if collision.collider.collision_layer == 1:
#				destroy()
#	pass

func destroy():
#	print("Got power up")
	$CollisionShape2D.disabled = false
	hide()
	$AudioStreamPlayer2D.play()
	pass


func _on_AudioStreamPlayer2D_finished():
	queue_free()
	pass # Replace with function body.
