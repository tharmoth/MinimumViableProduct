extends Area2D

var targets: Array[Node2D]

@export var rot_speed: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update draw
	queue_redraw()
	if not targets.is_empty():
		# handle the gun rotation
		var target_pos: Vector2 = targets.front().global_position
		var target_rot: float = global_position.direction_to(target_pos).angle()
		rotation = lerp_angle(rotation, target_rot, rot_speed * delta)

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
