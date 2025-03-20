extends Node

@onready var cursors = {}  # Dictionary to store cursor images

func _ready():
	cursors["default"] = load("res://assets/cursors/default.png")
	cursors["open"] = load("res://assets/cursors/open.png")
	cursors["sleep"] = load("res://assets/cursors/sleep.png")

	Input.set_custom_mouse_cursor(cursors["default"])

var crop_scenes = {
	Util.Seeds.Carrot: preload("res://scenes/objects/crops/carrot.tscn"),
	Util.Seeds.Cauliflower: preload("res://scenes/objects/crops/cauliflower.tscn"),
	Util.Seeds.Tomato: preload("res://scenes/objects/crops/tomato.tscn"),
	Util.Seeds.Eggplant: preload("res://scenes/objects/crops/eggplant.tscn"),
	Util.Seeds.Tulip: preload("res://scenes/objects/crops/tulip.tscn"),
	Util.Seeds.Cabbage: preload("res://scenes/objects/crops/cabbage.tscn"),
	Util.Seeds.Wheat: preload("res://scenes/objects/crops/wheat.tscn"),
	Util.Seeds.Pumpkin: preload("res://scenes/objects/crops/pumpkin.tscn"),
	Util.Seeds.Turnip: preload("res://scenes/objects/crops/turnip.tscn"),
	Util.Seeds.BigFlower: preload("res://scenes/objects/crops/big_flower.tscn"),
	Util.Seeds.Starfruit: preload("res://scenes/objects/crops/starfruit.tscn"),
	Util.Seeds.Beetroot: preload("res://scenes/objects/crops/beetroot.tscn"),
	Util.Seeds.Cucumber: preload("res://scenes/objects/crops/cucumber.tscn")
}

enum Tools {
	None,
	Axe,
	Hoe,
	Pickaxe,
	WateringCan
}

enum Seeds {
	Corn,
	Carrot,
	Cauliflower,
	Tomato,
	Eggplant,
	Tulip,
	Cabbage,
	Wheat,
	Pumpkin,
	Turnip,
	BigFlower,
	Beetroot,
	Starfruit,
	Cucumber
}

enum GrowthStates {
	Seed,
	Germination,
	Seedling,
	Vegetative,
	Budding,
	Flowering,
	Fruiting,
	Harvesting
}

enum Classes {
	Warrior,
	Archer,
	Mage,
	Assassin
}

enum ItemCategories {
	Tool,
	Weapon,
	Armor,
	Resource,
	Seeds,
	Consumable,
	Objects
}

enum CraftingStations {
	None,
	Workbench,
	Anvil
}

enum Objects {
	Workbench
}

enum ResourceTypes {
	Wood,
	Stone,
	Ore,
	Ingot
}

enum Worlds {
	Test,
	Village,
	Home
}
