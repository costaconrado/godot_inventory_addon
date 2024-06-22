@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("InventoryManager", "CanvasLayer", preload("nodes/inventory_manager.gd"), preload("res://icon.svg"))


func _exit_tree():
	remove_custom_type("InventoryManager")


func set_default(key, value):
	if not ProjectSettings.has_setting(key):
		ProjectSettings.set_setting("Inventory System/%s" % key, value)
