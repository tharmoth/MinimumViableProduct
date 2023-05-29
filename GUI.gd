extends Control

var selectedObject = null :
	get:
		return selectedObject
	set(value):
		print(value)
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
		selectedObject = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print("control ready")
	
	selectedObject = null
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
