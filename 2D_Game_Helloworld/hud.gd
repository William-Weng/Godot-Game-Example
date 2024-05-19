extends CanvasLayer

signal start_game

# MARK: - 生命週期
func _ready(): pass
func _process(delta: float): pass

# MARK: - Node函式
func _on_start_button_pressed(): _OnStartButtonPressed()
func _on_message_timer_timeout(): _OnMessageTimerTimeout()

# MARK: - 公用函式
func show_game_over(): _ShowGameOverAction()
func update_score(score: int): _UpdateScoreAction(score)
func show_message(text: String): _ShowMessageAction(text)

# MARK: - 主工具
# 按下開始鍵後 => 開始遊戲
func _OnStartButtonPressed():
	$StartButton.hide()
	start_game.emit()

# 隱藏$Message / $StartButton (One Shot)
func _OnMessageTimerTimeout():
	$Message.hide()
	$StartButton.hide()

# 更新分數
# - Parameters:
#   - score: int
func _UpdateScoreAction(score: int):
	$ScoreLabel.text = str(score)

# 顯示提示訊息
# - Parameters:
#   - text: String
func _ShowMessageAction(text: String):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# 顯示遊戲結束提示訊息
func _ShowGameOverAction():
	
	_ShowMessageAction("Game Over")
	
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()

	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
