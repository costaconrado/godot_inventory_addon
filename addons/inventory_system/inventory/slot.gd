extends PanelContainer

@onready var texture_rect: TextureRect = %texture
@onready var quantity: RichTextLabel = %quantity
@onready var double_click_timer: Timer = %double_click_timer

signal slot_clicked(index: int, button: int)
signal slot_double_clicked(index: int, button: int)

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]

	quantity.text = "x%s" % slot_data.quantity
	if slot_data.quantity > 1:
		quantity.show()
	else:
		quantity.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT \
		or event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_double_click():
			_clear_timer()
			slot_double_clicked.emit(get_index(), event.button_index)
	elif event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT \
		or event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_pressed():
			_clear_timer()
			double_click_timer.start()
			var send_click = func(): slot_clicked.emit(get_index(), event.button_index)
			double_click_timer.timeout.connect(send_click)

func _clear_timer() -> void:
	var connections = double_click_timer.timeout.get_connections()
	
	for connection in connections:
		double_click_timer.timeout.disconnect(connection.callable)