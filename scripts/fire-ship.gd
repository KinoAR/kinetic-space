extends Entity

export var fire_cooldown:int = 1
const BULLET = preload("res://weapons/Bullet.tscn")
var fire_direction:Vector2 = Vector2(-1, 0)
var fire_angle:float = 0.0
var player_in_circle : bool = false
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	$FireTimer.start(fire_cooldown)
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

func fire_projectile(direction:Vector2)->bool:
	print("Enemy Fire")
	var bullet = BULLET.instance()
	get_parent().add_child(bullet)
	bullet.fire($FirePoint.global_position, direction)
	bullet.rotation_degrees = -90
	$AudioStreamPlayer2.play()
	return true

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
	is_dead = true
	pass


func _on_FireTimer_timeout():
	if player_in_circle and is_dead == false:
		fire_projectile(fire_direction)
	$FireTimer.start(fire_cooldown)
	pass # Replace with function body.



func _on_Area2D_body_entered(body):
	if body.collision_layer == 1:
		# Player Node
		var player = body
		# print("Found Player") Work in progress
		fire_direction = global_position.direction_to(player.global_position)
		rotation = fire_direction.angle()
		rotation_degrees += 180
		fire_angle = position.angle_to_point(player.global_position)
		player_in_circle = true
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.collision_layer == 1:
		player_in_circle = false
	pass # Replace with function body.


func _on_AudioStreamPlayer_finished():
	queue_free()
	pass # Replace with function body.
