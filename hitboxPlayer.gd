extends Area2D

@onready var death = $death

var player = get_parent()

var acertou = 0
var die = 0

func retornaAcerto():
	return acertou

func liberaHitbox():
	owner.queue_free()

func _on_body_entered(body):
	acertou = 1
	die += 1
	body.queue_free()
	if(die == 1):
		death.play()
		die += 1
