-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_wolfgang_build.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wolfgang_mighty_formal.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wolfgang_formal.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wolfgang_skinny_formal.zip"),
}

return CreatePrefabSkin("wolfgang_formal",
{
	base_prefab = "wolfgang",
	type = "base",
	assets = assets,
	build_name = "wolfgang_formal",
	rarity = "Elegant",
	skins = { ghost_skin = "ghost_wolfgang_build", mighty_skin = "wolfgang_mighty_formal", normal_skin = "wolfgang_formal", wimpy_skin = "wolfgang_skinny_formal", },
	torso_tuck_builds = { "wolfgang_formal", "wolfgang_skinny_formal", "wolfgang_mighty_formal", },
})
