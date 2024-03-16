extends Control

var area_data = {}
var menu_slots = []
var color_rect
var menu_container

func _ready():
	color_rect = _create_menu_background()
	menu_container = _map_subareas(color_rect)
	self.visible = false
	await get_tree().create_timer(.1).timeout #needed to allow for menu_container to finish filling before resize
	#resize_background(color_rect,menu_container.size)
	
func _map_subareas(color_rect):
	var menu_container = HFlowContainer.new()
	menu_container.SIZE_EXPAND_FILL
	#menu_container.set_columns(3)
	menu_container.name = "area_menu_container"
	color_rect.add_child(menu_container)
	for i in range(24):
		print(i)
		var menu_slot = Container.new()
		menu_slot.name = str(i)
		menu_slot.set_meta("type","slot")
		menu_slots.append(menu_slot)
		menu_container.add_child(menu_slot)
	#add menu title
	var label = Label.new()
	label.text = "AREA MENU"
	label.name = "area_menu_label"
	label.vertical_alignment=VERTICAL_ALIGNMENT_TOP
	label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	get_node(str(menu_container.get_path())+"/1").add_child(label)
			
	return menu_container

func _create_menu_background():
	var color_rect = ColorRect.new()
	color_rect.color = Color(0, 0, 0)  # Set background color
	color_rect.size = Vector2(400, 400)
	color_rect.name = "area_menu_background"
	add_child(color_rect)
	return color_rect

func add_menu_item(container, subarea):
	# Create a Label for the menu item
		var label = Label.new()
		label.text = subarea.name
		label.name = subarea.name + "_label"
		get_node(str(menu_container.get_path())+"/"+str(3*subarea.position + 1)).add_child(label)
	
func resize_background(color_rect,box_container_size):
	color_rect.size = box_container_size
	
func clear_menu():
	for slot in menu_slots:
		if slot.get_child_count() != 0:
			var menu_item = slot.get_child(0)
			if menu_item.name != "area_menu_label":
				print(menu_item.name)
				menu_item.queue_free()
	
func update_menu(area_data):
	clear_menu()
	get_node(str(menu_container.get_path())+"/1/area_menu_label").text = "AREA: " + area_data.name
	#add items
	if area_data.subareas.size() != 0:
		for subarea in area_data.subareas:
			add_menu_item(menu_container, subarea)
