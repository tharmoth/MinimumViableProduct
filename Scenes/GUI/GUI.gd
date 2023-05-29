extends Control

@export var Enemy: PackedScene
@export var Handgun: PackedScene
@export var Rifle: PackedScene
@export var Bazooka: PackedScene
@export var tilemap: TileMap

@onready var timeBetweenSpawns = .25

var turretDistance = 64
var waveIndex = 0
var enemysToSpawn = 0
var timeSinceSpawn = 0
var cookies = 5

var selectedObject = null :
	get:
		return selectedObject
	set(value):
		selectedObject = value
		if value != null:
			$InfoPanel.visible = true
			$InfoPanel/ColorRect/Label.text = value
			if value == "Build":
				$Buttons.visible = false
				$BuildOptions.visible = true
			if value == "Back":
				$Buttons.visible = true
				$BuildOptions.visible = false
				$InfoPanel.visible = false
		else:
			$InfoPanel.visible = false

func _on_gui_input(event):
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT && _is_valid_build_loc(event.position):
		var newTurret = null
		if selectedObject == "Standard":
			newTurret = Handgun.instantiate()
		elif selectedObject == "Advanced":
			newTurret = Rifle.instantiate()
		elif selectedObject == "Ultimate":
			newTurret = Bazooka.instantiate()
			
		if newTurret != null:
			newTurret.position = event.position
			tilemap.get_node("/root/Main/Map/Turrets").add_child(newTurret)
		
func _is_valid_build_loc(position):
	
	if selectedObject == "Standard" && cookies < 1:
		return false
	elif selectedObject == "Advanced" && cookies < 2.5:
		return false
	elif selectedObject == "Ultimate" && cookies < 5:
		return false
	
	# Make sure the tilemap is grass
	# I'm not sure why we need to scale here
	if (tilemap.get_cell_atlas_coords(0, tilemap.local_to_map(position * 2)) != Vector2i(0, 0)):
		return false
		
	for turret in tilemap.get_node("/root/Main/Map/Turrets").get_children():
		if turret.position.distance_to(position) < turretDistance:
			return false

	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	selectedObject = null
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeSinceSpawn += delta
	if (enemysToSpawn > 0 && timeSinceSpawn > timeBetweenSpawns):
		_spawnEnemy()
		enemysToSpawn -= 1
		timeSinceSpawn = 0

func _input(event):
	if event is InputEventMouseMotion and (selectedObject == "Standard" or selectedObject == "Advanced" or selectedObject == "Ultimate"):
		if _is_valid_build_loc(event.position):
			$InvalidCursor.visible = false;
			
			$ValidCursor.visible = true;
			$ValidCursor.position = event.position
		else:
			$ValidCursor.visible = false;
			
			$InvalidCursor.visible = true;
			$InvalidCursor.position = event.position
	else:
		$ValidCursor.visible = false;
		$ValidCursor.visible = false;

func _on_grandma_reached_end():
	$Lives/VBoxContainer/HealthBar.value -= 1
	print("rip")
	
func _on_grandma_death():
	cookies + .5
	$Lives/VBoxContainer/CoinsCount.text = str(cookies)

func _on_start_pressed():
	waveIndex += 1
	enemysToSpawn += waveIndex
	$TopInfo/HBoxContainer/LevelLabel.text = "On wave: " + str(waveIndex)

func _spawnEnemy():
	var newEnemy = Enemy.instantiate()
	tilemap.get_node("/root/Main/Map/Enemies").add_child(newEnemy)
	selectedObject = "Start Wave"
	newEnemy.grandmaReachedEnd.connect(_on_grandma_reached_end)
	
func _on_build_pressed():
	selectedObject = "Build"

func _on_standard_pressed():
	selectedObject = "Standard"


func _on_advanced_pressed():
	selectedObject = "Advanced"


func _on_ultimate_pressed():
	selectedObject = "Ultimate"


func _on_back_pressed():
	selectedObject = "Back"
