extends XROrigin3D

var xr_interface : OpenXRInterface

@export var passthrough : bool = false:
	set(value):
		passthrough = value
		if xr_interface and xr_interface.is_initialized():
			if passthrough:
				_start_passthrough()
			else:
				_stop_passthrough()

var passthrough_is_running : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		var vp : Viewport = get_viewport()
		
		vp.use_xr = true

		if !xr_interface.is_passthrough_supported():
			print("WARNING: passthrough not supported")
		
		if passthrough:
			_start_passthrough()

func _start_passthrough():
	if xr_interface && xr_interface.is_passthrough_supported() && !passthrough_is_running:
		get_viewport().transparent_bg = true
		if xr_interface.start_passthrough():
			print("started passthrough")
			passthrough_is_running = true
		else:
			print("failed to start passthrough")

func _stop_passthrough():
	if xr_interface && xr_interface.is_passthrough_supported() && passthrough_is_running:
		xr_interface.stop_passthrough()
		print("stopped passthrough")
		get_viewport().transparent_bg = false
		passthrough_is_running = false

