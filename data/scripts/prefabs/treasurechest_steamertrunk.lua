-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("DYNAMIC_ANIM", "anim/dynamic/treasurechest_steamertrunk.zip"),
}

return CreatePrefabSkin("treasurechest_steamertrunk",
{
	base_prefab = "treasurechest",
	type = "item",
	assets = assets,
	build_name = "treasurechest_steamertrunk",
	rarity = "Distinguished",
	init_fn = function(inst) treasurechest_init_fn(inst, "treasurechest_steamertrunk") end,
})
