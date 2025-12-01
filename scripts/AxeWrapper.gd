extends Node2D 


@export var axe_state: AxeState
@export var head_sprite: Sprite2D

@export var head_color_bronze: Color = Color8(205, 127, 50)
@export var head_color_iron: Color = Color8(210, 210, 220)
@export var head_color_steel:  Color = Color8(180, 190, 200)

func _ready() -> void:
	if axe_state == null:
		axe_state = AxeState.new()
	_apply_visuals_from_state()

func _apply_visuals_from_state() -> void:
	_apply_head_color()

func _apply_head_color() -> void:
	var target_color: Color

	match axe_state.head_material:
		AxeState.HeadMaterial.BRONZE:
			target_color = head_color_bronze
		AxeState.HeadMaterial.IRON:
			target_color = head_color_iron
		AxeState.HeadMaterial.STEEL:
			target_color = head_color_steel
		_:
			target_color = Color.WHITE

	head_sprite.self_modulate = target_color
