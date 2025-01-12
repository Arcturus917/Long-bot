game.Workspace.InstanceGame1.Humanoid.HipHeight = 5 -- Your torso
game.Workspace.InstanceGame2.Humanoid.HipHeight = 5 -- Your Second torso
game.Workspace.InstanceGame3.Humanoid.HipHeight = 6 -- Your Head
game.Workspace.InstanceGame4.Humanoid.HipHeight = 5 -- Your Right Arm
game.Workspace.InstanceGame5.Humanoid.HipHeight = 5 -- Your Left Arm

local mechParts = {
	workspace.InstanceGame1, -- Your Torso
	workspace.InstanceGame2, -- Your Second Torso
	workspace.InstanceGame5, -- Your Left Leg
	workspace.InstanceGame4, -- Your Right Leg
	workspace.InstanceGame4, -- Your Right Arm
	workspace.InstanceGame5, -- Your Left Arm
}

local attachments = {
	{redBlock = workspace.InstanceGame1.HumanoidRootPart, blueCube = workspace.InstanceGame3.Torso, offset = CFrame.new(-1, -1, 0)},
	{redBlock = workspace.InstanceGame2.HumanoidRootPart, blueCube = workspace.InstanceGame3.Torso, offset = CFrame.new(1, -1, 0)},
	{redBlock = workspace.InstanceGame5.HumanoidRootPart, blueCube = workspace.InstanceGame3["Left Leg"], offset = CFrame.new(-0.5, -4, 0)},
	{redBlock = workspace.InstanceGame4.HumanoidRootPart, blueCube = workspace.InstanceGame3["Right Leg"], offset = CFrame.new(0.5, -4, 0)},
	{redBlock = workspace.InstanceGame4.HumanoidRootPart, blueCube = workspace.InstanceGame3["Right Arm"], offset = CFrame.new(1.5, -1, 0)},
	{redBlock = workspace.InstanceGame5.HumanoidRootPart, blueCube = workspace.InstanceGame3["Left Arm"], offset = CFrame.new(-1.5, -1, 0)},
}

local function applyZeroGravity()
	for _, mech in ipairs(mechParts) do
		for _, part in ipairs(mech:GetChildren()) do
			if part:IsA("BasePart") then
				local bodyForce = part:FindFirstChild("BodyForce") or Instance.new("BodyForce")
				bodyForce.Force = Vector3.new(0, workspace.Gravity * part:GetMass(), 0)
				bodyForce.Parent = part
			end
		end
	end
end

local function updateAttachments()
	while true do
		for _, attachment in ipairs(attachments) do
			local redBlock = attachment.redBlock
			local blueCube = attachment.blueCube
			local offset = attachment.offset

			if redBlock and blueCube then
				local desiredCFrame = blueCube.CFrame:ToWorldSpace(offset)
				redBlock.CFrame = redBlock.CFrame:Lerp(desiredCFrame, 0.2)
			else
				warn("Failed to attach parts: Missing redBlock or blueCube")
			end
		end
		wait(0.02)
	end
end

local function makeMechFollowHumanoid()
	while true do
		local humanoid = workspace.PartMechTorso:FindFirstChild("Humanoid")
		if humanoid then
			local humanoidRoot = humanoid.Parent:FindFirstChild("HumanoidRootPart")
			if humanoidRoot then
				for _, mechPart in ipairs(mechParts) do
					for _, part in ipairs(mechPart:GetChildren()) do
						if part:IsA("BasePart") then
							part.CFrame = part.CFrame:Lerp(humanoidRoot.CFrame, 0.3)
						end
					end
				end
			end
		end
		wait(0.02)
	end
end

local function flyMechParts()
	while true do
		for _, mech in ipairs(mechParts) do
			for _, part in ipairs(mech:GetChildren()) do
				if part:IsA("BasePart") then
					local bodyVelocity = part:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
					bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
					bodyVelocity.Velocity = Vector3.new(0, 50, 0)
					bodyVelocity.Parent = part

					local bodyGyro = part:FindFirstChild("BodyGyro") or Instance.new("BodyGyro")
					bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
					bodyGyro.CFrame = part.CFrame
					bodyGyro.Parent = part
				end
			end
		end
		wait(0.02)
	end
end

for _, part in ipairs(mechParts) do
	if part:FindFirstChild("Humanoid") then
		part.Humanoid.PlatformStand = true
	end
end

applyZeroGravity()
updateAttachments()
makeMechFollowHumanoid()
flyMechParts()
