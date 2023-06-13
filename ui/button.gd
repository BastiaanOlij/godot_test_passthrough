@tool
extends Area3D

class_name XRUI_Button

signal button_pressed

@export var text : String = "":
	set(value):
		text = value
		if is_inside_tree():
			_update_text()

var update_size : int = 2
var pointers : Array

func on_pointer_entered(pointer):
	var has_pointers = pointers.size() > 0

	# Add this pointer to this list
	if !pointers.has(pointer):
		pointers.push_back(pointer)

	# Check if any pointers are now pointing to our button
	_update_hover_over(has_pointers)

func on_pointer_exited(pointer):
	var has_pointers = pointers.size() > 0

	# Remote this pointer from the list
	if pointers.has(pointer):
		pointers.erase(pointer)

	# Check if any pointers are still pointing to our button
	_update_hover_over(has_pointers)

func on_pointer_pressed(pointer):
	# nothing to do here
	pass

func on_pointer_released(pointer):
	emit_signal("button_pressed")

func _update_hover_over(was_has_pointers):
	var has_pointers = pointers.size() > 0

	# Did it change from our previous state?
	if has_pointers != was_has_pointers:
		if has_pointers:
			# we now have a pointer over, lets play our animation
			$AnimationPlayer.play("pointer_entered")

			# add playing a sound (or add to animation)

			# add haptic pulse (or add to animation)
		else:
			$AnimationPlayer.play("pointer_exited")

func _update_text():
	$Text.text = text
	
	# Have to wait until this renders for atleast 1 frame before sizing info is available
	update_size = 2
	set_process(true)

func _update_size():
	var aabb : AABB = $Text.get_aabb()
	var mesh : BoxMesh = $Background.mesh
	if mesh:
		mesh.size = Vector3(aabb.size.x + 0.05, aabb.size.y + 0.01, 0.01)
	var shape : BoxShape3D = $CollisionShape3D.shape
	if shape:
		shape.size = Vector3(aabb.size.x + 0.05, aabb.size.y + 0.01, 0.01)

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_text()

func _process(delta):
	if update_size > 0:
		update_size = update_size - 1
		if update_size == 0:
			_update_size()
	else:
		set_process(false)
