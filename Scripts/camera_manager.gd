extends Node
@onready var  selected_camera = %Camera3D

@onready var focus = %Terrain.focus

var can_zoom = true

func _ready() -> void:
	update_camera_position()

func _process(delta: float) -> void:
	if Input.is_action_pressed("right"):  # Check if the left arrow is pressed
		selected_camera.h_angle -= delta * selected_camera.speed # Move counterclockwise (adjust this value for speed)
		update_camera_position()
	if Input.is_action_pressed("left"):  # Check if the left arrow is pressed
		selected_camera.h_angle += delta * selected_camera.speed  # Move counterclockwise (adjust this value for speed)
		update_camera_position()
	if Input.is_action_pressed("up") :
		selected_camera.v_angle =   clampf(selected_camera.v_angle + delta * selected_camera.speed,deg_to_rad(0),deg_to_rad(89))
		update_camera_position()
	if Input.is_action_pressed("down") :
		selected_camera.v_angle = clampf(selected_camera.v_angle - delta * selected_camera.speed,deg_to_rad(0),deg_to_rad(89))
		update_camera_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed and can_zoom:
			selected_camera.radius = clamp(selected_camera.radius + selected_camera.radius_increment,selected_camera.min_radius,selected_camera.max_radius)
			update_camera_position()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed  and can_zoom:
			selected_camera.radius = clamp(selected_camera.radius - selected_camera.radius_increment,selected_camera.min_radius,selected_camera.max_radius)
			update_camera_position()






# Function to update the camera position based on both angles
func update_camera_position():
	# Calculate the new position based on both horizontal and vertical angles
	var x = cos(selected_camera.h_angle) * cos(selected_camera.v_angle) * selected_camera.radius
	var y = sin(selected_camera.v_angle) * selected_camera.radius
	var z = sin(selected_camera.h_angle) * cos(selected_camera.v_angle) * selected_camera.radius

	# Set the new position
	selected_camera.position = focus.global_position + Vector3(x, y, z)
	
	# Make the camera face the focus
	selected_camera.look_at(focus.global_position)
