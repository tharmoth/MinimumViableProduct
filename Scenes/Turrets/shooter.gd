extends Area2D

var targets: Array[Node2D]
var can_shoot := true

@export var fire_rate: float = 0.5
@export var rot_speed: float = 8.0
@export var gun_texture: CompressedTexture2D
@export var projectile_spread: float = 0.2
@export var projectile_speed: int = 1000
@export var projectile_damage: int = 10
@export var explosion_range: int = 0
@export var explosion_damage: int = 10

@onready var firerate_timer := $FireRateTimer as Timer
@onready var muzzle := $TurretSprite2D/Muzzle as Marker2D
@onready var gun := $TurretSprite2D as Sprite2D
@onready var lookahead := $TurretSprite2D/LookAhead as RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	gun.texture = gun_texture

func shoot() -> void:
	can_shoot = false
	_instance_projectile(muzzle.global_position)
	# show reload time on HUD
	firerate_timer.start(fire_rate)

func _instance_projectile(_position: Vector2, target=null) -> void:
	var bullet = preload("res://Scenes/Bullet/bullet.tscn").instantiate()
	add_child(bullet)
	bullet.start(_position,
			gun.rotation + randf_range(-projectile_spread, projectile_spread),
			projectile_speed, projectile_damage, explosion_range, explosion_damage, target)

func _process(delta):
	# update draw
	queue_redraw()
	if not targets.is_empty():
		# handle the gun rotation
		var target_pos: Vector2 = targets.front().global_position
		var target_rot: float = fmod(global_position.direction_to(target_pos).angle(), 2*PI)
		gun.rotation = fmod(lerp_angle(gun.rotation, target_rot, rot_speed * delta), 2*PI)
		# will only fire if aiming near the target
		if can_shoot and lookahead.is_colliding():
			shoot()

func _on_body_entered(body):
	if not body in targets:
		targets.append(body)

func _on_body_exited(body):
	if body in targets:
		targets.erase(body)

func _on_area_entered(area):
	if not area in targets:
		targets.append(area)

func _on_area_exited(area):
	if area in targets:
		targets.erase(area)
		print("Test area")

func _on_fire_rate_timer_timeout():
	can_shoot = true
