extends Node

var minionScene = preload("res://MinionBody.tscn")
var enemyMinionScene = preload("res://EnemyMinionBody.tscn")

func _ready():
	pass


func _process(_delta):
	pass


func _on_timer_timeout():
	var minion = minionScene.instantiate()
	var enemyMinion = enemyMinionScene.instantiate()
	var spawns = get_tree().get_nodes_in_group("Player Minion Spawn Locations")
	var enemySpawns = get_tree().get_nodes_in_group("Enemy Minion Spawn Locations")
	spawns.pick_random().add_child(minion)
	enemySpawns.pick_random().add_child(enemyMinion)
