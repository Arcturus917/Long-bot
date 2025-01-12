-- You need 7 alts for this
-- replace the YourAltRobloxUsernameTorso, YourAltRobloxUsernameSecondTorso, YourAltRobloxUsernameHead, YourAltRobloxUsernameRightArm, YourAltRobloxUsernameLeftArm, YourAltRobloxUsernameRightLeg, YourAltRobloxUsernameLeftLeg to your alt accounts.


game.Workspace.YourAltRobloxUsernameTorso.Humanoid.HipHeight = 5 -- Your torso
game.Workspace.YourAltRobloxUsernameSecondTorso.Humanoid.HipHeight = 5 -- Your Second torso
game.Workspace.YourAltRobloxUsernameHead.Humanoid.HipHeight = 6 -- Your Head
game.Workspace.YourAltRobloxUsernameRightArm.Humanoid.HipHeight = 5 -- Your Right Arm
game.Workspace.YourAltRobloxUsernameLeftArm.Humanoid.HipHeight = 5 -- Your Left Arm

local mechParts = {
	workspace.YourAltRobloxUsernameTorso, -- Your Torso
	workspace.YourAltRobloxUsernameSecondTorso, -- Your Second Torso
	workspace.YourAltRobloxUsernameLeftLeg, -- Your Left Leg
	workspace.YourAltRobloxUsernameRightLeg, -- Your Right Leg
	workspace.YourAltRobloxUsernameRightArm, -- Your Right Arm
	workspace.YourAltRobloxUsernameLeftArm, -- Your Left Arm
}

local attachments = {
	{redBlock = workspace.YourAltRobloxUsernameTorso.HumanoidRootPart, blueCube = workspace.YourAltRobloxUsernameHead.Torso, offset = CFrame.new(-1, -1, 0)},
	{redBlock = workspace.YourAltRobloxUsernameSecondTorso.HumanoidRootPart, blueCube = workspace.YourAltRobloxUsernameHead.Torso, offset = CFrame.new(1, -1, 0)},
	{redBlock = workspace.YourAltRobloxUsernameLeftLeg.HumanoidRootPart, blueCube = workspace.YourAltRobloxUsernameHead["Left Leg"], offset = CFrame.new(-0.5, -4, 0)},
	{redBlock = workspace.YourAltRobloxUsernameRightLeg.HumanoidRootPart, blueCube = workspace.YourAltRobloxUsernameHead["Right Leg"], offset = CFrame.new(0.5, -4, 0)},
	{redBlock = workspace.YourAltRobloxUsernameRightArm.HumanoidRootPart, blueCube = workspace.YourAltRobloxUsernameHead["Right Arm"], offset = CFrame.new(1.5, -1, 0)},
	{redBlock = workspace.YourAltRobloxUsernameLeftArm.HumanoidRootPart, blueCube = workspace.YourAltRobloxUsernameHead["Left Arm"], offset = CFrame.new(-1.5, -1, 0)},
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
