extends Area2D

@onready var death = $death

var enemy = get_parent()

var acertou = 0

func retornaAcerto():
	return acertou

func liberaHitbox():
	owner.queue_free()

func _on_area_entered(area):
	if area.is_in_group("bullets"):
		area.queue_free()
		acertou = 1
		death.play()
