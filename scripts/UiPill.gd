class_name UiPill
extends PanelContainer

@onready var title_label: Label = $HBox/TitleLabel
@onready var value_label: Label = $HBox/ValueLabel
@onready var icon_rect: TextureRect = $HBox/Icon

@export var title: String:
	set(new_title):
		title = new_title
		if is_node_ready():
			title_label.text = new_title

@export var value: int = 0:
	set(v):
		value = v
		if is_node_ready():
			value_label.text = str(v)

@export var icon: Texture2D:
	set(tex):
		icon = tex
		if is_node_ready():
			icon_rect.texture = tex

func _ready() -> void:
	# Make sure the visuals match whatever the exports currently are
	title_label.text = title
	value_label.text = str(value)
	icon_rect.texture = icon

func set_value(v: int) -> void:
	value = v
	if is_node_ready():
		value_label.text = str(v)
