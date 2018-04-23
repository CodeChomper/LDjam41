extends Node2D

var visited
var pos = Vector2()


func _ready():
	visited = false
	var bgs = ["f1", "f2", "f3", "f4", "f5", "f6"]
	var index = randi() % 6
	$BG.play(bgs[index])
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
