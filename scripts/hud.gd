extends CanvasLayer

const LIFE = preload("res://scenes/LifeTexture.tscn")

var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("hud")
	$GameOverContainer.hide()
	$ControlsTimer.start()
	pass # Replace with function body.

func update_score():
	score = score + 100
	$Score.text = "Score %s" % [score]
	pass

func _on_Bullet_hit_enemy():
	update_score()
	pass # Replace with function body.


func _on_Player_lives_update(lives):
	for child in $LifeContainer.get_children():
		child.queue_free()
	for num_life in lives:
		$LifeContainer.add_child(LIFE.instance())
	pass # Replace with function body.


func _on_Player_game_over():
	$GameOverContainer.show()
	pass # Replace with function body.


func _on_exitButton_pressed():
	get_tree	().quit()
	pass # Replace with function body.


func _on_continueButton_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_ControlsTimer_timeout():
	$ControlsLabel.hide()
	pass # Replace with function body.
