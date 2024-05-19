extends Node2D

@export var mob_scene: PackedScene
var score: int

# MARK: - 生命週期
func _ready(): new_game()
func _process(delta: float): pass

# MARK: - Node函式
func new_game(): _NewGameAction()
func game_over(): _GameOverAction()
func _on_score_timer_timeout(): _OnScoreTimerTimeout()
func _on_start_timer_timeout(): _OnStartTimerTimeout()
func _on_mob_timer_timeout(): _OnMobTimerTimeout()

# MARK: - 主工具
# 產生新遊戲 => 該清的清一清 / 音樂
func _NewGameAction():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

# 遊戲結束 => 該停的停一停 / 音樂
func _GameOverAction():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

# 2秒後啟動$MobTimer / $ScoreTimer (One Shot)
func _OnStartTimerTimeout():
	$MobTimer.start()
	$ScoreTimer.start()

# 更新分數 => 撐1秒加1分
func _OnScoreTimerTimeout():
	score += 1
	$HUD.update_score(score)
	
# 產生隨機位置的敵人 => 根據$MobPath/MobSpawnLocation上的範圍
func _OnMobTimerTimeout():
	
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)
