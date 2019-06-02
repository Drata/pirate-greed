extends Node

export (PackedScene) var Coin
export (PackedScene) var Obstacle
export (PackedScene) var Powerup
export (PackedScene) var Clock
export (int) var playtime

var level = 0
var score = 0
var best_score = 0
var time_left
var screensize
var playing = false
var savegame = File.new() #file
var save_path = "user://savegame.save" #place of the file
var save_data
var n_coins = 0

func _ready():
	save_data = {"highscore" : 0}
	if not savegame.file_exists(save_path):
    	create_save()
	
	best_score = read_savegame()
	
	$HUD.update_best_score(best_score)
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
func _process(delta):
	if !playing:
		get_input()
	else:
		if $CoinContainer.get_child_count() == 0:
			new_level()
		if (score > best_score):
			best_score = score
			$HUD.update_best_score(best_score)

func create_save():
   savegame.open(save_path, File.WRITE)
   savegame.store_var(save_data)
   savegame.close()

func save(high_score):	
	save_data["highscore"] = best_score #data to save
	savegame.open(save_path, File.WRITE) #open file to write
	savegame.store_var(save_data) #store the data
	savegame.close() # close the file

func read_savegame():
	savegame.open(save_path, File.READ) #open the file
	save_data = savegame.get_var() #get the value
	if (!save_data):
		return 0
	savegame.close() #close the file
	return save_data["highscore"] #return the value

func get_input():
	if Input.is_action_pressed("ui_start"):
		$HUD._on_StartButton_pressed()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	$GameMusic.play()
	new_level()

func new_level():
	$Player.monitoring = false
	level += 1
	time_left += 3
	$HUD.update_timer(time_left)
	destroy_obstacles()
	destroy_powerup()
	spawn_obstacles()
	if (level >= 1) && ((level % 2) == 0):
		$PowerupTimer.wait_time = rand_range(1, 3)
		$PowerupTimer.start()
	
	spawn_coins()
	$Player.monitoring = true
	
func spawn_obstacles():
	var n_obstacles = min(round(float(score) / 10), 5)
	
	for i in range(n_obstacles):
		var obs = Obstacle.instance()
		$ObstacleContainer.add_child(obs)
		var spawn = $SpawnContainer.get_spawn_point()
		obs.spawn = spawn
		obs.position = spawn.position
		spawn.free = false

func destroy_obstacles():
	for i in range($ObstacleContainer.get_child_count()):
		var obs = $ObstacleContainer.get_child(i)
		obs.spawn.free = true
		obs.queue_free()

func destroy_coins():
	for coin in $CoinContainer.get_children():
		coin.spawn.free = true
		coin.queue_free()

func destroy_powerup():
	for pu in $PowerupContainer.get_children():
		pu.spawn.free = true
		pu.queue_free()

func spawn_coins():
	$LevelSound.play()
	if n_coins <= 30:
		n_coins = level + 5
	for i in range(n_coins):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		var spawn = $SpawnContainer.get_spawn_point()
		c.spawn = spawn
		c.position = spawn.position
		spawn.free = false

func spawn_powerup():
	var p = Powerup.instance()
	$PowerupContainer.add_child(p)
	var spawn = $SpawnContainer.get_spawn_point()
	p.spawn = spawn
	p.position = spawn.position
	spawn.free = false

func spawn_clock():
	var cl = Clock.instance()
	$ClockContainer.add_child(cl)
	var spawn = $SpawnContainer.get_spawn_point()
	cl.spawn = spawn
	cl.position = spawn.position
	spawn.free = false
	
func game_over():
	save(best_score)
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	destroy_obstacles()
	destroy_coins()
	destroy_powerup()
	$HUD.show_game_over()
	$Player.die()

func _on_Player_pickup(type):
	match type:
		"coins":
			score += 1
			if fmod(float(score), 40.0) == 0.0:
				print(str(float(score)) + " " + str(fmod(float(score-1), 40.0)))
				spawn_clock()

			$CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			if ($Player.poweredup):
				$SpeedTimer.start()
			else:
				$Player.poweredup = true
				$Player.speed *= 1.75
				$GameMusic.pitch_scale = 1.5
				$SpeedTimer.start()
				$PowerupSound.play()
		"clock":
			$ClockSound.play()
			time_left += 5
			$HUD.update_timer(time_left)

func _on_Player_hurt():
	$EndSound.play()
	game_over()

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	log(time_left)
	if time_left <= 0:
		game_over()

func _on_PoweupTimer_timeout():
	spawn_powerup()

func _on_GameMusic_finished():
	$GameMusic.play()

func _on_SpeedTimer_timeout():
	$Player.poweredup = false
	$Player.speed /= 1.75
	$GameMusic.pitch_scale = 1
