extends Node

@onready var _inventories = {}
var inventory_manager: InventoryManager


func register(inventory: Inventory):
	var parent_id = inventory.get_parent().get_instance_id()

	if not _inventories.has(parent_id):
		_inventories[parent_id] = {}
	_inventories[parent_id][inventory.get_instance_id()] = inventory

	if inventory_manager:
		inventory.toggle_inventory.connect(inventory_manager.toggle_inventory_interface)


func register_manager(manager: InventoryManager):
	inventory_manager = manager
	for parent_id in _inventories.keys():
		for inventory in _inventories[parent_id].values():
			inventory.toggle_inventory.connect(inventory_manager.toggle_inventory_interface)


func unregister(inventory: Inventory):
	var parent_id = inventory.get_parent().get_instance_id()
	if _inventories.has(parent_id):
		_inventories[parent_id].erase(inventory.get_instance_id())


func get_inventories(target: Node) -> Array:
	var parent_id = target.get_instance_id()
	if _inventories.has(parent_id):
		return _inventories[parent_id].values()
	return []
