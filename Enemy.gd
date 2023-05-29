extends CharacterBody2D

var percentToTarget = 0.0
var currentPointIdx = 0
var pxlsAlreadyTraveled = 0
var speed = 300.0
var distance = 0
var targetPoint = 0
var health = 100

var target1 = 0.0
var target2 = 0.0
var target3 = 0.0
var target4 = 0.0
var target5 = 0.0
var target6 = 0.0

func _physics_process(delta):
<<<<<<< Updated upstream
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
=======
	if target1 <= 1:
		target1 += delta * 0.4

	var invis = get_node("/root/Main/NavigationPoints")
	var invis1 = invis.get_child(0)
	var invis2 = invis.get_child(1)
	var invis3 = invis.get_child(2)
	var invis4 = invis.get_child(3)
	var invis5 = invis.get_child(4)
	var invis6 = invis.get_child(5)
	
	$EnemySprite.position = invis1.position.lerp(invis2.position, target1)
	
	if $EnemySprite.position == invis2.position:
		if target2 <= 1:
			target2 += delta * 0.9
		$EnemySprite.position = invis2.position.lerp(invis3.position, target2)
	if $EnemySprite.position == invis3.position:
		if target3 <= 1:
			target3 += 2 * delta * 0.4
		$EnemySprite.position = invis3.position.lerp(invis4.position, target3)
	if $EnemySprite.position == invis4.position:
		if target4 <= 1:
			target4 += delta * 0.9
		$EnemySprite.position = invis4.position.lerp(invis5.position, target4)
	if $EnemySprite.position == invis5.position:
		if target5 <= 1:
			target5 += delta * 0.4
		$EnemySprite.position = invis5.position.lerp(invis6.position, target5)
>>>>>>> Stashed changes
