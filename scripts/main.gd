extends Node2D

# -------------------------------------------------------------------
# Preloads / constants
# -------------------------------------------------------------------
const COLLECT_LOG_SCENE: PackedScene = preload("res://scenes/CollectLog.tscn")

# -------------------------------------------------------------------
# State
# -------------------------------------------------------------------
var logs: int = 0

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


# -------------------------------------------------------------------
# Node references
# -------------------------------------------------------------------
@onready var logs_label: Label = $UI/UIRoot/UI_Logs/LogPill/LogsCenter/LogsLabel
@onready var chop_progress: ProgressBar = $ChopProgress
@onready var chop_timer: Timer = $ChopTimer
@onready var woodcutter: Node2D = $World/ActionPoint/EnvironmentTreePlaceholder/CharacterWoodcutterPlaceholder
@onready var log_spawn: Node2D = $World/ActionPoint/EnvironmentTreePlaceholder/Point_Spawn_Log


func _ready() -> void:
	update_logs()
	# If Autostart is off, uncomment the next line:
	# chop_timer.start()


func _process(delta: float) -> void:
	# If the timer isn't running, keep the bar empty
	if chop_timer.is_stopped():
		chop_progress.value = 0.0
		return

	# Timer counts down from wait_time to 0
	# We want "time elapsed" from 0 to wait_time
	var elapsed := chop_timer.wait_time - chop_timer.time_left
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


func add_logs(amount: int = 1) -> void:
	logs += amount
	update_logs()
	spawn_collect_logs(amount)


func spawn_collect_logs(count: int) -> void:
	for i in count:
		var fx := COLLECT_LOG_SCENE.instantiate() as Node2D
		fx.global_position = log_spawn.global_position
		get_tree().current_scene.add_child(fx)


func chop_log() -> void:
	add_logs(1)


func manual_chop() -> void:
	add_logs(1)


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------
func _on_chop_timer_timeout() -> void:
	chop_log()
	# Timer auto-restarts because One Shot is false
	# Bar will naturally go back to 0 because time_left resets


func _on_manual_chop_button_pressed() -> void:
	manual_chop()
