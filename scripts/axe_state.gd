# axe_state.gd
extends Resource
class_name AxeState

@export var head_material: HeadMaterial = HeadMaterial.BRONZE
@export var handle_material: HandleMaterial = HandleMaterial.PINE

# future stuff
@export var trim_level: int = 0
@export var grip_level: int = 0
@export var gem_level: int = 0
@export var age: int = 0

enum HeadMaterial {
	BRONZE,
	IRON,
	STEEL,
}

enum HandleMaterial {
	PINE,
	BIRCH,
	OAK,
}
