-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_willow_build.zip"),
	Asset("ANIM", "anim/willow.zip"),
}

return CreatePrefabSkin("willow_none",
{
	base_prefab = "willow",
	type = "base",
	assets = assets,
	build_name = "willow",
	rarity = "Common",
	skins = { ghost_skin = "ghost_willow_build", normal_skin = "willow", },
})
