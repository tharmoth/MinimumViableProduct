extends CharacterBody2D

# percentToTarget: This float variable is the calculating factor for the percentage 
# that should be multiplied by the delta for the grandma sprite to move from point a
# to point b
var percentToTarget = 0.0
# currentPointIdx: This variable gets the current child in the list of children that
# invis has
var currentPointIdx = 0
# pxlsAlreadyTraveled: This variable updates as the delta is multiplied by the
# percentToTarget variable in order to calculate the position of the next sprite for 
# the grandma to navigate to
var pxlsAlreadyTraveled = 0
var speed = 300.0
var distance = 0
var targetPoint = 0
var grandmaHealth = 100
signal grandmaReachedEnd
signal grandmaIsDead

func _physics_process(delta):
	var invis = get_node("/root/Main/Map/NavigationPoints")
	var currentPoint = invis.get_child(currentPointIdx)
	if (currentPointIdx + 1) <= (invis.get_child_count() - 1):
		targetPoint = invis.get_child(currentPointIdx + 1)
		distance = targetPoint.position.distance_to(currentPoint.position)
	else:
		grandmaReachedEnd.emit()
		return -1
	
	if percentToTarget <= 1:
		pxlsAlreadyTraveled += delta * speed
		percentToTarget = pxlsAlreadyTraveled/distance
		position = currentPoint.position.lerp(targetPoint.position, percentToTarget) * 2
	else:
		currentPointIdx = currentPointIdx + 1
		pxlsAlreadyTraveled = 0
		percentToTarget = 0.0
func subtract_health(value: int) -> void:
	grandmaHealth = max(0, grandmaHealth - value)
	if grandmaHealth == 0:
		grandmaIsDead.emit()
		queue_free()
