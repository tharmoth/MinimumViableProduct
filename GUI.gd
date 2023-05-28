extends Control

var selectedObject = null :
	get:
		return selectedObject
	set(value):
		selectedObject = value
		print("setting selected object")
		if value != null:
			$InfoPanel.visible = true
			$InfoPanel/ColorRect/Label.text = value
		else:
			$InfoPanel.visible = false

func _on_gui_input(event):
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		print("mouseclick")
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
	selectedObject = "start"


func _on_stop_pressed():
	selectedObject = "stop"
