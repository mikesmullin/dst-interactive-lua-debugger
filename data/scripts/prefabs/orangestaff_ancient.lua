-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("DYNAMIC_ANIM", "anim/dynamic/orangestaff_ancient.zip"),
}

return CreatePrefabSkin("orangestaff_ancient",
{
	base_prefab = "orangestaff",
	type = "item",
	assets = assets,
	build_name = "orangestaff_ancient",
	rarity = "Timeless",
	prefabs = { "cane_ancient_fx", "shadow_puff_large_front", "shadow_puff_large_back", },
	init_fn = function(inst) orangestaff_init_fn(inst, "orangestaff_ancient") end,
	fx_prefab = { "cane_ancient_fx", "shadow_puff_large_front", "shadow_puff_large_back", },
})
