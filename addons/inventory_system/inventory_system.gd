@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("InventoryManager", "CanvasLayer", preload("nodes/inventory_manager.gd"), preload("res://icon.svg"))
	add_custom_type("Inventory", "PanelContainer", preload("nodes/inventory.gd"), preload("res://icon.svg"))
	add_autoload_singleton("InventoryRegistry", "inventory_registry.gd")


func _exit_tree():
	remove_custom_type("InventoryManager")


func set_default(key, value):
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting("Inventory System/%s" % key, value)
