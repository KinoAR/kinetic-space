extends Entity


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	pass # Replace with function body.


func _physics_process(delta):
	process_lifespan()
	process_movement()
	pass

func process_lifespan():
	var viewport = get_viewport_rect().position
	if viewport.x > global_position.x or global_position.y < viewport.y:
		despawn()
	pass

func process_movement()->Vector2:
	var direction = Vector2(-1, 0)
	return move_and_slide(move_vector(direction))

func despawn():
#	print("Destroyed Enemy Ship")
	hide()
	queue_free()
	pass

func destroy():
#	print("Destroyed Enemy Ship")
	hide()
	$AudioStreamPlayer.play()
	$CollisionShape2D.disabled = true
	pass



func _on_AudioStreamPlayer_finished():
	queue_free()
	pass # Replace with function body.
