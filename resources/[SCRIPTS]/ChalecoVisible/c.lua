Armor = {}
Armor.__index = Armor

function Armor:create()
    local instance = {}
    setmetatable(instance, Armor)
    if instance:constructor() then
        return instance
    end
    return false
end

function Armor:constructor()
    self.alpha = false
    self.armorCreated = false

    self.func = {}
    self.func.update = function() self:update() end

    setTimer(self.func.update, 1000, 0)
    return true
end

function Armor:update()
    local armor = getPedArmor(localPlayer)
    if not self.armorCreated and armor > 0 then
        self.armorCreated = true
        local characterDuty = getElementData(localPlayer, "characterDuty")
        if not characterDuty then
            triggerServerEvent("createArmorCustom", resourceRoot, true)
        end
    elseif self.armorCreated and armor < 1 then
        triggerServerEvent("createArmorCustom", resourceRoot)
        self.armorCreated = nil
    end
    
    if self.armorCreated then
        local isAdmin = getElementData(localPlayer, "adminDuty")
        if self.alpha and not isAdmin then
            self.alpha = nil
            triggerServerEvent("setArmorCustomAlpha", resourceRoot, 255)
        elseif not self.alpha and isAdmin then
            self.alpha = true
            triggerServerEvent("setArmorCustomAlpha", resourceRoot, 0)
        end
    end
end

Armor:create()

local txd = engineLoadTXD("files/colete.p.txd")
engineImportTXD(txd, 1242)
local dff = engineLoadDFF("files/colete.p.dff")
engineReplaceModel(dff, 1242)