extends KinematicBody2D

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var sprite: Sprite = get_node("Sprite")

var speed = 200.0
var velocity
var direction

func _physics_process(_delta: float) -> void:
	# Get direction and move
	if is_instance_valid(player):
		direction = (player.position - get_global_position()).normalized()
		#look_at(player.position)
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
		
		velocity = direction * speed
		velocity = move_and_slide(velocity)

func change_pass():
	if sprite.frame_coords.x == 0:
		sprite.frame_coords.x = 1
	else:
		sprite.frame_coords.x = 0

func _on_Area2D_body_entered(body):
	body.get_hit()
