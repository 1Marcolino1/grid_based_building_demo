extends Node

var offset = Vector3(-1,0,-1)
var hovered_tile = Vector3(0,1.363,0)
var selected_object = 0
var plane_y = 5.5

func _process(_delta: float) -> void: 
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = %Camera3D.project_ray_origin(mouse_pos)
	var ray_direction = %Camera3D.project_ray_normal(mouse_pos)
	
	
	get_hovered_tile(ray_origin,ray_direction) 
	
	if Input.is_action_just_pressed("left_click") && $"../mesh_preview".can_place :
		var grid_coords = %GridMap.local_to_map(Vector3(hovered_tile.x,plane_y,hovered_tile.z))   # convert world to cell coordinates
		if  %GridMap.get_cell_item(grid_coords) == selected_object :
			remove_object_on_tile(grid_coords)
		else :
			set_object_on_tile(grid_coords)



# Ray-plane intersection
func get_ray_plane_intersection(ray_origin: Vector3, ray_direction: Vector3, plane_y: float) -> Vector3:
	var t = (plane_y - ray_origin.y) / ray_direction.y
	if t > 0:
		return ray_origin + ray_direction * t
	return Vector3(-1, -1, -1)

# Visual snap for MeshInstance
func snap_to_grid(intersection: Vector3) -> Vector3:
	return Vector3(
		ceil(intersection.x / 2) * 2 - 1,
		plane_y + 0.01,  # fixed height
		ceil(intersection.z / 2) * 2 - 1
	)

func get_hovered_tile(ray_origin,ray_direction) :
	var intersection = get_ray_plane_intersection(ray_origin, ray_direction,plane_y)
	if intersection != Vector3(-1,-1,-1):
		hovered_tile = intersection
		$"../mesh_preview".global_position = snap_to_grid(intersection)  # visual snap
		print("Intersection snapped: ", snap_to_grid(intersection))

func set_object_on_tile(grid_coords) :
	%GridMap.set_cell_item(grid_coords,selected_object, 0)

func remove_object_on_tile(grid_coords) :
	%GridMap.set_cell_item(grid_coords,%GridMap.INVALID_CELL_ITEM, 0)
