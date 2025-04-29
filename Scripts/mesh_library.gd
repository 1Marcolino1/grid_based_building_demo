extends Node3D

@onready var selected_object = get_child(0)
var can_place=true
var colliding_object_count = 0

func _ready() -> void:
	for child in get_children() :
		if child.has_node("Area3D") :
			child.get_node("Area3D").area_entered.connect(cannot_place_now)
			child.get_node("Area3D").area_exited.connect(can_place_now)
			
func _process(_delta: float) -> void:
	if colliding_object_count > 0 :
		can_place = false
	else: 
		can_place = true
	#print("i can place : " + str(colliding_object_count))

func cannot_place_now(_area) :
	colliding_object_count += 1
	#print('entered collided')

func can_place_now(_area) :
	colliding_object_count -= 1
	#print('exited collided')

func select_object(index) :
	selected_object.visible = false
	selected_object.get_node("Area3D").monitoring = false
	colliding_object_count = 0
	selected_object = get_child(index)
	selected_object.visible = true
	selected_object.get_node("Area3D").monitoring = true
