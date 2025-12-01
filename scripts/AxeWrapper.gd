extends Node2D

@export var axe_state: AxeState

@export var head_sprite: Sprite2D
@export var handle_sprite: Sprite2D
@export var trim_sprite: Sprite2D
@export var grip_color_sprite: Sprite2D
@export var grip_lineart_sprite: Sprite2D
@export var gem_color_sprite: Sprite2D
@export var gem_lineart_sprite: Sprite2D

@export var head_color_bronze: Color = Color8(205, 127, 50)
@export var head_color_iron: Color   = Color8(210, 210, 220)
@export var head_color_steel: Color  = Color8(180, 190, 200)

@export var handle_color_pine: Color  = Color8(240, 220, 170)  # light yellow wood
@export var handle_color_birch: Color = Color8(230, 230, 210)  # pale birch
@export var handle_color_oak: Color   = Color8(150, 110, 70)   # warm mid-brown oak

@export var trim_color_shiny: Color  = Color(1.0, 1.0, 1.0, 0.5)    # 50% white
@export var trim_color_silver: Color = Color8(190, 190, 200, 255)   # silver

@export var grip_color_leather: Color = Color8(140, 90, 50)         # brown
@export var grip_color_rubber: Color  = Color8(50, 50, 55)          # dark gray

@export var gem_color_sapphire: Color = Color8(30, 60, 160)         # rich blue
@export var gem_color_emerald: Color  = Color8(20, 140, 60)         # green
@export var gem_color_ruby: Color     = Color8(180, 40, 40)         # red
@export var gem_color_diamond: Color  = Color8(200, 240, 255)       # icy bright


func _ready() -> void:
	if axe_state == null:
		axe_state = AxeState.new()
	_apply_visuals_from_state()


func _apply_visuals_from_state() -> void:
	_apply_head_color()
	_apply_handle_color()
	_apply_trim_color()
	_apply_grip_color()
	_apply_gem_color()


func _apply_head_color() -> void:
	if head_sprite == null:
		return

	var target_color: Color

	match axe_state.head_material:
		AxeState.HeadMaterial.BRONZE:
			target_color = head_color_bronze
		AxeState.HeadMaterial.IRON:
			target_color = head_color_iron
		AxeState.HeadMaterial.STEEL:
			target_color = head_color_steel
		_:
			target_color = Color(1, 1, 1, 1)

	head_sprite.self_modulate = target_color


func _apply_handle_color() -> void:
	if handle_sprite == null:
		return

	var target_color: Color

	match axe_state.handle_material:
		AxeState.HandleMaterial.PINE:
			target_color = handle_color_pine
		AxeState.HandleMaterial.BIRCH:
			target_color = handle_color_birch
		AxeState.HandleMaterial.OAK:
			target_color = handle_color_oak
		_:
			target_color = Color(1, 1, 1, 1)

	handle_sprite.self_modulate = target_color


func _apply_trim_color() -> void:
	if trim_sprite == null:
		return

	match axe_state.trim_level:
		AxeState.Trim.NONE:
			trim_sprite.self_modulate = Color(1, 1, 1, 0)        # fully transparent
		AxeState.Trim.SHINY:
			trim_sprite.self_modulate = trim_color_shiny         # 50% white
		AxeState.Trim.SILVER:
			trim_sprite.self_modulate = trim_color_silver        # silver


func _apply_grip_color() -> void:
	if grip_color_sprite == null or grip_lineart_sprite == null:
		return

	match axe_state.grip_level:
		AxeState.Grip.NONE:
			# both sprites fully transparent
			grip_color_sprite.self_modulate   = Color(1, 1, 1, 0)
			grip_lineart_sprite.self_modulate = Color(1, 1, 1, 0)

		AxeState.Grip.LEATHER:
			# color visible + lineart fully opaque
			grip_color_sprite.self_modulate   = grip_color_leather
			grip_lineart_sprite.self_modulate = Color(1, 1, 1, 1)

		AxeState.Grip.RUBBER:
			grip_color_sprite.self_modulate   = grip_color_rubber
			grip_lineart_sprite.self_modulate = Color(1, 1, 1, 1)


func _apply_gem_color() -> void:
	if gem_color_sprite == null or gem_lineart_sprite == null:
		return

	match axe_state.gem_level:
		AxeState.Gem.NONE:
			# fully transparent color + lineart
			gem_color_sprite.self_modulate   = Color(1, 1, 1, 0)
			gem_lineart_sprite.self_modulate = Color(1, 1, 1, 0)

		AxeState.Gem.SAPPHIRE:
			gem_color_sprite.self_modulate   = gem_color_sapphire
			gem_lineart_sprite.self_modulate = Color(1, 1, 1, 1)

		AxeState.Gem.EMERALD:
			gem_color_sprite.self_modulate   = gem_color_emerald
			gem_lineart_sprite.self_modulate = Color(1, 1, 1, 1)

		AxeState.Gem.RUBY:
			gem_color_sprite.self_modulate   = gem_color_ruby
			gem_lineart_sprite.self_modulate = Color(1, 1, 1, 1)

		AxeState.Gem.DIAMOND:
			gem_color_sprite.self_modulate   = gem_color_diamond
			gem_lineart_sprite.self_modulate = Color(1, 1, 1, 1)


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


func can_upgrade_trim() -> bool:
	return axe_state.trim_level < AxeState.Trim.SILVER


func upgrade_trim() -> void:
	if not can_upgrade_trim():
		return
	axe_state.trim_level = (axe_state.trim_level + 1) as AxeState.Trim
	_apply_trim_color()


func can_upgrade_grip() -> bool:
	return axe_state.grip_level < AxeState.Grip.RUBBER


func upgrade_grip() -> void:
	if not can_upgrade_grip():
		return
	axe_state.grip_level = (axe_state.grip_level + 1) as AxeState.Grip
	_apply_grip_color()


func can_upgrade_gem() -> bool:
	return axe_state.gem_level < AxeState.Gem.DIAMOND


func upgrade_gem() -> void:
	if not can_upgrade_gem():
		return
	axe_state.gem_level = (axe_state.gem_level + 1) as AxeState.Gem
	_apply_gem_color()


func _on_upgradehead_pressed() -> void:
	print("HEAD BUTTON PRESSED")
	upgrade_head()


func _on_upgradehandle_pressed() -> void:
	upgrade_handle()


func _on_upgradetrim_pressed() -> void:
	upgrade_trim()


func _on_upgradegrip_pressed() -> void:
	upgrade_grip()


func _on_upgradegem_pressed() -> void:
	upgrade_gem()

func reset_game() -> void:
	axe_state.head_material = AxeState.HeadMaterial.BRONZE
	axe_state.handle_material = AxeState.HandleMaterial.PINE
	axe_state.trim_level = AxeState.Trim.NONE
	axe_state.grip_level = AxeState.Grip.NONE
	axe_state.gem_level = AxeState.Gem.NONE

	_apply_visuals_from_state()

	print("GAME RESET")


func _on_resetbutton_pressed() -> void:
	reset_game()
	var main := get_node("/root/Main")
	if main:
		main.reset_progress()
