extends Node

var playerBody: CharacterBody2D
var playerWeaponEquip:bool

var combatStarted:bool

var playerAlive:bool
var playerAttackZone: Area2D
var playerDamageAmount: int
var playerHitbox: Area2D


var batDamageAmount:int

var frogDamageAmount:int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
