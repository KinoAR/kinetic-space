extends Entity

const BULLET = preload("res://weapons/Bullet.tscn")
signal fire_projectile
signal touched_enemy
signal touch_powerup
signal game_over
signal lives_update(lives)

export var lives:int = 3
export var max_trail:int = 50

var has_power_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("player")
	emit_signal("lives_update", lives)
	pass # Replace with function body.

func _process(_delta):
	if lives > 0:
		process_attack(Input)
	pass

func _physics_process(_delta):
	process_trail()
	if lives > 0:
		process_collision()
		process_movement(Input)
	pass

func process_trail()->void:
	$Line2D.global_position = Vector2(0, 0)
	$Line2D.add_point(position)
	if len($Line2D.points) > max_trail:
		$Line2D.remove_point(0)
	pass

func process_attack(input:Input)->bool:
	if input.is_action_just_pressed("fire"):
		emit_signal("fire_projectile")
		fire_projectile(Vector2(1, 0))
		if has_power_up:
			fire_projectile(Vector2(1, 1))
			fire_projectile(Vector2(1, -1))
		return true
	else:
		return false

func fire_projectile(direction:Vector2)->bool:
	var bullet = BULLET.instance()
	get_parent().add_child(bullet)
	bullet.fire($FirePoint.global_position, direction)
	$AudioStreamPlayer2D.play()
	return true

func process_movement(input:Input)->Vector2:
	var direction = Vector2(0, 0)
	if input.is_action_pressed("ui_right"):
		direction.x = 1
	if input.is_action_pressed("ui_left"):
		direction.x = -1
	if input.is_action_pressed("ui_down"):
		direction.y = 1
	if input.is_action_pressed("ui_up"):
		direction.y = -1
	return move_and_slide(move_vector(direction))

func process_collision()->bool:
	if get_slide_count() > 0:
		var collision = get_slide_collision(get_slide_count() - 1)
		if collision != null and collision.collider != null:
			if collision.collider.collision_layer == 4:
				emit_signal("touched_enemy")
				collision.collider.destroy()
				destroy()
			if collision.collider.collision_layer == 1:
				emit_signal("hit_player")
				destroy()
			if collision.collider.collision_layer == 2:
				emit_signal("touch_powerup")
				print("Gained power up")
				collision.collider.destroy()
				has_power_up = true
	return false

func destroy():
	print("Destroyed Bullet")
	$AnimationPlayer.play("Death")
	lives -= 1
	emit_signal("lives_update", lives)
	if lives <=0:
		emit_signal("game_over")
		$GameOverAudio.play()
	$CollisionShape2D.disabled = true
	has_power_up = false
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death" and lives > 0:
		$CollisionShape2D.disabled = false
		show()
	pass # Replace with function body.


