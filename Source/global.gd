extends Node

@export var inv_manager:InventoryManager
var current_item_index:int
var run_info:RunInfo
var health_drain_timer:float = 0
var base_health_drain_delay:float = 2.4
var plr_active_effects:Array[StatusEffect]
var plrAtkBase : float
var plrDefBase : float
## Depth is increased when going down a ladder,[br]
## but before the floor is refreshed.
var boss_room:bool:
	get:
		return Global.run_info.depth % 10 == 0

@export_dir var items_texture_path: String
@export_dir var parts_texture_path: String

var level_state:LevelState = LevelState.CALM
enum LevelState {
	CALM,
	BATTLE,
	BOSS
}
var combat_chill_timer:float = 0.0
const COMBAT_CHILL_THRESHOLD:float = 7.0
var audio:Audio
var pause_health_drain:bool = true
func trigger_combat_state():
	if level_state == LevelState.BOSS: return
	if level_state != LevelState.BATTLE:
		audio.activate_track(audio.battle_layer)
	level_state = LevelState.BATTLE
	combat_chill_timer = COMBAT_CHILL_THRESHOLD

func _ready() -> void:
	audio = Main.instance.audio
	start_new_run()


func get_current_item() -> Item:
	return inv_manager.inventory[current_item_index]

func _process(delta: float) -> void:
	if not pause_health_drain:
		var plr = Main.instance.get_player()
		health_drain_timer += delta
		if health_drain_timer >= base_health_drain_delay:
			health_drain_timer = 0
			plr.knockless_hurt(ElementalType.ET_Neutral.new(1,plr))
	if not get_tree().paused:
		combat_chill_timer -= delta
		if combat_chill_timer <= 0 and level_state != LevelState.BOSS:
			level_state = LevelState.CALM
			audio.activate_track(audio.calm_layer)
func start_new_run():
	get_tree().paused = false
	run_info = RunInfo.new()
	inv_manager = InventoryManager.new()
	Main.instance.refresh_floor()


func save_plr_effects(plr:Player) -> void:
	plr_active_effects = plr.plr_statuses
func load_plr_effects() -> Array[StatusEffect]:
	return plr_active_effects

@export var popup_text_scene:PackedScene

func popup_text(t:String,pos:Vector2,clr:Color=Color.WHITE) -> void:
	var pt_inst = (popup_text_scene.instantiate())
	pt_inst.text = str("[center][color=%s]" % clr.to_html(), t)
	pt_inst.position = pos
	var flr: Floor = Main.instance.current_floor
	flr.add_child(pt_inst)
