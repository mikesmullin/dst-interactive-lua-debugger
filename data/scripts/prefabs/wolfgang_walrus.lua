-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_wolfgang_build.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wolfgang_mighty_walrus.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wolfgang_walrus.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wolfgang_skinny_walrus.zip"),
}

return CreatePrefabSkin("wolfgang_walrus",
{
	base_prefab = "wolfgang",
	type = "base",
	assets = assets,
	build_name = "wolfgang_walrus",
	rarity = "Event",
	skins = { ghost_skin = "ghost_wolfgang_build", mighty_skin = "wolfgang_mighty_walrus", normal_skin = "wolfgang_walrus", wimpy_skin = "wolfgang_skinny_walrus", },
})
