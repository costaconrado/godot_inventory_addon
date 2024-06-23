extends RigidBody3D

@export var slot_data: SlotData

@onready var sprite3d: Sprite3D = $sprite3d
@onready var quantity: Label3D = $quantity

func _ready() -> void:
	sprite3d.texture = slot_data.item_data.texture
	update_label()


func _physics_process(delta) -> void:
	sprite3d.rotate_y(delta)


func _on_area_3d_body_entered(body: Node3D):
	var inventories = InventoryRegistry.get_inventories(body)
	if inventories:
		slot_data = inventories[0].pick_up_slot_data(slot_data)
		if not slot_data:
			queue_free()
		else:
			update_label()


func update_label() -> void:
	quantity.text = "%sx" % slot_data.quantity
	if slot_data.quantity > 1:
		quantity.show()
	else:
		quantity.hide()
