extends Button

@export var building_scene:PackedScene


func change_selected_building() :
	get_tree().get_root().get_node("Main/grid_system").BuildingScene = building_scene
	get_tree().get_root().get_node("Main/grid_system").building_index = get_index()
	get_tree().get_root().get_node("Main/mesh_preview").select_object( get_index())
	print("selected_object is " + str(get_index()))

func disable_placement() :
	get_tree().get_root().get_node("Main/grid_system").disable_building = true
	get_tree().get_root().get_node("Main/camera_manager").can_zoom = false
func enable_placement() :
	get_tree().get_root().get_node("Main/grid_system").disable_building = false
	get_tree().get_root().get_node("Main/camera_manager").can_zoom = true
