extends Area2D

const STRENGTH = 4
const MANA_RECOVERY_FACTOR = 10

@onready var sprite: Sprite2D = $Sprite

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var player: CharacterBody2D = $".."

var active: bool = false
var direction: String

func reset() -> void:
	active = false
	sprite.scale = Vector2.ONE

func start(orientation: String) -> void:
	direction = orientation
	active = true
	animation_player.play(orientation)
	
	# flip horizontally the attack to match the player's direction
	if (orientation == "up" and player.sprite.flip_h) \
	or (orientation == "down" and not player.sprite.flip_h):
		scale.x = -1
	else:
		scale.x = 1

func _ready() -> void:
	sprite.texture = Global.basic_slash_sprite

func _process(_delta: float) -> void:
	# check if the attack needs to be flipped too
	if (player.sprite.flip_h and direction == "right") \
	or (not player.sprite.flip_h and direction == "left"):
		scale.x = -1
	else:
		scale.x = 1
	
	if player.state == player.State.Fainted:
		hide()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		if area.hurt(STRENGTH + player.strength, self):
			# restore mana only if the slash hurt the enemy
			player.restore_mana(MANA_RECOVERY_FACTOR * STRENGTH + player.strength)
		
		# make player bounce on the enemy
		if animation_player.current_animation == "down":
			player.handle_bounce()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "RESET":
		animation_player.play("RESET")
