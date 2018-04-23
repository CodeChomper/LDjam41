extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal exit_touched
var unlockSound
var doorSprite
func _ready():
	doorSprite = $Area2D/DoorSprite
	unlockSound = $UnlockSound
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_area_entered(area):
	emit_signal("exit_touched")
