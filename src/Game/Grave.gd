extends Node2D

onready var cemetery: Node2D = get_parent().get_parent()
onready var body_sprite: Sprite = get_node("Body")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var timer: Timer = get_node("Timer")
onready var audio: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")
onready var zombie_path = preload("res://src/Game/Zombie.tscn")

const GRAVE_COLOR_W = Color("#FFFFFF")
const GRAVE_COLOR_R = Color("#FF0000")
const GRAVE_COLOR_Y = Color("#FFFF00")

var rng = RandomNumberGenerator.new()
var idle_min_time = 2 #Double speed, half the time - 5s
var idle_max_time = 0.33 #A third of the speed, three times the time - 30s
var cracked = false
var crack_min_time = 10
var crack_max_time = 20
var opened = false
var choosed_speed: float

func _ready():
	rng.randomize()
	choosed_speed = rng.randf_range(idle_max_time, idle_min_time)
	anim.set_speed_scale(choosed_speed)
	anim.play("Start")

func _process(_delta):
	if cracked:
		var delta_time = 1 - timer.get_time_left() / choosed_speed # 0 - Yellow ~ 1 - Red
		var current_color = GRAVE_COLOR_Y.linear_interpolate(GRAVE_COLOR_R, delta_time)
		body_sprite.set_modulate(current_color)

func close_grave() -> bool:
	if cracked:
		cracked = false
		
		body_sprite.set_modulate(GRAVE_COLOR_W)
		timer.stop()
		
		choosed_speed = rng.randf_range(idle_max_time, idle_min_time)
		anim.set_speed_scale(choosed_speed)
		anim.play("Flower")
		
		cemetery.up_score()
		
		return true
	return false

func crack_grave():
	choosed_speed = rng.randf_range(crack_min_time, crack_max_time)
	timer.set_wait_time(choosed_speed)
	timer.start()
	cracked = true

func open_grave():
	cracked = false
	opened = true
	body_sprite.set_modulate(GRAVE_COLOR_W)
	get_parent().get_parent().grave_opened()
	
	audio.play(0)
	var zombie = zombie_path.instance()
	get_parent().get_parent().add_child(zombie)
	zombie.position = global_position

func _on_Timer_timeout():
	anim.set_speed_scale(1.0)
	anim.play("Cracking")
