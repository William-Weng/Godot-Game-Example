extends Label

var score = 0

# MARK: - 公用函式
func _on_mob_squashed(): _OnMobSquashedAction()

# MARK: - 主工具
# 壓到後計算分數
func _OnMobSquashedAction():
	score += 1
	text = "Score: %s" % score
