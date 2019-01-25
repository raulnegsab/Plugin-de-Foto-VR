extends Spatial

var target = null

var last_collided_at = Vector3(0, 0, 0)
var laser_y = -0.05
onready var ws = ARVRServer.world_scale

var recticlePointer;
var recticleEnter;

func set_enabled(p_enabled):
	$Laser.visible = p_enabled
	$Laser/RayCast.enabled = p_enabled

func _on_button_pressed():
	if $Laser/RayCast.enabled:
		if $Laser/RayCast.is_colliding():
			target = $Laser/RayCast.get_collider()
			last_collided_at = $Laser/RayCast.get_collision_point()

			if target.get_parent().has_method("_on_pointer_pressed"):
				target.get_parent()._on_pointer_pressed(last_collided_at)

func _on_button_release():
	if target:
		# let object know button was released
		# print("Button released on " + target.get_name())
		if target.get_parent().has_method("_on_pointer_release"):
			target.get_parent()._on_pointer_release(last_collided_at)

		target = false
		last_collided_at = Vector3(0, 0, 0)



func _ready():
	# Get button press feedback from our parent (should be an ARVRController)
#	get_parent().connect("button_pressed", self, "_on_button_pressed")
#	get_parent().connect("button_release", self, "_on_button_release")

	# apply our world scale to our laser position
	$Laser.translation.y = laser_y * ws
	recticlePointer = preload("res://recticle.png")
	recticleEnter = preload("res://recticleSelection.png")

func _process(delta):
	var new_ws = ARVRServer.world_scale
	if (ws != new_ws):
		ws = new_ws
	$Laser.translation.y = laser_y * ws

	if $Laser/RayCast.enabled and $Laser/RayCast.is_colliding():
		var new_at = $Laser/RayCast.get_collision_point()
		var new_target = $Laser/RayCast.get_collider()

		if new_at == last_collided_at:
			pass
		elif target:
			# if target is set our mouse must be down, we keep sending events to our target
			if target.get_parent().has_method("_on_pointer_moved"):
				target.get_parent()._on_pointer_moved(new_at, last_collided_at)
		else:
			if new_target.get_parent().has_method("_on_pointer_moved"):
				new_target.get_parent()._on_pointer_moved(new_at, last_collided_at)
		$Laser/Reticle/Image.texture = recticleEnter
	else:
		$Laser/Reticle/Image.texture = recticlePointer

	if Input.is_action_just_pressed("mouse_left"):
		_on_button_pressed()
	if Input.is_action_just_released("mouse_left"):
		_on_button_release()
