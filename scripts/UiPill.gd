extends PanelContainer

@export var title: String:
	set(value):
		title = value
		%TitleLabel.text = value

@export var value: int = 0:
	set(v):
		value = v
		%ValueLabel.text = str(v)

@export var icon: Texture2D:
	set(tex):
		icon = tex
		%Icon.texture = tex

func set_value(v: int):
	value = v
	%ValueLabel.text = str(v)
