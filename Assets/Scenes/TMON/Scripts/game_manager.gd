extends Node

# GameManager will basically keep track of
# all the important informations

# It will also handle the save game system

var horizontal_section: int
var vertical_section: int
var player: CharacterBody2D = null
var score: int = 0
var console_open = false
