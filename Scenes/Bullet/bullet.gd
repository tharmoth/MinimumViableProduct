extends Area2D

@export var lifetime: int = 10  # seconds
@export var explosion_lifetime: int = 1 # seconds

var speed: int
var damage: int
var velocity: Vector2
var explosion_range: int
var explosion_damage: int

@onready var lifetime_timer := $LifetimeTimer as Timer
@onready var explosion_timer := $ExplosionTimer as Timer
@onready var explosion_area := $ExplosionArea as Area2D
@onready var explosion_sprite := $ExplosionSprite2D as Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# create a one-shot timer for lifetime
	lifetime_timer.start(lifetime)

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func start(_position: Vector2, _rotation: float, _speed: int, _damage: int,
 _explosion_range: int, _explosion_damage: int, _target=null) -> void:
	global_position = _position
	rotation = _rotation
	speed = _speed
	damage = _damage
	explosion_range = _explosion_range
	explosion_damage = _explosion_damage
	velocity = Vector2.RIGHT.rotated(_rotation) * speed

func _on_body_entered(body):
	if body.has_method("subtract_health"):
		body.subtract_health(damage)
	if explosion_range > 0:
		for somebody in explosion_area.get_overlapping_bodies():
				if somebody.has_method("subtract_health"):
					somebody.subtract_health(explosion_damage)
					explosion_sprite.set_global_rotation_degrees(0)
					explosion_sprite.visible = true
					explosion_timer.start(explosion_lifetime)

	_explode()
	
func _on_area_entered(area):
	if area.has_method("subtract_health"):
		area.subtract_health(damage)
	_explode()

func _explode() -> void:
	# stop the bullet and disable collision
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	
func _on_lifetime_timer_timeout() -> void:
	queue_free()

func _on_explosion_timer_timeout():
	explosion_sprite.visible = false
