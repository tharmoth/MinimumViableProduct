extends Control

@export var Turret: PackedScene
@export var tilemap: TileMap

var turretDistance = 64

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
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if selectedObject == "Standard" && _is_valid_build_loc(event.position):
			var newTurret = Turret.instantiate()
			print("building turret")
			newTurret.position = event.position
			tilemap.get_node("/root/Main/Map/Turrets").add_child(newTurret)
		
func _is_valid_build_loc(position):
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
	pass

func _input(event):
	if event is InputEventMouseMotion and selectedObject == "Standard":
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

func _on_start_pressed():
	selectedObject = "Start Wave"

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
