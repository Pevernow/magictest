local S = minetest.get_translator("minechemistry")
minetest.register_node(
	"minechemistry:element_separator",
	{
		description = S("Element separator"),
		tiles = {"element_separator.png"},
		drop = "minechemistry:element separator",
		legacy_mineral = true,
		sounds = default.node_sound_stone_defaults(),
		groups = {cracky = 3, tubedevice = 1, tubedevice_receiver = 1},
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			local inv = minetest.get_meta(pos):get_inventory()
			inv:set_size("fuel", 1 * 1)
			inv:set_size("src", 1 * 1)
			inv:set_size("dst", 2 * 2)
			meta:set_string(
				"formspec",
				[[
				size[10,10]
				list[context;fuel;2,3;1,1;]
				list[context;src;2,1;1,1;]
				list[context;dst;5,1;2,2;]
				list[current_player;main;0,5;8,4;]
			]]
			)
			meta:set_string("infotext", "Separator")
			meta:set_int("srcprogress", 0)
			meta:set_float("iron", 0.0)
			meta:set_float("coal", 0.0)
			meta:set_float("copper", 0.0)
			meta:set_float("tin", 0.0)
			meta:set_float("gold", 0.0)
			meta:set_float("mese_crystal", 0.0)
			meta:set_float("diamond", 0.0)
			meta:set_float("mese", 0.0)
		end,
		can_dig = function(pos, player)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if not inv:is_empty("fuel") then
				return false
			elseif not inv:is_empty("dst") then
				return false
			elseif not inv:is_empty("src") then
				return false
			end
			return true
		end,
		tube = {
			insert_object = function(pos, node, stack, direction)
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				return inv:add_item("src", stack)
			end,
			can_insert = function(pos, node, stack, direction)
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				return inv:room_for_item("src", stack)
			end,
			input_inventory = "src",
			connect_sides = {left = 1, right = 1, back = 1, bottom = 1, top = 1}
		}
	}
)
minetest.register_abm(
	{
		nodenames = {"minechemistry:element_separator"},
		interval = 1.0,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if meta:get_float("iron") >= 100 then
				inv:add_item("dst", ItemStack("default:iron_lump"))
				meta:set_float("iron", 0.0)
			end
			if meta:get_float("coal") >= 100 then
				inv:add_item("dst", ItemStack("default:coal_lump"))
				meta:set_float("coal", 0.0)
			end
			if meta:get_float("copper") >= 100 then
				inv:add_item("dst", ItemStack("default:copper_lump"))
				meta:set_float("copper", 0.0)
			end
			if meta:get_float("tin") >= 100 then
				inv:add_item("dst", ItemStack("default:tin_lump"))
				meta:set_float("tin", 0.0)
			end
			if meta:get_float("gold") >= 100 then
				inv:add_item("dst", ItemStack("default:gold_lump"))
				meta:set_float("gold", 0.0)
			end
			if meta:get_float("mese_crystal") >= 100 then
				inv:add_item("dst", ItemStack("default:mese_crystal"))
				meta:set_float("mese_crystal", 0.0)
			end
			if meta:get_float("diamond") >= 100 then
				inv:add_item("dst", ItemStack("default:diamond"))
				meta:set_float("diamond", 0.0)
			end
			if meta:get_float("mese") >= 100 then
				inv:add_item("dst", ItemStack("default:mese"))
				meta:set_float("mese", 0.0)
			end
			if not inv:is_empty("src") and inv:get_list("src")[1]:get_name() == "default:cobble" then
				local srcstack = inv:get_stack("src", 1)
				srcstack:take_item()
				inv:set_stack("src", 1, srcstack)
				meta:set_float("coal", meta:get_float("coal") + math.random(41, 59) / 100)
				meta:set_float("copper", meta:get_float("copper") + math.random(14, 41) / 500)
				meta:set_float("tin", meta:get_float("tin") + math.random(14, 41) / 500)
				meta:set_float("iron", meta:get_float("iron") + math.random(6, 41) / 1000)
				meta:set_float("gold", meta:get_float("gold") + math.random(3, 6) / 5000)
				meta:set_float("mese_crystal", meta:get_float("mese_crystal") + math.random(3, 11) / 10000)
				meta:set_float("diamond", meta:get_float("diamond") + math.random(9, 11) / 50000)
				meta:set_float("mese", meta:get_float("mese") + math.random(1, 9) / 100000)
			end
			meta:set_string(
				"infotext",
				S("Coal")..":" .. string.format("%.2f", meta:get_float("coal")) .. 
				"%\n"..S("Iron")..":" .. string.format("%.2f", meta:get_float("iron")) .. 
				"%\n"..S("Copper")..":" .. string.format("%.2f", meta:get_float("copper")) .. 
				"%\n"..S("Gold")..":" .. string.format("%.2f", meta:get_float("gold")) ..
				"%\n"..S("Tin")..":" .. string.format("%.2f", meta:get_float("tin")) ..  
				"%\n"..S("Mese crystal")..":" .. string.format("%.2f", meta:get_float("mese_crystal")) ..
				"%\n"..S("Diamond")..":" .. string.format("%.2f", meta:get_float("diamond")) ..
				"%\n"..S("Mese")..":" .. string.format("%.2f", meta:get_float("mese")) ..
			)
		end
	}
)

--[[minetest.register_craft({
	output = "minehe",
	recipe = {
		{"technic:carbon_plate", "technic:doped_silicon_wafer", "technic:composite_plate"},
		{"basic_materials:motor", "technic:machine_casing", "technic:diamond_drill_head"},
		{"technic:blue_energy_crystal", "technic:hv_cable", "technic:blue_energy_crystal"}
	}
})]]
