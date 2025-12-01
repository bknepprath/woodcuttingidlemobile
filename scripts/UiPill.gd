@tool
class_name UiPill
extends PanelContainer

@onready var title_label: Label = $HBox/TitleLabel
@onready var value_label: Label = $HBox/ValueLabel
@onready var icon_rect: TextureRect = $HBox/Icon

@export var title: String = "Preview":
	set(new_title):
		title = new_title
		if is_inside_tree():
			title_label.text = title

@export var value: int = 0:
	set(v):
		value = v
		if is_inside_tree():
			_update_value_text()

# NEW: optional suffix, e.g. "XP"
@export var suffix: String = "":
	set(s):
		suffix = s
		if is_inside_tree():
			_update_value_text()

func _ready() -> void:
	title_label.text = title
	_update_value_text()

func _update_value_text() -> void:
	if suffix == "":
		value_label.text = str(value)
	else:
		value_label.text = "%d %s" % [value, suffix]

func set_value(v: int) -> void:
	value = v
	if is_inside_tree():
		_update_value_text()
