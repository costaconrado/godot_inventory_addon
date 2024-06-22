@tool
extends CanvasLayer
class_name InventoryManager

signal drop_slot_data(slot_data: SlotData)

var interface

func _ready() -> void:
	var interface_scene = preload("res://addons/inventory_system/themes/default/inventory_interface.tscn")
	interface = interface_scene.instantiate()
	add_child(interface)
	interface.drop_slot_data.connect(proxy_drop_slot_data)

func proxy_drop_slot_data(slot_data: SlotData):
	drop_slot_data.emit(slot_data)