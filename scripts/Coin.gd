extends Area2D

var spawn

func _ready():
	$Tween.interpolate_property($Coin, 'scale',
								$Coin.scale,
								$Coin.scale * 3,
								0.3,
								Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)

	$Tween.interpolate_property($Coin, 'modulate',
								Color(1, 1, 1, 1), 
								Color(1, 1, 1, 0),
								0.3, 
								Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)

func pickup():
	monitoring = false
	spawn.free = true
	$Shadow.queue_free()
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	queue_free()