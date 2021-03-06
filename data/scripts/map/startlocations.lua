
local startlocations = {}
local modstartlocations = {}

--------------------------------------------------------------------
-- Module functions
--------------------------------------------------------------------

local function GetGenStartLocations(world)
    local ret = {}
    for k,v in pairs(startlocations) do
        if world == nil or v.location == world then
            table.insert(ret, {text = v.name, data = k})
        end
    end
    for mod,locations in pairs(modstartlocations) do
        for k,v in pairs(locations) do
            if world == nil or v.location == world then
                table.insert(ret, {text = v.name, data = k})
            end
        end
    end

    -- Because this is used by frontend, we have to give some kind of value for display.
    if next(ret) == nil then
        local v = startlocations['default']
        table.insert(ret, {text=v.name, data='default'})
    end

    return ret
end

local function GetStartLocation(name)
    for mod,locations in pairs(modstartlocations) do
        if locations[name] ~= nil then
            return deepcopy(locations[name])
        end
    end
    return deepcopy(startlocations[name])
end

local function ClearModData(mod)
    if mod == nil then
        modstartlocations = {}
    else
        modstartlocations[mod] = nil
    end
end

------------------------------------------------------------------
-- GLOBAL functions
------------------------------------------------------------------

function AddStartLocation(name, data)
    if ModManager.currentlyloadingmod ~= nil then
        AddModStartLocation(ModManager.currentlyloadingmod, name, data)
        return
    end
    assert(GetStartLocation(name) == nil, string.format("Tried adding a start location '%s' but one already exists!", name))
    startlocations[name] = data
end

function AddModStartLocation(mod, name, data)
    if GetStartLocation(name) ~= nil then
        moderror(string.format("Tried adding a start location '%s' but one already exists!", name))
        return
    end
    if modstartlocations[mod] == nil then modstartlocations[mod] = {} end
    modstartlocations[mod][name] = data
end

------------------------------------------------------------------
-- Load the data
------------------------------------------------------------------

AddStartLocation("default", {
    name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
    location = "forest",
    start_setpeice = "DefaultStart",
    start_node = "Clearing",
})

AddStartLocation("plus", {
    name = STRINGS.UI.SANDBOXMENU.PLUSSTART,
    location = "forest",
    start_setpeice = "DefaultPlusStart",	
    start_node = {"DeepForest", "Forest", "SpiderForest", "Plain", "Rocky", "Marsh"},
})

AddStartLocation("darkness", {
    name = STRINGS.UI.SANDBOXMENU.DARKSTART,
    location = "forest",
    start_setpeice = "DarknessStart",	
    start_node = {"DeepForest", "Forest"},	
})

AddStartLocation("caves", {
    name = STRINGS.UI.SANDBOXMENU.CAVESTART,
    location = "cave",
    start_setpeice = "CaveStart",	
    start_node = {
        "RabbitArea",
        "RabbitTown",
        "RabbitSinkhole",
        "SpiderIncursion",
        "SinkholeForest",
        "SinkholeCopses",
        "SinkholeOasis",
        "GrasslandSinkhole",
        "GreenMushSinkhole",
        "GreenMushRabbits",
    },
})

------------------------------------------------------------------
-- Export functions
------------------------------------------------------------------

return {
    GetGenStartLocations = GetGenStartLocations,
    GetStartLocation = GetStartLocation,
    ClearModData = ClearModData,
}
