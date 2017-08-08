-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_wendy_build.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wendy_survivor.zip"),
}

return CreatePrefabSkin("wendy_survivor",
{
	base_prefab = "wendy",
	type = "base",
	assets = assets,
	build_name = "wendy_survivor",
	rarity = "Elegant",
	skins = { ghost_skin = "ghost_wendy_build", normal_skin = "wendy_survivor", },
	torso_untuck_builds = { "wendy_survivor", },
})
