class_name UiXPBar
extends PanelContainer

@onready var bar: ProgressBar = $WoodcutLVLBar

func set_ratio(ratio: float) -> void:
	ratio = clamp(ratio, 0.0, 1.0)
	bar.value = ratio * bar.max_value
