extends KinematicBody2D

export var speed:int = 200
var direction = Vector2(0, 0)
const SPACE_FORWARD = 20

signal hit_enemy
signal hit_player

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bullets")
	call_deferred("connect_with_hud")
	pass # Replace with function body.

func connect_with_hud()->void:
	var hud_node = get_tree().get_nodes_in_group("hud").front()
	connect("hit_enemy", hud_node, "_on_Bullet_hit_enemy")
	pass

func fire(pos:Vector2, dir:Vector2)->Vector2:
	if dir.x == 1:
		rotation_degrees = 90
	if dir.x == -1:
		rotation_degrees = -90
	if dir.y == 1:
		rotation_degrees = 135
	if dir.y == -1:
		rotation_degrees = 45
	# Change to global position, because the bullet needs to spawn
	# Where the enemy is and not at the position of it's parent node
	global_position = pos
	direction = dir
	return direction

func _process(delta):
	process_lifespan()
	pass

func _physics_process(delta):

	process_collision()
	pass

func process_lifespan():
	var viewport = get_viewport_rect().end
	if viewport.x < position.x or position.y > viewport.y:
		destroy()
	pass

func process_collision()->bool:
	move_and_slide(direction * speed)
	if get_slide_count() > 0:
		var collision = get_slide_collision(get_slide_count() - 1)
		if collision != null:
			if collision.collider.collision_layer == 4:
				emit_signal("hit_enemy")
				collision.collider.destroy()
				destroy()
			if collision.collider.collision_layer == 1:
				emit_signal("hit_player")
				collision.collider.destroy()
				destroy()
	return false

func destroy():
#	print("Destroyed Bullet")
	hide()
	queue_free()
	pass
