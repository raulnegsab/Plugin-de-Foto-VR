extends Navigation
var path = []
var begin = Vector3()
var end = Vector3()

var SPEED = 1.0

func _process(delta):
	if (path.size() > 1):
		var to_walk = delta*SPEED
		var to_watch = Vector3(0, 1, 0)
		while(to_walk > 0 and path.size() >= 2):
			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			to_watch = (pto - pfrom).normalized()
			var d = pfrom.distance_to(pto)
			if (d <= to_walk):
				path.remove(path.size() - 1)
				to_walk -= d
			else:
				path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk/d)
				to_walk = 0
		
		var atpos = path[path.size() - 1]
		var atdir = to_watch
		atdir.y = 0
		
		var t = Transform()
		t.origin = atpos
		#t=t.looking_at(atpos + atdir, Vector3(0, 1, 0))
		get_node("playerNode").set_transform(t)
		
		if (path.size() < 2):
			path = []
			set_process(false)
	else:
		set_process(false)


func _update_path():
	var p = get_simple_path(begin, end, true)
	print(begin)
	print(end)
	print(p)
	path = Array(p) # Vector3array too complex to use, convert to regular array
	path.invert()
	
	set_process(true)
	
func _ready():
	set_process_input(true)
	begin = get_closest_point(get_node("playerNode").get_translation())
	end = get_closest_point(get_node("end").get_translation())
	_update_path()
	
