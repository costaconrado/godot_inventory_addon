extends CharacterBody3D

@export var inventory_data: InventoryData

signal toggle_inventory()

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera: Camera3D = $camera3d
@onready var interact_ray: RayCast3D = $camera3d/interact_ray

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
 

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/4, PI/4)
 
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if Input.is_action_just_pressed("interact"):
		interact()

	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()

func get_drop_position() -> Vector3:
	var direction = -camera.global_transform.basis.z

	return camera.global_position + direction