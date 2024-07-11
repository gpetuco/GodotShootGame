extends CharacterBody2D


@export var speed = 300.0
@export var jump_speed := -1000.0
@export var gravity := 2500.0
@onready var sprite = $PlayerSprite




@onready var hitbox_player = get_node("hitboxPlayer")
@onready var death = $Death as AudioStreamPlayer

@onready var sound = $PlayerSound
@onready var timer = $DelayTimer
@onready var shoot = $Shoot as AudioStreamPlayer
@onready var reload = $Reload as AudioStreamPlayer
@onready var noAmmo = $NoAmmo as AudioStreamPlayer

@onready var enemy = get_node("vilao")

#@onready var bullet_position = $Level/AnimPlayer/bullet_position
#@onready var shoot_cooldown = $Level/AnimPlayer/shoot_cooldown

const bullet_scene = preload("res://bullet.tscn")
const hudInstance = preload("res://hud.gd")

var acertou = 0
var is_s_pressed: bool = false
var is_r_pressed: bool = false
var is_space_pressed: bool = false
var is_mouse_button_pressed: bool = false
var ammo = 10

signal jumped
signal tiro

func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func get_side_input():	
	velocity.x = 0
	var vel := Input.get_axis("left", "right")
	#if Input.is_action_pressed("left"):
	#	if sign(bullet_position.position.x) == 1:
	#		bullet_position.position.x *= -1
		
	#if Input.is_action_pressed("right"):
	#	if sign(bullet_position.position.x) == -1:
	#		bullet_position.position.x *= -1
		
	var jump := Input.is_action_just_pressed('jump')
	var tiros := Input.is_action_just_pressed('tiros')

	if is_on_floor() and jump:
		velocity.y = jump_speed


		
		# Reproduz o som de pulo
		sound.play()
		
	velocity.x = vel * speed
	
func animate():
	sprite.scale = Vector2(2, 2)

	
	
	sprite.play("walking")
		
		
# Função chamada quando a cena estiver pronta
func _ready():
	set_process_input(true)

# Função chamada a cada evento de entrada
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_S:
			if sprite.animation == "right":
				sprite.play("down")
			elif sprite.animation == "left":
				sprite.play("downLeft")
			else:
				sprite.play("down")
		if event.pressed and event.keycode == KEY_R:
			ammo = 10
			get_tree().call_group("HUD", "reloadAmmo")
			get_tree().call_group("HUD", "_ready")
			reload.play()
			sprite.play("reload")
			await get_tree().create_timer(0.5).timeout
			sprite.play("right")
		if event.pressed and event.keycode == KEY_SPACE:
			sprite.play("up")
			await get_tree().create_timer(0.8).timeout
			sprite.play("right")
		if event.pressed and event.keycode == KEY_W:
			sprite.play("upMira")
			await get_tree().create_timer(0.8).timeout
			sprite.play("right")
		if event.pressed and event.keycode == KEY_F:
			if ammo > 0:
				shoot_bullet()
			ammo = ammo - 1
			get_tree().call_group("HUD", "updateScore")
			if sprite.animation == "right":
				sprite.play("shoot")
				await get_tree().create_timer(0.3).timeout
				sprite.play("right")
			elif sprite.animation == "down":
				sprite.position.x += 15
				sprite.play("shootDeitado")
				await get_tree().create_timer(0.3).timeout
				sprite.position.x -= 15
				sprite.play("down")
			elif sprite.animation == "downLeft":
				sprite.position.x -= 15
				sprite.play("shootDownLeft")
				await get_tree().create_timer(0.3).timeout
				sprite.position.x += 15
				sprite.play("downLeft")
			elif sprite.animation == "left":
				sprite.play("shootLeft")
				await get_tree().create_timer(0.3).timeout
				sprite.play("left")
	

func animate_side():
	if acertou == 1:
		death.play()
	sprite.scale = Vector2(2, 2)
	if velocity.x > 0:
		sprite.play("right")
	elif velocity.x < 0:
		sprite.play("left")
		
	else:
		sprite.stop()

		
func move_8way(delta):
	if acertou == 1:
		death.play()
	get_8way_input()
	animate()
	move_and_slide()
	
func move_side(delta):	
	if acertou == 1:
		death.play()
	velocity.y += gravity * delta
	get_side_input()
	animate_side()
	move_and_slide()
	#print(velocity * delta)
func _process(delta):
	acertou = hitbox_player.retornaAcerto()
	if acertou == 1:
		death.play()
func _physics_process(delta):
	acertou = hitbox_player.retornaAcerto()
	if acertou == 1:
		death.play()
		sprite.play("death1")
		await get_tree().create_timer(1.5).timeout
		sprite.play("death2")
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://game_over.tscn")
	#move_8way()
	move_side(delta)

func shoot_bullet():
	var bullet_instance = bullet_scene.instantiate()
	add_child(bullet_instance)

