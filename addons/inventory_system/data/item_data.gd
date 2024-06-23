extends Resource
class_name ItemData

enum ItemQuantity {SINGLE, HALF, TOTAL}

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var texture: AtlasTexture

func use(target) -> void:
	pass
