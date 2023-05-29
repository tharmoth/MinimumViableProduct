extends CharacterBody2D

var percentToTarget = 0.0
var currentPointIdx = 0
var pxlsAlreadyTraveled = 0
var speed = 300.0
var distance = 0
var targetPoint = 0
var health = 100

func _physics_process(delta):
	var invis = get_node("/root/Main/Map/NavigationPoints")
	var currentPoint = invis.get_child(currentPointIdx)
	if (currentPointIdx + 1) <= invis.get_child_count():
		targetPoint = invis.get_child(currentPointIdx + 1)
		distance = targetPoint.position.distance_to(currentPoint.position)
	
	if percentToTarget <= 1:
		pxlsAlreadyTraveled += delta * speed
		percentToTarget = pxlsAlreadyTraveled/distance
		position = currentPoint.position.lerp(targetPoint.position, percentToTarget) * 2
	else:
		currentPointIdx = currentPointIdx + 1
		pxlsAlreadyTraveled = 0
		percentToTarget = 0.0
