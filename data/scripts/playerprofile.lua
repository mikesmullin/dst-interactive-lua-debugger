local USE_SETTINGS_FILE = PLATFORM ~= "PS4" and PLATFORM ~= "NACL"

local PlayerProfile = Class(function(self)
    self.persistdata =
    {
        -- TODO: Some of this data should be synced across computers
        -- so will need to be stored on a server somewhere
        -- (In particular, collection_name, characterskins, and most_recent_item_skins)
        unlocked_worldgen = {},
        render_quality = RENDER_QUALITY.DEFAULT,
        -- Controlls should be a seperate file
        controls = {},
        starts = 0,
        saw_display_adjustment_popup = false,
        device_caps_a = 0,
        device_caps_b = 20,
        customizationpresets = {},
        collection_name = nil,
        saw_new_user_popup = false,
        saw_new_host_picker = false,
        install_id = os.time(),
        play_instance = 0,
    }

    --we should migrate the non-gameplay stuff to a separate file, so that we can save them whenever we want

    if not USE_SETTINGS_FILE then
        self.persistdata.volume_ambient = 7
        self.persistdata.volume_sfx = 7
        self.persistdata.volume_music = 7
        self.persistdata.HUDSize = 5
        self.persistdata.vibration = true
        self.persistdata.showpassword = false
        self.persistdata.movementprediction = true
        self.persistdata.wathgrithrfont = true
        self.persistdata.screenshake = true
        self.persistdata.warneddifficultyrog = false
        self.persistdata.controller_popup = false
        self.persistdata.warn_mods_enabled = true
    end

    self.dirty = true
end)

function PlayerProfile:Reset()
    self.persistdata.unlocked_worldgen = {}
    self.persistdata.saw_display_adjustment_popup = false
    self.persistdata.device_caps_a = 0
    self.persistdata.device_caps_b = 20
    self.persistdata.customizationpresets = {}
    self.persistdata.saw_new_user_popup = false
    self.persistdata.saw_new_host_picker = false
    self.persistdata.install_id = os.time()
    self.persistdata.play_instance = 0

    if not USE_SETTINGS_FILE then
        self.persistdata.volume_ambient = 7
        self.persistdata.volume_sfx = 7
        self.persistdata.volume_music = 7
        self.persistdata.HUDSize = 5
        self.persistdata.vibration = true
        self.persistdata.showpassword = false
        self.persistdata.movementprediction = true
        self.persistdata.wathgrithrfont = true
        self.persistdata.screenshake = true
        self.persistdata.warneddifficultyrog = false
        self.persistdata.controller_popup = false
        self.persistdata.warn_mods_enabled = true
    end

    --self.persistdata.starts = 0 -- save starts?
    self.dirty = true
    self:Save()
end

function PlayerProfile:SoftReset()
    self.persistdata.unlocked_worldgen = {}
    self.persistdata.saw_display_adjustment_popup = false
    self.persistdata.device_caps_a = 0
    self.persistdata.device_caps_b = 20
    self.persistdata.customizationpresets = {}
    self.persistdata.saw_new_user_popup = false
    self.persistdata.saw_new_host_picker = false
    self.persistdata.install_id = os.time()
    self.persistdata.play_instance = 0

    if not USE_SETTINGS_FILE then
        self.persistdata.volume_ambient = 7
        self.persistdata.volume_sfx = 7
        self.persistdata.volume_music = 7
        self.persistdata.HUDSize = 5
        self.persistdata.vibration = true
        self.persistdata.showpassword = false
        self.persistdata.movementprediction = true
        self.persistdata.wathgrithrfont = true
        self.persistdata.screenshake = true
        self.persistdata.warneddifficultyrog = false
        self.persistdata.controller_popup = false
        self.persistdata.warn_mods_enabled = true
    end
    -- and apply these values
    local str = json.encode(self.persistdata)
    self:Set(str, nil)
end

function PlayerProfile:GetSkins()
	local owned_skins = {}

	for prefab, skins in pairs(PREFAB_SKINS) do 
		local skins = self:GetSkinsForPrefab(prefab)
		owned_skins = JoinArrays(owned_skins, skins)
	end

	return owned_skins
end

function PlayerProfile:GetSkinsForPrefab(prefab)
	local owned_skins = {}
	table.insert(owned_skins, prefab.."_none") --everyone always has access to the nothing option

	local skins = PREFAB_SKINS[prefab]
	if skins ~= nil then
		for k,v in pairs(skins) do
			if TheInventory:CheckOwnership(v) then
				if v ~= "backpack_mushy" then
					table.insert(owned_skins, v)
				end
			end
		end
	end
	return owned_skins
end

function PlayerProfile:GetClothingOptionsForType(type)
	local owned_clothing = {}
	table.insert(owned_clothing, "") --everyone always has access to the nothing option

	for clothing_name,data in pairs(CLOTHING) do
		if data.type == type and TheInventory:CheckOwnership(clothing_name) then
			table.insert(owned_clothing, clothing_name)
		end
	end
	return owned_clothing
end

function PlayerProfile:GetBaseForCharacter(character)
	if not self.persistdata.characterskins then
		self.persistdata.characterskins = {}
	end

	if not self.persistdata.characterskins[character] then
		self.persistdata.characterskins[character] = {}
	end

	return self.persistdata.characterskins[character].last_base or nil
end

function PlayerProfile:GetSkinsForCharacter(character, base)
	if not self.persistdata.characterskins then
		self.persistdata.characterskins = {}
	end

	if not self.persistdata.characterskins[character] then
		self.persistdata.characterskins[character] = {}
	end

	return self.persistdata.characterskins[character][base] or {}
end

function PlayerProfile:GetAllEquippedSkins()
	if not self.persistdata.characterskins then
		return {}
	end

	local skinslist = {}
	for character,data in pairs(self.persistdata.characterskins) do
		for base, skins in pairs(data) do
			if type(skins) == "table" then
				for slot, name in pairs(skins) do
					if name ~= "" then
						table.insert(skinslist, name)
					end
				end
			end
		end
	end

	return skinslist
end

-- Returned as a table of tables, where each table matches the format of the data in PlayerHistory.
function PlayerProfile:GetAllRecentLoadouts()
	if not self.persistdata.characterskins then
		return {}
	end

	local loadouts = {}
	for character,data in pairs(self.persistdata.characterskins) do
		if data["last_base"] then 
			local character_base = data["last_base"]
			local character_data = {}
			character_data.name = TheNet:GetLocalUserName()
			if data[character_base] ~= nil then
				character_data.prefab = character
				character_data.base_skin = data[character_base]["base"]
				character_data.body_skin = data[character_base]["body"]
				character_data.hand_skin = data[character_base]["hand"]
				character_data.legs_skin = data[character_base]["legs"]
				character_data.feet_skin = data[character_base]["feet"]
			else
				print("Error: unable to find character in profile", character)
			end
			table.insert(loadouts, character_data)
		end
	end

	return loadouts
end

function PlayerProfile:SetSkinsForCharacter(character, base, skinList)
	if not self.persistdata.characterskins then
		self.persistdata.characterskins = {}
	end

	if not self.persistdata.characterskins[character] then
		self.persistdata.characterskins[character] = {}
	end

	self.dirty = true
	self.persistdata.characterskins[character].last_base = base
	self.persistdata.characterskins[character][base] = skinList

	self:Save()
end

function PlayerProfile:SetCollectionTimestamp(time)
	self.persistdata.collection_timestamp = time

	self:Save()
end

function PlayerProfile:GetCollectionTimestamp()
	return self.persistdata.collection_timestamp or -10000
end

function PlayerProfile:SetDressupTimestamp(time)
	self.persistdata.lobby_timestamp = time

	self:Save()
end

function PlayerProfile:GetDressupTimestamp()
	return self.persistdata.lobby_timestamp or -10000
end

function PlayerProfile:SetRecipeTimestamp(recipe, time)
	self.persistdata.recipe_timestamps = self.persistdata.recipe_timestamps or {}

	self.persistdata.recipe_timestamps[recipe] = time
	self:Save()
end

function PlayerProfile:GetRecipeTimestamp(recipe)
	if self.persistdata.recipe_timestamps then
		return self.persistdata.recipe_timestamps[recipe] or -10000
	else 
		return -10000
	end
end

function PlayerProfile:IsSkinEquipped(name, type)
	for character, data in pairs(self.persistdata.characterskins) do
		if data[type] == name then
			return true
		end
	end

	return false
end

-- may return nil
function PlayerProfile:GetLastUsedSkinForItem(item)
	if not self.persistdata.most_recent_item_skins then
		self.persistdata.most_recent_item_skins = {}
	--else
		--print("Most recent item skins is ", self.persistdata.most_recent_item_skins)
	end

	local skin = self.persistdata.most_recent_item_skins[item]
	return skin
end

function PlayerProfile:SetLastUsedSkinForItem(item, skin)
	if not self.persistdata.most_recent_item_skins then
		self.persistdata.most_recent_item_skins = {}
	end

	self.persistdata.most_recent_item_skins[item] = skin

	self:Save()
end

function PlayerProfile:SetCollectionName(name)
	self.persistdata.collection_name = name

	self:Save()
end

function PlayerProfile:GetCollectionName()
	if self.persistdata.collection_name then
		return self.persistdata.collection_name
	end

	return nil
end

function PlayerProfile:UnlockEverything()
    --Nothing locked in DST
end

function PlayerProfile:SetValue(name, value)
    self.dirty = true
    self.persistdata[name] = value
end

function PlayerProfile:GetValue(name)
	return self.persistdata[name]
end

function PlayerProfile:SetVolume(ambient, sfx, music)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("audio", "volume_ambient", tostring(math.floor(ambient)))
		TheSim:SetSetting("audio", "volume_sfx", tostring(math.floor(sfx)))
		TheSim:SetSetting("audio", "volume_music", tostring(math.floor(music)))
	else
	    self:SetValue("volume_ambient", ambient)
	    self:SetValue("volume_sfx", sfx)
	    self:SetValue("volume_music", music)
	    self.dirty = true
	end
end

function PlayerProfile:SetBloomEnabled(enabled)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("graphics", "bloom", tostring(enabled))
	else
		self:SetValue("bloom", enabled)
		self.dirty = true
	end
end

function PlayerProfile:GetBloomEnabled()
 	if USE_SETTINGS_FILE then
		return TheSim:GetSetting("graphics", "bloom") == "true"
	else
		return self:GetValue("bloom")
	end
end

function PlayerProfile:SetHUDSize(size)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("graphics", "HUDSize", tostring(size))
	else
		self:SetValue("HUDSize", size)
		self.dirty = true
	end
end

function PlayerProfile:GetHUDSize()
 	if USE_SETTINGS_FILE then
		return TheSim:GetSetting("graphics", "HUDSize") or 5
	else
		return self:GetValue("HUDSize") or 5
	end
end

function PlayerProfile:SetDistortionEnabled(enabled)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("graphics", "distortion", tostring(enabled))
	else
		self:SetValue("distortion", enabled)
		self.dirty = true
	end
end

function PlayerProfile:GetDistortionEnabled()
 	if USE_SETTINGS_FILE then
		return TheSim:GetSetting("graphics", "distortion") == "true"
	else
		return self:GetValue("distortion")
	end
end

function PlayerProfile:SetScreenShakeEnabled(enabled)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("graphics", "screenshake", tostring(enabled))
	else
		self:SetValue("screenshake", enabled)
		self.dirty = true
	end
end

function PlayerProfile:IsScreenShakeEnabled()
 	if USE_SETTINGS_FILE then
 		if TheSim:GetSetting("graphics", "screenshake") ~= nil then
			return TheSim:GetSetting("graphics", "screenshake") == "true"
		else
			return true -- Default to true this value hasn't been created yet
		end
	else
		if self:GetValue("screenshake") ~= nil then
			return self:GetValue("screenshake")
		else
			return true -- Default to true this value hasn't been created yet
		end
	end
end

function PlayerProfile:SetWathgrithrFontEnabled(enabled)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("misc", "wathgrithrfont", tostring(enabled))
	else
		self:SetValue("wathgrithrfont", enabled)
		self.dirty = true
	end
end

function PlayerProfile:IsWathgrithrFontEnabled()
 	if USE_SETTINGS_FILE then
 		if TheSim:GetSetting("misc", "wathgrithrfont") ~= nil then
			return TheSim:GetSetting("misc", "wathgrithrfont") == "true"
		else
			return true -- Default to true this value hasn't been created yet
		end
	else
		if self:GetValue("wathgrithrfont") ~= nil then
			return self:GetValue("wathgrithrfont")
		else
			return true -- Default to true this value hasn't been created yet
		end
	end
end

function PlayerProfile:SetHaveWarnedDifficultyRoG()
	if USE_SETTINGS_FILE then
		TheSim:SetSetting("misc", "warneddifficultyrog", "true")
	else
		self:SetValue("warneddifficultyrog", true)
		self.dirty = true
	end
end

function PlayerProfile:HaveWarnedDifficultyRoG()
	if USE_SETTINGS_FILE then
		return TheSim:GetSetting("misc", "warneddifficultyrog") == "true"
	else
		return self:GetValue("warneddifficultyrog")
	end
end

function PlayerProfile:SetVibrationEnabled(enabled)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("misc", "vibration", tostring(enabled))
	else
		self:SetValue("vibration", enabled)
		self.dirty = true
	end
end

function PlayerProfile:GetVibrationEnabled()
 	if USE_SETTINGS_FILE then
		return TheSim:GetSetting("misc", "vibration") == "true"
	else
		return self:GetValue("vibration")
	end
end

function PlayerProfile:SetShowPasswordEnabled(enabled)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("misc", "showpassword", tostring(enabled))
	else
		self:SetValue("showpassword", enabled)
		self.dirty = true
	end
end

function PlayerProfile:GetShowPasswordEnabled()
 	if USE_SETTINGS_FILE then
		return TheSim:GetSetting("misc", "showpassword") == "true"
	else
		return self:GetValue("showpassword")
	end
end

function PlayerProfile:SetMovementPredictionEnabled(enabled)
    if USE_SETTINGS_FILE then
        TheSim:SetSetting("misc", "movementprediction", tostring(enabled))
    else
        self:SetValue("movementprediction", enabled)
        self.dirty = true
    end
end

function PlayerProfile:GetMovementPredictionEnabled()
    -- an undefined movementprediction is considered to be enabled
    if USE_SETTINGS_FILE then
        return TheSim:GetSetting("misc", "movementprediction") ~= "false"
    else
        return self:GetValue("movementprediction") ~= false
    end
end

function PlayerProfile:SetAutoSubscribeModsEnabled(enabled)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("misc", "autosubscribemods", tostring(enabled))
	else
		self:SetValue("autosubscribemods", enabled)
		self.dirty = true
	end
end

function PlayerProfile:GetAutoSubscribeModsEnabled()
 	if USE_SETTINGS_FILE then
		return TheSim:GetSetting("misc", "autosubscribemods") == "true"
	else
		return self:GetValue("autosubscribemods")
	end
end

-- gjans: Added this upgrade path 28/03/2016
local function UpgradeProfilePresets(presets_string)
    local didupgrade = false
    local savefileupgrades = require "savefileupgrades"

    if presets_string ~= nil and type(presets_string) == "string" then
        local success, presets = RunInSandbox(presets_string)
        if success then
            for i,preset in ipairs(presets) do
                if preset.version == nil or preset.version == 1 then
                    -- note: this upgrades the presets table in-place, to handle custom presets referencing other custom presets without infinite recursion ~gjans
                    presets[i] = savefileupgrades.utilities.UpgradeUserPresetFromV1toV2(preset, presets)
                    didupgrade = true
                end
                
                if preset.version == 2 then
                    presets[i] = savefileupgrades.utilities.UpgradeUserPresetFromV2toV3(preset, presets)
                    didupgrade = true
				end
            end

            if didupgrade then
                local data = DataDumper(presets, nil, false)
                return data
            end
        end
    end
    return nil
end

function PlayerProfile:GetWorldCustomizationPresets()
    local presets_string = self:GetValue("customizationpresets")

    if presets_string ~= nil and type(presets_string) == "string" then
        local success, presets = RunInSandbox(presets_string)
        if success then
            return presets
        else
            return {}
        end
    else
        return {}
    end
end

function PlayerProfile:AddWorldCustomizationPreset(preset, index)
    local presets = self:GetWorldCustomizationPresets()

    if index then
        presets[index] = preset
    else
        table.insert(presets, preset)
    end
    local data = DataDumper(presets, nil, false)

    self:SetValue("customizationpresets", data)
    self.dirty = true
end

function PlayerProfile:GetSavedFilters()
	local filters_string = self:GetValue("serverfilters")

	if filters_string ~= nil and type(filters_string) == "string" then
		local success, filters = RunInSandbox(filters_string)
		if success then
			return filters
		else
			return {}
		end
	else
		return {}
	end
end

function PlayerProfile:SaveFilters(filters)
	local data = DataDumper(filters, nil, false)

	self:SetValue("serverfilters", data)
	self.dirty = true
	self:Save()
end

function PlayerProfile:GetVolume()
 	if USE_SETTINGS_FILE then
		local amb = TheSim:GetSetting("audio", "volume_ambient")
		if amb == nil then
			amb = 10
		end
		local sfx = TheSim:GetSetting("audio", "volume_sfx")
		if sfx == nil then
			sfx = 10
		end
		local music = TheSim:GetSetting("audio", "volume_music")
		if music == nil then
			music = 10
		end

		return amb, sfx, music
	else
    	return self.persistdata.volume_ambient or 10, self.persistdata.volume_sfx or 10, self.persistdata.volume_music or 10
	end
end


function PlayerProfile:SetRenderQuality(quality)
	self:SetValue("render_quality", quality)
	self.dirty = true
end

function PlayerProfile:GetRenderQuality()
	return self:GetValue("render_quality")
end

-- read only
function PlayerProfile:GetInstallID()
    return self:GetValue("install_id")
end

function PlayerProfile:GetPlayInstance()
    local stashed = TheSim:GetStashedPlayInstance()
    if stashed == -1 then
        stashed = self:GetValue("play_instance")
        TheSim:StashPlayInstance(stashed)
        self:SetValue("play_instance", stashed + 1)
        -- need to write this out right away, specifically because this should increment on crashes
        self:Save()
    end
    return stashed
end

----------------------------

function PlayerProfile:IsWorldGenUnlocked(area, item)
	if self.persistdata.unlocked_worldgen == nil then
		return false
	end

	if self.persistdata.unlocked_worldgen[area] == nil then
		return false
	end

    if item == nil or self.persistdata.unlocked_worldgen[area][item] then
        return true
    end

    return false
end

function PlayerProfile:UnlockWorldGen(area, item)
	if self.persistdata.unlocked_worldgen == nil then
		self.persistdata.unlocked_worldgen = {}
	end

	if self.persistdata.unlocked_worldgen[area] == nil then
		self.persistdata.unlocked_worldgen[area] = {}
	end

    self.persistdata.unlocked_worldgen[area][item] = true
    self.dirty = true
end

function PlayerProfile:GetUnlockedWorldGen()
    return self.persistdata.unlocked_worldgen
end

----------------------------

function PlayerProfile:GetSaveName()
    return BRANCH ~= "dev" and "profile" or ("profile_"..BRANCH)
end

function PlayerProfile:Save(callback)
    Print( VERBOSITY.DEBUG, "SAVING" )
    if self.dirty then
        local str = json.encode(self.persistdata)
        SavePersistentString(self:GetSaveName(), str, ENCODE_SAVES, callback)
    elseif callback ~= nil then
        callback(true)
    end
end

function PlayerProfile:Load(callback)
    TheSim:GetPersistentString(self:GetSaveName(),
        function(load_success, str)
            self:Set(str, callback)
        end, false)
end

local function GetValueOrDefault( value, default )
	if value ~= nil then
		return value
	else
		return default
	end
end

function PlayerProfile:Set(str, callback)
    if str == nil or string.len(str) <= 0 then
        if callback ~= nil then
            --These are purposely inside the if to prevent infinite recursion
            self:SoftReset()
            self:GetPlayInstance() --force stashing play instance
            callback(false)
        end
    else
        self.dirty = false

        self.persistdata = TrackedAssert("TheSim:GetPersistentString profile",  json.decode, str)

        if self.persistdata.saw_display_adjustment_popup == nil then
            self.persistdata.saw_display_adjustment_popup = false
        end

        if self.persistdata.saw_new_user_popup == nil then
            self.persistdata.saw_new_user_popup = false
        end

        if self.persistdata.saw_new_host_picker == nil then
            self.persistdata.saw_new_host_picker = false
        end

		if self.persistdata.autosave == nil then
		    self.persistdata.autosave = true
		end

        if self.persistdata.install_id == nil then
            self.persistdata.install_id = os.time()
        end

        if self.persistdata.play_instance == nil then
            self.persistdata.play_instance = 0
        end

 	    if USE_SETTINGS_FILE then
			-- Copy over old settings
			if self.persistdata.volume_ambient ~= nil and self.persistdata.volume_sfx ~= nil and self.persistdata.volume_music ~= nil then
				print("Copying audio settings from profile to settings.ini")

				self:SetVolume(self.persistdata.volume_ambient, self.persistdata.volume_sfx, self.persistdata.volume_music)
				self.persistdata.volume_ambient = nil
				self.persistdata.volume_sfx = nil
				self.persistdata.volume_music = nil
				self.dirty = true
			end
		else
		    if self.persistdata.volume_ambient == nil and self.persistdata.volume_sfx == nil and self.persistdata.volume_music == nil then
                self.persistdata.volume_ambient = 7
                self.persistdata.volume_sfx = 7
                self.persistdata.volume_music = 7
                self.persistdata.HUDSize = 5
                self.persistdata.vibration = true
                self.persistdata.showpassword = false
                self.persistdata.movementprediction = true
		    end
		end

		local amb, sfx, music = self:GetVolume()
		Print(VERBOSITY.DEBUG, "volumes", amb, sfx, music )

		TheMixer:SetLevel("set_sfx", sfx / 10)
		TheMixer:SetLevel("set_ambience", amb / 10)
		TheMixer:SetLevel("set_music", music / 10)

		TheInputProxy:EnableVibration(self:GetVibrationEnabled())

		if TheFrontEnd then
			local bloom_enabled = GetValueOrDefault( self.persistdata.bloom, true )
			local distortion_enabled = GetValueOrDefault( self.persistdata.distortion, true )

 	        if USE_SETTINGS_FILE then
				-- Copy over old settings
				if self.persistdata.bloom ~= nil and self.persistdata.distortion ~= nil and self.persistdata.HUDSize ~= nil then
					print("Copying render settings from profile to settings.ini")

					self:SetBloomEnabled(bloom_enabled)
					self:SetDistortionEnabled(distortion_enabled)
					self:SetHUDSize(self.persistdata.HUDSize)
					self.persistdata.bloom = nil
					self.persistdata.distortion = nil
					self.persistdata.HUDSize = nil
					self.dirty = true
				else
					bloom_enabled = self:GetBloomEnabled()
					distortion_enabled = self:GetDistortionEnabled()
				end
			end
			print("bloom_enabled",bloom_enabled)
			TheFrontEnd:GetGraphicsOptions():SetBloomEnabled( bloom_enabled )
			TheFrontEnd:GetGraphicsOptions():SetDistortionEnabled( distortion_enabled )
		end

		-- old save data will not have the controls section so create it
		if nil == self.persistdata.controls then
		    self.persistdata.controls = {}
		end

	    for idx,entry in pairs(self.persistdata.controls) do
	        local enabled = true
			if entry.enabled == nil then
				enabled = false
			else
				enabled = entry.enabled
			end
	        TheInputProxy:LoadControls(entry.guid, entry.data, enabled)
	    end

		if nil == self.persistdata.device_caps_a then
            self.persistdata.device_caps_a = 0
            self.persistdata.device_caps_b = 20
		end

        local upgraded = UpgradeProfilePresets(self.persistdata.customizationpresets)
        if upgraded ~= nil then
            self.persistdata.customizationpresets = upgraded
            self.dirty = true
        end

        self.persistdata.device_caps_a, self.persistdata.device_caps_b = TheSim:UpdateDeviceCaps(self.persistdata.device_caps_a, self.persistdata.device_caps_b)
        self.dirty = true

        if callback ~= nil then
            --purposely inside the if (see above)
            self:GetPlayInstance() --force stashing play instance
            callback(true)
        end
    end
end

function PlayerProfile:SetDirty(dirty)
    self.dirty = dirty
end

function PlayerProfile:GetControls(guid)
    local controls = nil
    local enabled = false
    for idx, entry in pairs(self.persistdata.controls) do
        if entry.guid == guid then
            controls = entry.data
            enabled = entry.enabled
        end
    end
    return controls, enabled
end

function PlayerProfile:SetControls(guid, data, enabled)
	-- check if this device is already in the list and update if found
	local found = false
    for idx, entry in pairs(self.persistdata.controls) do
        if entry.guid == guid then
            entry.data = data
            entry.enabled = enabled
            found = true
        end
    end

    -- not an existing device so add it
    if not found then
        table.insert(self.persistdata.controls, {["guid"]=guid, ["data"]=data, ["enabled"] = enabled})
    end

    self.dirty = true
end

function PlayerProfile:SawDisplayAdjustmentPopup()
    return self.persistdata.saw_display_adjustment_popup
end

function PlayerProfile:ShowedDisplayAdjustmentPopup()
    self.persistdata.saw_display_adjustment_popup = true
	self.dirty = true
end

function PlayerProfile:SawControllerPopup()
    local sawPopup
 	if USE_SETTINGS_FILE then
		sawPopup = TheSim:GetSetting("misc", "controller_popup")
		if nil == sawPopup then
		    sawPopup = false
		end
	else
		sawPopup = self:GetValueOrDefault(self.persistdata.controller_popup, false)
	end

	return sawPopup
end

function PlayerProfile:ShowedControllerPopup()
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("misc", "controller_popup", tostring(true))
	else
		self:SetValue("controller_popup", true)
		self.dirty = true
	end
end

function PlayerProfile:ShouldWarnModsEnabled()
    if USE_SETTINGS_FILE then
 		if TheSim:GetSetting("misc", "warn_mods_enabled") ~= nil then
			return TheSim:GetSetting("misc", "warn_mods_enabled") == "true"
		else
			return true -- Default to true this value hasn't been created yet
		end
	else
		if self:GetValue("warn_mods_enabled") ~= nil then
			return self:GetValue("warn_mods_enabled")
		else
			return true -- Default to true this value hasn't been created yet
		end
	end
end

function PlayerProfile:SetWarnModsEnabled(do_warning)
 	if USE_SETTINGS_FILE then
		TheSim:SetSetting("misc", "warn_mods_enabled", tostring(do_warning))
	else
		self:SetValue("warn_mods_enabled", do_warning)
		self.dirty = true
	end
end

function PlayerProfile:IsEntitlementReceived(entitlement)
	if self:GetValue("entitlement_"..entitlement) ~= nil then
		return self:GetValue("entitlement_"..entitlement)
	else
		return false
	end
end

function PlayerProfile:SetEntitlementReceived(entitlement)
	self:SetValue("entitlement_"..entitlement, true)
	self.dirty = true
end

function PlayerProfile:SawNewUserPopup()
    return self.persistdata.saw_new_user_popup
end

function PlayerProfile:ShowedNewUserPopup()
    if not self.persistdata.saw_new_user_popup then
        self.persistdata.saw_new_user_popup = true
        self.dirty = true
    end
end

function PlayerProfile:SawNewHostPicker()
    return self.persistdata.saw_new_host_picker
end

function PlayerProfile:ShowedNewHostPicker()
    if not self.persistdata.saw_new_host_picker then
        self.persistdata.saw_new_host_picker = true
        self.dirty = true
    end
end

return PlayerProfile
