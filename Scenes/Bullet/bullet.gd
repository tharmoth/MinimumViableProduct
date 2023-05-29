extends Area2D

@export var lifetime: int = 10  # seconds

var speed: int
var damage: int
var velocity: Vector2

@onready var lifetime_timer := $LifetimeTimer as Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# create a one-shot timer for lifetime
	lifetime_timer.start(lifetime)

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func start(_position: Vector2, _rotation: float, _speed: int, _damage: int, _target=null) -> void:
	global_position = _position
	rotation = _rotation
	speed = _speed
	damage = _damage
	velocity = Vector2.RIGHT.rotated(_rotation) * speed

func _on_body_entered(body):
	if body.has_method("subtract_health"):
		body.subtract_health(damage)
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

