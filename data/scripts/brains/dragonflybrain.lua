require "behaviours/chaseandattack"
require "behaviours/leash"
require "behaviours/wander"
require "behaviours/doaction"

local DragonflyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function HomePoint(inst)
    return inst.components.knownlocations:GetLocation("spawnpoint")
end

local function ShouldResetFight(self)
    if not self.inst.reset then
        if self.inst:GetDistanceSqToPoint(self.inst.components.knownlocations:GetLocation("spawnpoint")) >= TUNING.DRAGONFLY_RESET_DIST * TUNING.DRAGONFLY_RESET_DIST then
            self.inst.reset = true
            self.inst:Reset()
        else
            self.resetting = nil
        end
    end
    self.inst.sg.mem.flyover = self.inst.reset
    return self.inst.reset
end

local function ShouldRetryReset(self)
    if self.resetting then
        local action = self.inst:GetBufferedAction()
        return action == nil or action.action ~= ACTIONS.GOHOME
    end
    self.resetting = true
    return false
end

local function GoHome(inst)
    return BufferedAction(inst, nil, ACTIONS.GOHOME)
end

local function ShouldSpawnFn(self)
    if self.inst.components.rampingspawner:GetCurrentWave() <= 0 then
        self._spawnpos = nil
    elseif self._spawnpos == nil then
        local pos = self.inst.components.knownlocations:GetLocation("spawnpoint")
        local lavae_ponds = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING.DRAGONFLY_RESET_DIST, { "lava" })
        local target = #lavae_ponds > 0 and lavae_ponds[math.random(#lavae_ponds)] or self.inst
        self._spawnpos = target:GetPosition()
    end
    self.inst.sg.mem.flyover = self._spawnpos ~= nil
    return self.inst.sg.mem.flyover
end

function DragonflyBrain:OnSpawnLavae()
    self._spawnpos = nil
    self.inst.components.rampingspawner:SpawnEntity()
end

function DragonflyBrain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode(function() return ShouldResetFight(self) end, "Reset Fight",
                PriorityNode({
                    WhileNode(function() return ShouldRetryReset(self) end, "Retry Reset", ActionNode(function() end)),
                    DoAction(self.inst, GoHome),
                }, .25)),
            WhileNode(function() return ShouldSpawnFn(self) end, "Spawn Lavae",
                PriorityNode({
                    Leash(self.inst, function() return self._spawnpos end, 5, 5),
                    ActionNode(function() self.inst:PushEvent("spawnlavae") end),
                }, .25)),
            ChaseAndAttack(self.inst),
            Leash(self.inst, HomePoint, 20, 10),
            Wander(self.inst, HomePoint, 15)
        }, .25)
    self.bt = BT(self.inst, root)
end

function DragonflyBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", self.inst:GetPosition())
end

return DragonflyBrain
