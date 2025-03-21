extends Node

@onready var cursors = {}  # Dictionary to store cursor images

func _ready():
	cursors["default"] = load("res://assets/cursors/default.png")
	cursors["open"] = load("res://assets/cursors/open.png")
	cursors["sleep"] = load("res://assets/cursors/sleep.png")

	Input.set_custom_mouse_cursor(cursors["default"])

var crop_scenes = {
}

var actions_equivalent = {
	"Tilled Land": Actions.Tilling
}

enum Tools {
	None,
	Axe,
	Hoe,
	Pickaxe,
	WateringCan
}

enum Actions {
	None,
	Tilling,
	Mining,
	Chopping,
	Watering,
	Planting,
	Harvesting,
	UndergrowthWeeding,
	OvergrowthClearing
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
