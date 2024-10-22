-- Monster Controller
-- Ryan Sorensen
-- October 16, 2024



local MonsterController = {}


function MonsterController:Start()
	
end


function MonsterController:Init()
	self.Services.MonsterService['newMonster']:Connect(function(className, model, ...)
        warn(className)
        warn(model)
        self.Shared.MonsterClasses[className].Client(model, ...)
    end)
end


return MonsterController