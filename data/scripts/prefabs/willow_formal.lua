-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_willow_build.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/willow_formal.zip"),
}

return CreatePrefabSkin("willow_formal",
{
	base_prefab = "willow",
	type = "base",
	assets = assets,
	build_name = "willow_formal",
	rarity = "Elegant",
	skins = { ghost_skin = "ghost_willow_build", normal_skin = "willow_formal", },
})
