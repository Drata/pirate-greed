extends Area2D

var spawn
var spawn_container

func _ready():
	
	$TweenPickup.interpolate_property($Bottle, 'scale',
								$Bottle.scale,
								$Bottle.scale * 3,
								0.3,
								$TweenPickup.TRANS_QUAD,
								$TweenPickup.EASE_IN_OUT)

	$TweenPickup.interpolate_property($Bottle, 'modulate',
								Color(1, 1, 1, 1), 
								Color(1, 1, 1, 0),
								0.3, 
								$TweenPickup.TRANS_QUAD,
								$TweenPickup.EASE_IN_OUT)
	
	$TweenPickup.interpolate_property($Bottle/Shadow, 'scale',
								$Bottle/Shadow.scale,
								$Bottle/Shadow.scale * 3,
								0.3,
								$TweenPickup.TRANS_QUAD,
								$TweenPickup.EASE_IN_OUT)

	$TweenPickup.interpolate_property($Bottle/Shadow, 'modulate',
								Color(1, 1, 1, 1), 
								Color(1, 1, 1, 0),
								0.3, 
								$TweenPickup.TRANS_QUAD,
								$TweenPickup.EASE_IN_OUT)

func pickup():
	monitoring = false
	$TweenPickup.start()
	spawn.free = true

func _on_TweenPickup_TweenPickup_completed(object, key):
	queue_free()

func _on_LifeTime_timeout():
	queue_free()

func _on_Timer_timeout():
	if $LifeTime.time_left <= 3:
		$Bottle/anim_fade.play("fade")
		$Timer.queue_free()