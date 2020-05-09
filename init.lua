minechemistry = {}
minechemistry.path = minetest.get_modpath('minechemistry')
local S = minetest.get_translator("minechemistry")
dofile(minechemistry.path.."/item.lua")
print(S("[MOD]minechemistry loaded"))
