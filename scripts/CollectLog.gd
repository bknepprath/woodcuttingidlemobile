extends Node2D

@export var min_speed: float = 350.0
@export var max_speed: float = 550.0
@export var gravity: float = 1200.0

@export var min_angle_deg: float = -150.0
@export var max_angle_deg: float = -30.0   # make sure min < max in the Inspector

@export var min_rot_speed: float = -6.0
@export var max_rot_speed: float = 6.0

@export var lifetime: float = 1.2

var velocity: Vector2
var rot_speed: float
var elapsed: float = 0.0

@onready var sfx_pop: AudioStreamPlayer2D = $SfxPop

func _ready() -> void:
	randomize()

	# play the pop sound with tiny pitch variation
	if sfx_pop.stream:
		sfx_pop.pitch_scale = randf_range(0.85, 1.15)
		sfx_pop.play()

	var angle_deg := randf_range(min_angle_deg, max_angle_deg)
	var angle := deg_to_rad(angle_deg)
	var speed := randf_range(min_speed, max_speed)

	velocity = Vector2.RIGHT.rotated(angle) * speed
	rot_speed = randf_range(min_rot_speed, max_rot_speed)


func _process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta

	rotation += rot_speed * delta

	elapsed += delta
	if elapsed > lifetime:
		queue_free()
