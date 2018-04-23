extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var coll
func _ready():
	coll = $CollisionShape2D
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Code_area_entered(area):
	if area.name == "HitBox":
		remove_child($CollisionShape2D)
		$Sprite.hide()
		$AudioStreamPlayer.play()
	pass # replace with function body
