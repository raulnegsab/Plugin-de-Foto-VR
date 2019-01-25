extends ARVROrigin

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	#var arvr_interface = ARVRServer.find_interface("Native mobile")
	var arvr_interface = ARVRServer.find_interface("OpenVR")
	if(arvr_interface and arvr_interface.initialize()):
		get_viewport().arvr = true
		get_viewport().hdr = false
		
	
