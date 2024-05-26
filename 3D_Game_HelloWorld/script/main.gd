extends Node

@export var mob_scene: PackedScene	# mob主角載入

# MARK: - 生命週期
func _ready(): _ReadyActoin()
func _unhandled_input(event): _UnhandledInput(event)

# MARK: - Node函式
func _on_mob_timer_timeout(): _OnMobTimerTimeoutAction()
func _on_player_hit(): _OnPlayerHitAction()

# MARK: - 主工具
# 根據路徑隨機產生Mob
func _OnMobTimerTimeoutAction():
	
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $"SpawnPath/SpawnLocation"
	var player_position = $Player.position
	
	mob_spawn_location.progress_ratio = randf()
	mob.initialize(mob_spawn_location.position, player_position)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	
	add_child(mob)

# 初始化設定
func _ReadyActoin():
	$UserInterface/Retry.hide()

# Player被碰到的設定
func _OnPlayerHitAction():
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _UnhandledInput(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible: 
		get_tree().reload_current_scene()

