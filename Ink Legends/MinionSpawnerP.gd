extends Node

var minionScene = preload("res://MinionBody.tscn")

func _ready():
	pass


func _process(_delta):
	pass


func _on_timer_timeout():
	var minion = minionScene.instantiate()
	var spawns = get_tree().get_nodes_in_group("Player Minion Spawn Locations")
	spawns.pick_random().add_child(minion)
