extends Spatial


#Variables
var i = 0;
var speed = 100
var direction = Vector3()
var gravity = -9.8
var velocity = Vector3()
var photo = Array()
var camera_angle = 0
var mouse_sensitivity = 0.3
var camera_change = Vector2()
#var proyectDataDir = OS.get_system_dir(2) + "/TesinaVR"
var proyectDataDir = "user://TesinaVR"

#Program Start
func _ready():
	set_process_input(true)
	photo = list_files_in_directory(proyectDataDir)
	pass

##Codigo para tomar y guardar las fotos tomadas
func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		i = i + 1
		if i == 21:
			i = 1
		get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		var capture = get_viewport().get_texture().get_data()
		#capture.flip_y()
#		var time = OS.get_datetime()
#		var dir = Directory.new()
#		dir.open(proyectDataDir)
#		if !dir.dir_exists(proyectDataDir):
#			dir.make_dir(proyectDataDir)
#		var imagePath = proyectDataDir + "/TesinaVR_" + String(time["day"]) + "-" + String(time["month"]) + "-" + String(time["year"]) + "_" + String(time["hour"]) + "-" + String(time["minute"]) + "-" + String(time["second"]) + ".png"
#		photo.append(imagePath)
#		capture.save_png(imagePath)
		
#		var image = Image.new()
#		image.load(imagePath)
		
		var material = get_node("Photoshow" + String(i)).get_surface_material(0)
		var new_material = ImageTexture.new()
		new_material.create_from_image(capture)
	
		material.albedo_texture = new_material
	if event is InputEventMouseMotion:
		if(event.button_mask&(BUTTON_MASK_MIDDLE+BUTTON_MASK_RIGHT)):
			camera_change = event.relative
			if camera_change.length() > 0:
				$Navigation/playerNode/KinematicBody.rotate_y(-deg2rad(camera_change.x * mouse_sensitivity))
				var change = -camera_change.y * mouse_sensitivity
				if change + camera_angle < 90 and change + camera_angle > -90:
					$Navigation/playerNode/KinematicBody/MainPlayer.rotate_x(deg2rad(change))
					camera_angle += change
					camera_change = Vector2()
	pass
	
func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            files.append(path + "/" + file)

    dir.list_dir_end()

    return files
	

