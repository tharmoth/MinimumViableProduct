extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	var direction = Input.get_axis("ui.left", "ui.right")
	velocity.x = move_toward(velocity.x, 200, SPEED)
	move_and_slide()
