extends Area2D

@export var speed: int = 400

signal hit

var screen_size: Vector2

# MARK: - 生命週期
func _ready(): _ReadyAction()
func _process(delta: float): _ProcessAction(delta)

# MARK: - Node函式
func _on_body_entered(body: Node2D): _OnBodyEntered(body)

# MARK: - 公用函式
func start(position: Vector2): _StartAction(position)

# MARK: - 主工具
# 初始化的動作 (取得畫面大小 / 隱藏玩家)
func _ReadyAction():
	screen_size = get_viewport_rect().size
	hide()

# 畫面刷新時的動作
# - Parameters:
#   - delta: 畫面更新率 (fps)
func _ProcessAction(delta: float):
	
	var velocity = _MoveVelocityAction()
	
	_PositionAction(delta, velocity, screen_size)
	_AnimationSetting(velocity)
	
	# 設定起始的位置
# - Parameters:
#   - position: 位置
func _StartAction(position: Vector2):
	self.position = position
	show()
	$CollisionShape2D.disabled = false

# 敵人碰撞到玩家後都會送出訊號 => 執行hit()
# - Parameters:
#   - body: Node2D
func _OnBodyEntered(body: Node2D):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

# MARK: - 小工具
# 按下方向鍵後，玩家移動的單位速度處理
# - Returns: Vector2
func  _MoveVelocityAction() -> Vector2:
	
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"): velocity.x += 1
	if Input.is_action_pressed("move_left"): velocity.x -= 1
	if Input.is_action_pressed("move_down"): velocity.y += 1
	if Input.is_action_pressed("move_up"): velocity.y -= 1
	
	return velocity

# 按下方向鍵後，玩家移動的速度處理 / 防止人物超出畫面
# - Parameters:
#   - delta: 畫面更新率 (fps)
#   - velocity: 單位速度
#   - screenSize: 畫面大小
func _PositionAction(delta: float, velocity: Vector2, screenSize: Vector2):
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screenSize)
	
# 動畫設定 => 使用什麼動畫 / 什麼時候反轉
# - Parameters:
#   - velocity: Vector2
func _AnimationSetting(velocity: Vector2):
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
