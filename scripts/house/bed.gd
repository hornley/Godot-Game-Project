extends StaticBody2D

var selected_color: String = ""
const bed_region_position_x = {
	"Yellow": 1,
	"Blue": 17,
	"Red": 33
}
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var option_button: OptionButton = $OptionButton
# @export_enum("Hello") var options: String

func _ready():
	# Add items to the OptionButton (you can do this in the editor too)
	option_button.add_item("Yellow")
	option_button.add_item("Blue")
	option_button.add_item("Red")

	option_button.connect("item_selected", _on_item_selected)

	# Initialize selected_option (optional, use if you want to initialize from a saved value or something)
	if option_button.get_item_count() > 0: # Check if there are options
		selected_color = option_button.get_item_text(option_button.get_selected_id())

func _on_item_selected(index):
	sprite_2d.region_rect.position.x = bed_region_position_x[option_button.get_item_text(index)]
