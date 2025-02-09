extends Node

var minionScene = preload("res://MinionBody.tscn")
var enemyMinionScene = preload("res://EnemyMinionBody.tscn")

func _ready():
	var playerWell = get_tree().get_nodes_in_group("Player Well")[0]
	var enemyWell = get_tree().get_nodes_in_group("Enemy Well")[0]
	playerWell.enemyWon.connect(_on_game_over)
	enemyWell.playerWon.connect(_on_game_over)


func _process(_delta):
	pass


func _on_timer_timeout():
	var minion = minionScene.instantiate()
	var enemyMinion = enemyMinionScene.instantiate()
	var spawns = get_tree().get_nodes_in_group("Player Minion Spawn Locations")
	var enemySpawns = get_tree().get_nodes_in_group("Enemy Minion Spawn Locations")
	spawns.pick_random().add_child(minion)
	enemySpawns.pick_random().add_child(enemyMinion)

func _on_game_over():
	self.queue_free()
