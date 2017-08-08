-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_wes_build.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wes_formal.zip"),
}

return CreatePrefabSkin("wes_formal",
{
	base_prefab = "wes",
	type = "base",
	assets = assets,
	build_name = "wes_formal",
	rarity = "Elegant",
	skins = { ghost_skin = "ghost_wes_build", normal_skin = "wes_formal", },
	torso_tuck_builds = { "wes_formal", },
	has_alternate_for_body = { "wes_formal", },
	has_alternate_for_skirt = { "wes_formal", },
})
