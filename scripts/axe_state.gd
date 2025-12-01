# axe_state.gd
extends Resource
class_name AxeState

@export var head_material: HeadMaterial = HeadMaterial.BRONZE
@export var handle_material: HandleMaterial = HandleMaterial.PINE
@export var trim_level: Trim = Trim.NONE
@export var grip_level: Grip = Grip.NONE
@export var gem_level: Gem = Gem.NONE

# future stuff
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

enum Trim {
	NONE,
	SHINY,
	SILVER,
}

enum Grip {
	NONE,
	LEATHER,
	RUBBER,
}

enum Gem {
	NONE,
	SAPPHIRE,
	EMERALD,
	RUBY,
	DIAMOND,
}
