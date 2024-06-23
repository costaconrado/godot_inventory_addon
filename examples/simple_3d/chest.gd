extends StaticBody3D

signal toggle_inventory(external_inventory_owner)

@onready var inventory: Inventory = $inventory


func player_interact() -> void:
	inventory.toggle_inventory.emit(self)
