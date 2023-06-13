extends Node3D

func _on_toggle_passthrough_button_pressed():
	$Avatar.passthrough = !$Avatar.passthrough
