extends Node2D

var logs: int = 0

@onready var logs_label: Label = $UI_Logs/LogsLabel
@onready var chop_progress: ProgressBar = $ChopProgress
@onready var chop_timer: Timer = $ChopTimer
@onready var woodcutter := $ActionPoint/EnvironmentTreePlaceholder/CharacterWoodcutterPlaceholder


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
	# We want "time elapsed" from 0 to 3
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


func update_logs() -> void:
	logs_label.text = "%d" % logs


func chop_log() -> void:
	logs += 1
	update_logs()


func _on_chop_timer_timeout() -> void:
	chop_log()
	# Timer auto-restarts because One Shot is false
	# Bar will naturally go back to 0 because time_left resets
