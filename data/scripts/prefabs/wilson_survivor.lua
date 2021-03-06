-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_wilson_build.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wilson_survivor.zip"),
}

return CreatePrefabSkin("wilson_survivor",
{
	base_prefab = "wilson",
	type = "base",
	assets = assets,
	build_name = "wilson_survivor",
	rarity = "Elegant",
	skins = { ghost_skin = "ghost_wilson_build", normal_skin = "wilson_survivor", },
})
