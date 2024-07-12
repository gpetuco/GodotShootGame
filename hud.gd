extends CanvasLayer

@onready var scoreLabel : Label = $C
@onready var ammo : Label = $Ammo

# Responsabilidade de atualizar o TEXTO
# do score na tela é do HUD!

func _ready() -> void:
	setScore(10)
	
func updateScore():
	print("updateScore do HUD!")
	
func setScore(score: int):
	scoreLabel.text = "P - ATAQUE INIMIGO\nA - move para esquerda\n D - move para direita \nW - mira para cima \nS - se abaixa \nR - recarrega \nF - Atira\nEspaço - pula"
	ammo.text = str(score)
