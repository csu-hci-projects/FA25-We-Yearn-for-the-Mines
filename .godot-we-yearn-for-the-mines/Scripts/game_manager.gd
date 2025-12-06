extends Node

var moondust = 0

func play_enemy_death_sound():
	$"EnemyDeathSound".play()

func play_moondust_pickup_sound():
	$"MoondustPickupSound".play()

func play_pew_pew():
	$"PewPewSound".play()
	
func play_pew_pew_terrain():
	$"PewPewTerrainSound".play()

func play_oof_sound():
	$"OofSound".play()
	
func play_player_damage():
	$"PlayerDamageSound".play()
	
func play_healing_sound():
	$"HealingSound".play()
