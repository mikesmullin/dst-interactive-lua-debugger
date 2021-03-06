-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_wickerbottom_build.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wickerbottom_shadow.zip"),
}

return CreatePrefabSkin("wickerbottom_shadow",
{
	base_prefab = "wickerbottom",
	type = "base",
	assets = assets,
	build_name = "wickerbottom_shadow",
	rarity = "Elegant",
	skins = { ghost_skin = "ghost_wickerbottom_build", normal_skin = "wickerbottom_shadow", },
	torso_tuck_builds = { "wickerbottom_shadow", },
	has_alternate_for_body = { "wickerbottom_shadow", },
	has_alternate_for_skirt = { "wickerbottom_shadow", },
	feet_cuff_size = { wickerbottom_shadow = 3, },
})
