extends Area2D

var bullet_speed := 1000.0
var direction := 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += bullet_speed * direction * delta



func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func set_direction(dir):
	direction = dir
	
