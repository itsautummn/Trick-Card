extends Node2D

@onready var vbox: VBoxContainer = $VBoxContainer
var effects_array: Array


func add_effect(effect):
	vbox.add_child(effect)
	effects_array.append(effect)


func remove_effect(effect):
	vbox.remove_child(effect)
	effects_array.erase(effect)
