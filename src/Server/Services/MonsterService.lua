-- Monster Service
-- Ryan Sorensen
-- October 16, 2024

local MonsterService = {Client = {}}


function MonsterService:Start()
	
    local monster = self.Shared.MonsterClasses.Monster.new(game.ServerStorage.Monster)
    
    local p = game.Players:GetPlayers()
    if #p > 0 then
        monster:InformClient(p[1])
        --self:FireClient('newMonster', p[1])
    else
        local a = game.Players.PlayerAdded:Wait()
        --self:FireClient("newMonster")
        monster:InformClient(a)
        warn(a)
        self:FireClient('newMonster', a, "Monster", nil)
    end


end


function MonsterService:Init()
	--Lets clients know about a new monster
    self:RegisterClientEvent("newMonster")
end


return MonsterService