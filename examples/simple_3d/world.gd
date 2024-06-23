extends Node

const pick_up = preload("res://items/pick_up.tscn")

@onready var player: CharacterBody3D = $player
@onready var inventory_manager = $ui/inventory_manager

func _ready() -> void:
	if inventory_manager.interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func on_inventory_visibility_changed(is_visible: bool):
	if is_visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_manager.interface.visible = not inventory_manager.interface.visible

	if inventory_manager.interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if external_inventory_owner and inventory_manager.interface.visible:
		inventory_manager.interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_manager.interface.clear_external_inventory()


func _on_inventory_manager_drop_slot_data(slot_data: SlotData):
	var pick_up_instance = pick_up.instantiate()
	pick_up_instance.slot_data = slot_data
	pick_up_instance.position = player.get_drop_position()
	add_child(pick_up_instance)
