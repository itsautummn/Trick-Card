extends Node2D

var current_player: AudioStreamPlayer2D
var tween1: Tween
var tween2: Tween


func _ready() -> void:
	current_player = $"Game Music"


func swap_player(player: AudioStreamPlayer2D) -> void:
	print("Swapping from ", current_player, " to ", player)
	if tween1:
		tween1.kill()
	if tween2:
		tween2.kill()
	
	tween1 = create_tween()
	tween2 = create_tween()
	tween1.parallel().tween_property(current_player, "volume_db", -80, .5)
	tween2.parallel().tween_property(player, "volume_db", 0, .1)
	current_player = player


func _on_shop_opened() -> void:
	swap_player($"Shop Music")


func _on_shop_closed() -> void:
	swap_player($"Game Music")
