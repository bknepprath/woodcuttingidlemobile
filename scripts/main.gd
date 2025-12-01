extends Node2D

# -------------------------------------------------------------------
# Preloads / constants
# -------------------------------------------------------------------
const COLLECT_LOG_SCENE: PackedScene = preload("res://scenes/CollectLog.tscn")

# -------------------------------------------------------------------
# State
# -------------------------------------------------------------------
var logs: int = 0
var woodcut_xp: int = 0
var woodcut_level: int = 1

# -------------------------------------------------------------------
# Utility functions
# -------------------------------------------------------------------
func format_number(n: int) -> String:
	if n < 1000:
		return str(n)

	var suffixes = ["K", "M", "B", "T", "Q"]
	var value = float(n)
	var index = -1

	while value >= 1000.0 and index < suffixes.size() - 1:
		value /= 1000.0
		index += 1

	if value >= 100:
		return "%d%s" % [int(value), suffixes[index]]
	elif value >= 10:
		return "%.1f%s" % [value, suffixes[index]]
	else:
		return "%.2f%s" % [value, suffixes[index]]

func get_level_for_xp(total_xp: int) -> int:
	var lvl := 1
	var points := 0.0
	var xp_to_next := 0

	while true:
		points += floor(lvl + 300.0 * pow(2.0, float(lvl) / 7.0))
		xp_to_next = floor(points / 4.0)

		if xp_to_next > total_xp:
			return lvl

		lvl += 1

	return lvl

func get_level_progress(total_xp: int) -> float:
	var lvl := 1
	var points := 0.0
	var xp_to_next := 0
	var prev_threshold := 0

	while true:
		points += floor(lvl + 300.0 * pow(2.0, float(lvl) / 7.0))
		xp_to_next = floor(points / 4.0)

		if xp_to_next > total_xp:
			var gained_in_level := total_xp - prev_threshold
			var needed_for_level := xp_to_next - prev_threshold
			if needed_for_level <= 0:
				return 0.0
			return clamp(
				float(gained_in_level) / float(needed_for_level),
				0.0,
				1.0
			)

		lvl += 1
		prev_threshold = xp_to_next

	# Fallback, never really reached but silences the error
	return 1.0



# -------------------------------------------------------------------
# Node references
# -------------------------------------------------------------------
@export var chop_progress: ProgressBar
@export var chop_timer: Timer
@export var woodcut_level_bar: UiXPBar

@onready var woodcut_level_pill: UiPill = $UI/UIRoot/MarginContainer/VBoxContainer/Pill_WoodcutLevel
@onready var woodcut_xp_pill: UiPill    = $UI/UIRoot/MarginContainer/VBoxContainer/Pill_WoodcutXP
@onready var woodcutter: Node2D = $World/TreePosition/EnvironmentTreePlaceholder/CharacterWoodcutterPlaceholder
@onready var log_spawn: Node2D = $World/TreePosition/EnvironmentTreePlaceholder/Point_Spawn_Log

@onready var logs_label: Label = $UI/UIRoot/UI_Logs/LogPill/LogsCenter/LogsLabel


func _ready() -> void:
	print("chop_progress =", chop_progress)
	print("chop_timer   =", chop_timer)
	update_logs()
	# If Autostart is off, uncomment the next line:
	# chop_timer.start()


func _process(delta: float) -> void:
	# If the timer isn't running, keep the bar empty
	if chop_timer == null or chop_timer.is_stopped():
		if chop_progress:
			chop_progress.value = 0.0
		return

	# Timer counts down from wait_time to 0
	var elapsed := chop_timer.wait_time - chop_timer.time_left
	if chop_progress:
		chop_progress.value = elapsed

	var ratio := elapsed / chop_timer.wait_time
	animate_woodcutter(ratio)


func animate_woodcutter(ratio: float) -> void:
	# angles in radians
	var idle_angle := 0.0
	var back_angle := -0.4
	var hit_angle := 0.4

	if ratio < 0.3333:
		# Phase 1: recover from hit to idle (1 sec)
		var t := ratio / 0.3333
		t = clamp(t, 0.0, 1.0)
		woodcutter.rotation = lerp(hit_angle, idle_angle, t)

	elif ratio < 0.6667:
		# Phase 2: hold idle (1 sec)
		woodcutter.rotation = idle_angle

	elif ratio < 0.75:
		# Phase 3: lean back (0.25 sec)
		var t := (ratio - 0.6667) / (0.75 - 0.6667)
		t = clamp(t, 0.0, 1.0)
		woodcutter.rotation = lerp(idle_angle, back_angle, t)

	elif ratio < 0.9167:
		# Phase 4: hold back (0.5 sec)
		woodcutter.rotation = back_angle

	else:
		# Phase 5: swing forward to hit (0.25 sec)
		var t := (ratio - 0.9167) / (1.0 - 0.9167)
		t = clamp(t, 0.0, 1.0)
		woodcutter.rotation = lerp(back_angle, hit_angle, t)


# -------------------------------------------------------------------
# Log handling
# -------------------------------------------------------------------
func update_logs() -> void:
	logs_label.text = format_number(logs)
	
func update_woodcut_ui() -> void:
	var lvl := get_level_for_xp(woodcut_xp)

	if woodcut_level_pill:
		woodcut_level_pill.value = lvl

	if woodcut_xp_pill:
		woodcut_xp_pill.value = woodcut_xp

	if woodcut_level_bar:
		var ratio := get_level_progress(woodcut_xp)
		woodcut_level_bar.set_ratio(ratio)


func get_xp_for_level(level: int) -> int:
	var points := 0.0
	var xp_to_next := 0

	for lvl in range(1, level):
		points += floor(lvl + 300.0 * pow(2.0, float(lvl) / 7.0))
		xp_to_next = floor(points / 4.0)

	return xp_to_next


func add_logs(amount: int = 1) -> void:
	add_xp(amount * 10)
	logs += amount
	update_logs()
	spawn_collect_logs(amount)


func spawn_collect_logs(count: int) -> void:
	for i in count:
		var fx := COLLECT_LOG_SCENE.instantiate() as Node2D
		fx.global_position = log_spawn.global_position
		get_tree().current_scene.add_child(fx)


func chop_log() -> void:
	var chance := get_chop_success_chance(woodcut_level)
	if randf() <= chance:
		add_logs(1)
	else:
		pass


func manual_chop() -> void:
	chop_log()

func add_xp(amount: int) -> void:
	woodcut_xp += amount
	var new_level := get_level_for_xp(woodcut_xp)

	if new_level > woodcut_level:
		woodcut_level = new_level
		_on_woodcut_level_up(new_level)

	update_woodcut_ui()

func _on_woodcut_level_up(new_level: int) -> void:
	print("Woodcutting level up! New level: ", new_level)

func get_chop_success_chance(level: int) -> float:
	# Exponential curve (RuneScape-like feeling):
	# base = 1 - e^(-level / 20)

	var base := 1.0 - exp(-float(level) / 20.0)

	# Now scale it so:
	# level 1 = 0.15
	# level 50 = 0.85
	# level 99+ = 1.00

	var min_val := 0.15
	var max_val := 1.0

	var scaled := min_val + base * (max_val - min_val)
	return clamp(scaled, min_val, max_val)


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------
func _on_chop_timer_timeout() -> void:
	chop_log()
	# Timer auto-restarts because One Shot is false
	# Bar will naturally go back to 0 because time_left resets


func _on_manual_chop_button_pressed() -> void:
	manual_chop()

func reset_progress() -> void:
	logs = 0
	woodcut_xp = 0
	woodcut_level = 1
	print("PROGRESSION RESET")
