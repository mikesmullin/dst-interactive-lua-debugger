-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("DYNAMIC_ANIM", "anim/dynamic/glomling_beardeddragon.zip"),
}

return CreatePrefabSkin("glomling_beardeddragon",
{
	base_prefab = "critter_glomling",
	type = "item",
	assets = assets,
	build_name = "glomling_beardeddragon",
	rarity = "Elegant",
	init_fn = function(inst) pet_init_fn(inst, "glomling_beardeddragon", "glomling_build" ) end,
})
