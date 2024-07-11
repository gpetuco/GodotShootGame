extends Node2D

@onready var player : CharacterBody2D = $Level/AnimPlayer
@onready var hud : CanvasLayer = $HUD
@onready var sceneLimit : Marker2D = $Level/SceneLimit
@onready var noAmmo = $Level/AnimPlayer/NoAmmo as AudioStreamPlayer
@onready var shoot = $Level/AnimPlayer/Shoot as AudioStreamPlayer
@onready var enemy : CharacterBody2D = $Level/enemy
@onready var enemy2 : CharacterBody2D = $Level/enemy2
@onready var enemy3 : CharacterBody2D = $Level/enemy3
@onready var enemy4 : CharacterBody2D = $Level/enemy4
@onready var enemy5 : CharacterBody2D = $Level/enemy5
@onready var kitmedico = $Kitmedico
@onready var kit = $Kitmedico/kit

var ammo : int = 10
var currentScene = null
var lowpass : AudioEffectLowPassFilter

var inimigo = 1

func _ready() -> void:
	if (enemy):
		enemy.scale = Vector2(1.3, 1.3)
	if (enemy2):
		enemy2.scale = Vector2(1.3, 1.3)
	if (enemy3):
		enemy3.scale = Vector2(1.3, 1.3)
	if (enemy4):
		enemy4.scale = Vector2(1.3, 1.3)
	if (enemy5):
		enemy5.scale = Vector2(1.3, 1.3)
	print("Jogo começou!")
	print("Pos:"+str(player.position))
	lowpass = AudioServer.get_bus_effect(1, 0) as AudioEffectLowPassFilter # Barramento 1 (Music), efeito 0 (Filtro passa-baixa)
	lowpass.cutoff_hz = 20000 # inicial, sem corte de freq.

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			shoot.play()
			if inimigo == 1:
				enemy.shoot_bullet()
				inimigo += 1
			elif inimigo == 2:
				enemy2.shoot_bullet()
				inimigo += 1
				print (inimigo)
			elif inimigo == 3:
				enemy3.shoot_bullet()
				inimigo += 1
			elif inimigo == 4:
				enemy4.shoot_bullet()
				inimigo += 1
			elif inimigo == 5:
				enemy5.shoot_bullet()
				inimigo = 1
			
func _physics_process(delta: float) -> void:
	if sceneLimit == null:
		player = $Level/AnimPlayer
		sceneLimit = $Level/SceneLimit		
	if player.position.y > sceneLimit.position.y:
		get_tree().change_scene_to_file("res://game_over.tscn")
	if player.position.x >= 3000:
		get_tree().change_scene_to_file("res://win.tscn")
	if player.position.x >= 940:
		#kit.play()
		kitmedico.visible = false
	#if Input.is_action_just_pressed("change"):	# mapeada para "X"	
	#	call_deferred("goto_scene","res://levels/level2.tscn")

		
	# Tecla F liga/desliga o filtro passa-baixa
	if Input.is_action_just_pressed("lowpass"):
		if lowpass.cutoff_hz == 500:
			lowpass.cutoff_hz = 20000
		else:
			lowpass.cutoff_hz = 500
		
func updateScore():
	if ammo != 0:
		shoot.play()
		ammo -= 1
	else:
		noAmmo.play()

	hud.setScore(ammo)

func reloadAmmo():
	ammo = 10
	hud.setScore(10)
	

func _on_jumped():
	updateScore()
	
func goto_scene(path: String):
	print("Total children: "+str(get_child_count()))
	
	var res := ResourceLoader.load(path)
	currentScene = res.instantiate()
	
	var world := get_child(2)
	world.free()
	
	sceneLimit = null
	add_child(currentScene)


func _on_hitbox_player_body_entered(body):
	print("Ferido")
