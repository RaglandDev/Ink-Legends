extends MeshInstance3D

var hp = 1000
signal enemyWon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func takeDamage(amt):
	hp -= amt
	if hp <= 0:
		enemyWon.emit()
		self.queue_free()
		
func playerWell():
	pass
