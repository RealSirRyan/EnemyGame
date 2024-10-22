-- Monster
-- Ryan Sorensen
-- October 16, 2024

local Monster = {}
Monster.__index = Monster


local RS = game:getService("RunService")


function Monster.new(modelTemplate)
    local self = setmetatable({}, Monster)

	self.target = nil
	self.destination = nil
	self.state = "idle"


	local model_template = modelTemplate:Clone()

	--seed
	self.seed = math.random(0, 20000)

	--Setting up the model
	self.model = Instance.new("Model")
	self.humanoid = model_template.Humanoid:Clone()
	self.primary = model_template.PrimaryPart:Clone()

	self.primary:ClearAllChildren()
	self.humanoid:ClearAllChildren()

	self.humanoid.Parent = self.model
	self.primary.Parent = self.model
	self.model.PrimaryPart = self.primary

	self.primary.Transparency = 0

	--Disabling unneeded humanoid states
	self.humanoid:SetStateEnabled(0, false)--Falling
	self.humanoid:SetStateEnabled(1, false)--Ragdoll
	self.humanoid:SetStateEnabled(2, false)--Getting Up
	self.humanoid:SetStateEnabled(3, false)--Jumping
	self.humanoid:SetStateEnabled(4, false)--Swimming
	self.humanoid:SetStateEnabled(5, false)--Freefall
	self.humanoid:SetStateEnabled(6, false)--Flying
	self.humanoid:SetStateEnabled(7, false)--Landed
	self.humanoid:SetStateEnabled(8, true)--Running
	self.humanoid:SetStateEnabled(10, true)--Running No Physics
	self.humanoid:SetStateEnabled(11, false)--Strafing No Physics
	self.humanoid:SetStateEnabled(12, false)--Climbing
	self.humanoid:SetStateEnabled(13, false)--Seated
	self.humanoid:SetStateEnabled(14, false)--Platform Standing (Freefalling & cannot move)
	self.humanoid:SetStateEnabled(15, false)--Dead
	self.humanoid:SetStateEnabled(16, false)--Physics (Humanoid applies no force on its own)

    return self
end

--Run by the client
function Monster.Client(model, model_variant, seed)
	warn("The Client is working")

	model.PrimaryPart.Transparency = 1
	
	local visual_model = get_character(model_variant)
	
	for _, v in pairs (visual_model:GetChildren()) do
		
		if v.Name == "Humanoid" or v.Name == "HumanoidRootPart" then
			--This object already exists in the model
			
			--Add children to the existing object
			for _, vv in pairs (v:GetChildren()) do
				vv:Clone().Parent = model[v.Name]
			end 

		else
			v:Clone().Parent = model
		end
		
	end

	--Setting Motor6Ds

	for _, v in pairs (model:GetDescendants()) do
		
		if v:IsA("Motor6D") then
			v.Part0 = model:FindFirstChild(v.Part0.Name)
			v.Part1 = model:FindFirstChild(v.Part1.Name)
		end
	end

	--Adding motor6d
	for _, child in pairs (visual_model.Torso:GetChildren()) do
		if child:IsA("Motor6D") then
			child:Clone().Parent = model
		end
	end




	model.Head.face.Texture = faces[math.random(1, #faces)]

	local skin_colour = Color3.new(0.356862, 0.498039, 0.396078)
	local body_colours = model['Body Colors']
	body_colours.HeadColor3 = skin_colour
	body_colours.LeftArmColor3 = skin_colour
	body_colours.LeftLegColor3 = skin_colour
	body_colours.RightArmColor3 = skin_colour
	body_colours.RightLegColor3 = skin_colour
	body_colours.TorsoColor3 = skin_colour


	--Equipping cosmetics
	local rng = Random.new(seed)
	for _, slot in pairs (self.variants[model_variant]) do
		--Choosing a random item
		local item = slot[rng:NextInteger(1, #slot)]
		if item then
			print(item)
			
			
			local acc = get_accessory(item):Clone()	
			if acc:IsA("Accessory") then
				
				local base_part = acc:WaitForChild("Handle")
				
				
				--Looking for the part this has to weld to
				local acc_attachment = base_part:FindFirstChildOfClass("Attachment", true)
				local character_attachment = model:FindFirstChild(acc_attachment.Name, true)

				local weld = Instance.new("RigidConstraint", character_attachment.Parent)
				weld.Attachment0 = acc_attachment
				weld.Attachment1 = character_attachment
				--weld.Part0 = character_attachment.Parent
				--weld.Part1 = base_part
				--weld.C1 = CFrame.new(character_attachment.WorldCFrame.Position-acc_attachment.WorldCFrame.Position)

			end
			
			acc.Parent = model
			

		end
		
	end

end


--Lets the client know of a new monster that has been created.
function Monster:InformClient(client)
    --self:FireClient('newMonster', client)
end






return Monster