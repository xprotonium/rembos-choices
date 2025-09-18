extends Node

var rewards = {
	"Common1": 70,     
	"Rare2": 25,       
	"Legendary3": 5    
}

func roll_gacha():
	var total_weight = 0
	for weight in rewards.values():
		total_weight += weight
	
	var rand_num = randi() % total_weight
	var cumulative = 0
	
	for reward in rewards.keys():
		cumulative += rewards[reward]
		if rand_num < cumulative:
			return reward
	return null

func _ready():
	randomize()
	for i in range(10):  
		print("Roll ", i+1, ": ", roll_gacha())
