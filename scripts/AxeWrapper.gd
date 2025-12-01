extends Node2D

@export var axe_state: AxeState
@export var head_sprite: Sprite2D
@export var handle_sprite: Sprite2D

@export var head_color_bronze: Color = Color8(205, 127, 50)
@export var head_color_iron: Color = Color8(210, 210, 220)
@export var head_color_steel: Color = Color8(180, 190, 200)

@export var handle_color_pine: Color  = Color8(240, 220, 170)	# light yellow wood
@export var handle_color_birch: Color = Color8(230, 230, 210)	# pale birch
@export var handle_color_oak: Color   = Color8(150, 110, 70)	# warm mid-brown oak

func _ready() -> void:
	if axe_state == null:
		axe_state = AxeState.new()
	_apply_visuals_from_state()

func _apply_visuals_from_state() -> void:
	_apply_head_color()
	_apply_handle_color()

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

func _apply_handle_color() -> void:
	var target_color: Color

	match axe_state.handle_material:
		AxeState.HandleMaterial.PINE:
			target_color = handle_color_pine
		AxeState.HandleMaterial.BIRCH:
			target_color = handle_color_birch
		AxeState.HandleMaterial.OAK:
			target_color = handle_color_oak
		_:
			target_color = Color.WHITE

	handle_sprite.self_modulate = target_color

func can_upgrade_head() -> bool:
	return axe_state.head_material < AxeState.HeadMaterial.STEEL

func upgrade_head() -> void:
	if not can_upgrade_head():
		return

	axe_state.head_material = (axe_state.head_material + 1) as AxeState.HeadMaterial
	_apply_head_color()

func can_upgrade_handle() -> bool:
	return axe_state.handle_material < AxeState.HandleMaterial.OAK

func upgrade_handle() -> void:
	if not can_upgrade_handle():
		return

	axe_state.handle_material = (axe_state.handle_material + 1) as AxeState.HandleMaterial
	_apply_handle_color()


func _on_ugradehead_pressed() -> void:
	upgrade_head()
