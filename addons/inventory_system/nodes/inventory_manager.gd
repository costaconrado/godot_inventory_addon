extends CanvasLayer
class_name InventoryManager

@export var player: Node
var player_inventory: Inventory

signal inventory_visibility_changed(is_visible: bool)
signal drop_slot_data(slot_data: SlotData)

var interface: InventoryInterface

func _ready() -> void:
	var interface_scene = preload("res://addons/inventory_system/themes/default/inventory_interface.tscn")
	interface = interface_scene.instantiate()
	interface._player = player
	add_child(interface)
	interface.drop_slot_data.connect(proxy_drop_slot_data)
	
	InventoryRegistry.register_manager(self)


func toggle_inventory_interface(external_inventory_owner = null) -> void:
	interface.visible = not interface.visible

	if external_inventory_owner and interface.visible:
		interface.set_external_inventory(external_inventory_owner)
	else:
		interface.clear_external_inventory()


func proxy_drop_slot_data(slot_data: SlotData):
	drop_slot_data.emit(slot_data)
