# Written by Lizzy Jamie in collaboration with Scott and Will Kersh
extends CharacterBody2D

# percentToTarget: This float variable is the calculating factor for the percentage 
# that should be multiplied by the delta for the grandma sprite to move from point a
# to point b
var percentToTarget = 0.0
# currentPointIdx: This integervariable gets the current child in the list of children that
# invis has
var currentPointIdx = 0
# pxlsAlreadyTraveled: This integer variable updates as the delta is multiplied by the
# percentToTarget variable in order to calculate the position of the next sprite for 
# the enemy to navigate to
var pxlsAlreadyTraveled = 0
# speed: This float variable controls the overall speed of the enemy or enemies
var speed = 300.0
# distance: This integer variable calculates the difference between the current point
# of the enemy sprite and the next point of the enemy sprite
var distance = 0
# targetPoint: This integer variable is the position of the next invisible target sprite
# that the enemy will move towards
var targetPoint = 0
# grandmaHealth: This integer variable is the enemy's total health
var grandmaHealth = 100
# grandmaReachedEnd: This signal will emit when the enemy sprite reaches the end of 
# the map aka the enemy wins and the player loses
signal grandmaReachedEnd
# grandmaIsDead: This signal will emit when the enemy's health is taken down to 0 aka
# the enemy loses
signal grandmaIsDead

# _physics_process: This function will get delta as a parameter and will calculate
# the path of the enemy as well as the distance between each invisible sprite
func _physics_process(delta):
	# invis: This object variable will get the node called NavigationPoints which hold
	# all invisible sprites indicating the enemy's path and when the enemy should turn
	var invis = get_node("/root/Main/Map/NavigationPoints")
	# currentPoint: This integer variable will hold the position of the current sprite
	# that the enemy is passing and will be updated when the enemy rounds a corner
	var currentPoint = invis.get_child(currentPointIdx)
	# This logic is built to determine if there are any more invisible sprites for the
	# enemy to detect
	if (currentPointIdx + 1) <= (invis.get_child_count() - 1):
		# If there are more invisible sprites to detect, update the targetPoint with
		# the next invisible sprite and update the distance with the position to the
		# next point
		targetPoint = invis.get_child(currentPointIdx + 1)
		distance = targetPoint.position.distance_to(currentPoint.position)
	else:
		# If there aren't any more invisible nodes to detect, the enemy has reached the
		# end of the path and therefore the player loses
		grandmaReachedEnd.emit()
		return -1
	
	# This logic is built to determine if the next invisible sprite has been reached
	if percentToTarget <= 1:
		# If it has, calculate the amount of pixels that the enemy has traveled, the
		# percent that the enemy still has left to go to the invisible sprite, 
		# and the position of the enemy that will be updated based on the map
		pxlsAlreadyTraveled += delta * speed
		percentToTarget = pxlsAlreadyTraveled/distance
		position = currentPoint.position.lerp(targetPoint.position, percentToTarget) * 2
	else:
		# If it has not, update the currentPointIdx by 1, reset the pxlsAlreadyTraveled
		# and the percentToTarget
		currentPointIdx = currentPointIdx + 1
		pxlsAlreadyTraveled = 0
		percentToTarget = 0.0
# subtract_health: This function will take in the parameter value and output void
func subtract_health(value: int) -> void:
	# grandmaHealth will be decreased by the value (implying that the enemy has been hit)
	grandmaHealth = max(0, grandmaHealth - value)
	# This logic is built to signal if the enemy has died
	if grandmaHealth == 0:
		grandmaIsDead.emit()
		queue_free()
