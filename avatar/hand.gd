extends XRController3D

var trigger_is_pressed = false

func _on_input_float_changed(name, value):
	if name == "trigger":
		# trigger value changed
		if trigger_is_pressed and value < 0.4:
			# trigger released
			trigger_is_pressed = false

			$Pointer.on_button_released()
		elif !trigger_is_pressed and value > 0.6:
			# trigger pressed
			trigger_is_pressed = true

			$Pointer.on_button_pressed()
