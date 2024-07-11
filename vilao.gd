extends CharacterBody2D

@onready var enemy_sprites = $enemySprites

@onready var hitbox = $hitbox

const bullet_scene = preload("res://bullet2.tscn")

const SPEED = 30.0
var count = 0
var direction := 1

var acertou = 0

@onready var detector = $detector


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var point_a = Vector2(650, 400)
@export var point_b = Vector2(800, 400)
@export var speed = 150

var moving_to_b = false

#func move(delta):
#	if moving_to_b:
#		position = position.move_toward(point_b, speed * delta)
#		if position.distance_to(point_b) < 1:
	#		enemy_sprites.flip_h = !enemy_sprites.flip_h
	#		moving_to_b = false
#	else:
	#	position = position.move_toward(point_a, speed * delta)
#		if position.distance_to(point_a) < 1:
#			enemy_sprites.flip_h = !enemy_sprites.flip_h
	#		moving_to_b = true


func _physics_process(delta):
	enemy_sprites.play("shooting")
	acertou = hitbox.retornaAcerto()
	if acertou == 1:
		enemy_sprites.play("death1")
		await get_tree().create_timer(1.5).timeout
		enemy_sprites.position.y = -30
		enemy_sprites.play("death4")
		await get_tree().create_timer(1.0).timeout
		hitbox.liberaHitbox()

		

		

			
			
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta
	
	#if is_on_wall():
	#	direction *= -1
	#	enemy_sprites.scale.x =  direction
	
	#if !detector.is_colliding():
	#	direction *= 1
	#	enemy_sprites.scale.x = direction
	
	#velocity.x = direction * SPEED
	
	move_and_slide()
	
func shoot_bullet():
	var bullet_instance = bullet_scene.instantiate()
	add_child(bullet_instance)
