extends MeshInstance3D

var hp = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func takeDamage(amt):
	hp -= amt
	if hp <= 0:
		var enemyMinions = get_tree().get_nodes_in_group("Enemy Minions")
		for m in enemyMinions:
			m.get_node("Delay").start()
		self.queue_free()

		
func playerTower():
	pass
