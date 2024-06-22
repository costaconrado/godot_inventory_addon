extends Resource
class_name InventoryData

@export var slot_datas: Array[SlotData]

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)


func drop_slot_data(grabbed_slot_data: SlotData, index: int, quantity_type: SlotData.QuantityType) -> SlotData:
	var slot_data: SlotData = slot_datas[index]
	var return_slot_data: SlotData
	var merge_quantity: int = -1
	
	if not slot_data:
		# adding to empty slot
		slot_datas[index] = grabbed_slot_data.create_slot_data(quantity_type)
		if grabbed_slot_data.quantity > 0:
			return_slot_data = grabbed_slot_data
	else:
		var can_merge = slot_data.can_merge_with(grabbed_slot_data)
		if not can_merge:
			# if adding all grabbed to non-mergable slot, swap them
			if quantity_type == SlotData.QuantityType.TOTAL or grabbed_slot_data.quantity == 1:
				slot_datas[index] = grabbed_slot_data
				return_slot_data = slot_data
			else:
				# invalid click
				return_slot_data = grabbed_slot_data
		elif can_merge:
			grabbed_slot_data = slot_data.merge_with(grabbed_slot_data, quantity_type)
			return_slot_data = grabbed_slot_data

	inventory_updated.emit(self)
	return return_slot_data


func grab_slot_data(index: int, quantity_type: SlotData.QuantityType) -> SlotData:
	var clicked_slot_data = slot_datas[index]
	if clicked_slot_data:
		var slot_data = clicked_slot_data.create_slot_data(quantity_type)
		if clicked_slot_data.quantity <= 0:
			slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]

	if not slot_data:
		return

func pick_up_slot_data(slot_data: SlotData) -> SlotData:
	var is_stackable = slot_data.item_data.stackable
	var initial_quantity = slot_data.quantity

	if is_stackable:
		for index in slot_datas.size():
			if slot_datas[index]:
				slot_data = slot_datas[index].merge_with(slot_data, SlotData.QuantityType.TOTAL)
				if not slot_data:
					inventory_updated.emit(self)
					return null
	
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return null

	if initial_quantity != slot_data.quantity:
		inventory_updated.emit(self)
	return slot_data

func on_slot_double_clicked(index: int, button: int) -> void:
	print("make it double")

func on_slot_clicked(index: int, button: int) -> void:
	print("prepare for trouble")
	inventory_interact.emit(self, index, button)
