extends RigidBody2D

# MARK: - 生命週期
func _ready(): _ReadyAction()
func _process(delta): pass

# MARK: - Node函式
func _on_visible_on_screen_notifier_2d_screen_exited(): _OnVisibleOnScreenNotifier2dScreenExited()

# MARK: - 主工具
# 初始化的動作 (隨機動畫)
func _ReadyAction():
	
	var mobTypes: PackedStringArray = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var randomIndex: int = randi() % mobTypes.size()
	
	$AnimatedSprite2D.play(mobTypes[randomIndex])

# 超出畫面後清除
func _OnVisibleOnScreenNotifier2dScreenExited():
	queue_free()
