-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("DYNAMIC_ANIM", "anim/dynamic/researchlab4_glommer_costume.zip"),
}

return CreatePrefabSkin("researchlab4_glommer_costume",
{
	base_prefab = "researchlab4",
	type = "item",
	assets = assets,
	build_name = "researchlab4_glommer_costume",
	rarity = "Elegant",
	init_fn = function(inst) researchlab4_init_fn(inst, "researchlab4_glommer_costume") end,
})
