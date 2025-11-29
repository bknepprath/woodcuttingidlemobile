extends Node

func _ready() -> void:
	print("WindowManager _ready called")
	resize_window()


func resize_window() -> void:
	# Wait one frame so Godot finishes creating the window
	await get_tree().process_frame

	# Your real game resolution is 1440 x 3140
	# Your monitor height is 1440, so we scale down to fit
	var target_height := 900
	var aspect := 1440.0 / 3140.0
	var target_width := int(target_height * aspect)  # ≈ 660

	var size := Vector2i(target_width, target_height)
	print("Setting window size to: ", size)
	DisplayServer.window_set_size(size)

	# Center the window on the current screen
	var screen := DisplayServer.window_get_current_screen()
	var screen_size := DisplayServer.screen_get_size(screen)
	var pos := (screen_size - size) / 2
	print("Setting window position to: ", pos)
	DisplayServer.window_set_position(pos)
