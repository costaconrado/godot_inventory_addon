extends Control

signal drop_slot_data(slot_data: SlotData)

@export_subgroup("Grabbed Item")
@export var grabbed_slot_mouse_offset: Vector2 = Vector2(5, 5)
@export var grabbed_slot_transparency: Color = Color(1, 1, 1, 0.7)

var grabbed_slot_data: SlotData
var external_inventory_owner
var inventory_data

@onready var player_inventory: PanelContainer = $player_inventory
@onready var external_inventory: PanelContainer = $external_inventory
@onready var grabbed_slot: PanelContainer = $grabbed_slot


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	gui_input.connect(_on_gui_input)


func _physics_process(_delta) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + grabbed_slot_mouse_offset


func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.global_position = get_global_mouse_position() + grabbed_slot_mouse_offset
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()


func set_player_inventory_data(_inventory_data: InventoryData) -> void:
	_inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(_inventory_data)
	inventory_data = _inventory_data


func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)

	external_inventory.show()


func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)
		
		external_inventory.hide()
		external_inventory_owner = null


func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	var quantity_type = SlotData.QuantityType.SINGLE

	if Input.is_key_pressed(KEY_SHIFT):
		quantity_type = SlotData.QuantityType.HALF
	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index, SlotData.QuantityType.TOTAL)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index, SlotData.QuantityType.TOTAL)
		[null, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index, quantity_type)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index, quantity_type)

	update_grabbed_slot()


func _on_gui_input(event:InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and grabbed_slot_data:
		var quantity_type = SlotData.QuantityType.SINGLE

		if Input.is_key_pressed(KEY_SHIFT):
			quantity_type = SlotData.QuantityType.HALF
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				print(grabbed_slot_data.item_data.name)
				drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				var dropped_slot_data = grabbed_slot_data.create_slot_data(quantity_type)
				if grabbed_slot_data.quantity <= 0:
					grabbed_slot_data = null
				drop_slot_data.emit(dropped_slot_data)
		update_grabbed_slot()


func _on_visibility_changed():
	if not visible and grabbed_slot_data:
		var dropped_slot_data = inventory_data.pick_up_slot_data(grabbed_slot_data)
		if dropped_slot_data:
			drop_slot_data.emit(dropped_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
