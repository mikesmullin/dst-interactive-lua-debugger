-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("DYNAMIC_ANIM", "anim/dynamic/glomling_winter.zip"),
}

return CreatePrefabSkin("glomling_winter_builder",
{
	base_prefab = "critter_glomling_builder",
	type = "item",
	assets = assets,
	build_name = "glomling_winter",
	rarity = "Common",
	init_fn = function(inst) critter_builder_init_fn(inst, "glomling_winter" ) end,
})
