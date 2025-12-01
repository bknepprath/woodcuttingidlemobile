# axe_state.gd
extends Resource
class_name AxeState

enum HeadMaterial {
	BRONZE,
	IRON,
	STEEL,
}

@export var head_material: HeadMaterial = HeadMaterial.BRONZE

# future stuff
@export var trim_level: int = 0
@export var handle_level: int = 0
@export var grip_level: int = 0
@export var gem_level: int = 0
@export var age: int = 0
