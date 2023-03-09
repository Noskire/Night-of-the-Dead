extends KinematicBody2D

onready var cemetery = get_parent()
onready var sprite: Sprite = get_node("Sprite")
onready var collision: CollisionShape2D = get_node("Collision")
onready var closeRange: Area2D = get_node("CloseRange")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")

export var player_speed = 500.0

var life = 3
var velocity

func _physics_process(_delta: float) -> void:
	# Get direction and move
	velocity = get_direction() * player_speed
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("action"):
		for a in closeRange.get_overlapping_areas():
			if cemetery.flower_current > 0:
				if a.get_parent().close_grave():
					cemetery.flower_current -= 1
					cemetery.update_flowers_label()
			else:
				cemetery.apply_shake()

func get_direction() -> Vector2:
	# Get player input
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	# The player can look at four directions (N, E, S, W)
	# E and W have priority
	if abs(direction.x) > 0:
		if direction.x > 0:
			sprite.frame_coords.y = 0
		else:
			sprite.frame_coords.y = 1
	elif abs(direction.y) > 0:
		if direction.y > 0:
			sprite.frame_coords.y = 2
		else:
			sprite.frame_coords.y = 3
	
	return direction.normalized()

func change_pass():
	if sprite.frame_coords.x == 0:
		sprite.frame_coords.x = 1
	else:
		sprite.frame_coords.x = 0

func refil():
	cemetery.refil()

func get_hit():
	anim.play("hurt")
	cemetery.apply_shake()
	life -= 1
	if life == 0:
		yield(get_tree().create_timer(.1), "timeout")
		#get_tree().paused = true
		cemetery.game_over()

func _on_animation_finished(anim_name):
	if anim_name == "hurt":
		anim.play("moving")
