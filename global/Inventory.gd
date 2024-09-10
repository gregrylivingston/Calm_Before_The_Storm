extends Node


var dirt: int = 0
var wood: int = 0
var stone: int = 0
var fruit: int = 0
var hay: int = 0
var meat: int = 0

var stars: int = 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Weather.new_round.connect(new_round)
	update_inventory.connect(updates)
	
signal update_inventory


func updates() -> void:
	pass
	
func new_round() -> void:
	dirt = 0
	wood = 0
	stone = 0
	fruit = 0
	hay = 0
	meat = 0
	stars = 0
