extends RayCast3D

@export var show_ray : bool = true:
	set(value):
		show_ray = value
		if is_inside_tree():
			$RayMesh.visible = show_ray

var colliding_with : CollisionObject3D

func on_button_pressed():
	if colliding_with and colliding_with.has_method("on_pointer_pressed"):
		colliding_with.on_pointer_pressed(self)

func on_button_released():
	if colliding_with and colliding_with.has_method("on_pointer_released"):
		colliding_with.on_pointer_released(self)

func _ready():
	$RayMesh.visible = show_ray

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_with : CollisionObject3D
	if is_colliding():
		$Target.transform.origin = get_collision_point()
		$Target.visible = true

		new_with = get_collider()
	else:
		$Target.visible = false

	# Check current colliding with
	if colliding_with:
		if colliding_with == new_with:
			# Unchanged
			return

		if colliding_with.has_method("on_pointer_exited"):
			colliding_with.on_pointer_exited(self)

	# and use new colliding with
	colliding_with = new_with
	if colliding_with:
		if colliding_with.has_method("on_pointer_entered"):
			colliding_with.on_pointer_entered(self)
