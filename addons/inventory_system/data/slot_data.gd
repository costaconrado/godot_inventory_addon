extends Resource
class_name SlotData

enum QuantityType {SINGLE, HALF, TOTAL}

const MAX_STACK_SIZE: int = 99

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int  = 1: set = set_quantity


func can_merge_with(other_slot_data: SlotData) -> bool:
	return quantity < MAX_STACK_SIZE \
		and item_data.stackable \
		and other_slot_data and item_data == other_slot_data.item_data


func merge_with(other_slot_data: SlotData, type: QuantityType) -> SlotData:
	var amount = other_slot_data._calc_quantity(type)
	if not other_slot_data or item_data != other_slot_data.item_data or quantity >= MAX_STACK_SIZE:
		return other_slot_data
	
	if quantity + amount > MAX_STACK_SIZE:
		amount = amount - (quantity + amount - MAX_STACK_SIZE)
	other_slot_data.quantity -= amount
	quantity += amount

	if other_slot_data.quantity > 0:
		return other_slot_data

	return null


func create_slot_data(type: QuantityType) -> SlotData:
	var new_slot_data = duplicate()
	var amount = _calc_quantity(type)

	new_slot_data.quantity = amount
	quantity -= amount

	return new_slot_data


func set_quantity(value: int) -> void:
	quantity = value
	if quantity > 1 and not item_data.stackable:
		quantity = 1
		push_error("%s is not stackable, setting quantity to 1." % item_data.name)


func _calc_quantity(type: QuantityType) -> int:
	var amount : int
	if type == QuantityType.SINGLE:
		amount = 1
	elif type == QuantityType.HALF:
		amount = round(quantity/2)
		if quantity == 1:
			amount = 1
	else:
		amount = quantity
	return amount
