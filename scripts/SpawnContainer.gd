extends Node

func get_spawn_point():
	var spawn = get_child(rand_range(0, get_child_count()))
	

	
	while(spawn.free != true || spawn.active != true):
		spawn = get_child(rand_range(0, get_child_count()))
	
	if spawn.active == false:
		print("Error")
	
	return spawn