extends Node2D

var visited
var up
var down
var left
var right

func _ready():
	visited = false
	up = true
	down = true
	left = true
	right = true
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
