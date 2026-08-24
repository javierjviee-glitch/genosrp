

if (spawnmenu and spawnmenu.AddCreationTab) then
	spawnmenu.AddCreationTab("Items Helix", function()
		local panel = vgui.Create("DScrollPanel")
		local items = {}

		for uniqueID, item in pairs(ix.item.list or {}) do
			items[#items + 1] = {
				uniqueID = uniqueID,
				name = item.name or uniqueID,
				description = item.description or ""
			}
		end

		table.sort(items, function(first, second)
			return string.lower(first.name) < string.lower(second.name)
		end)

		for _, item in ipairs(items) do
			local button = panel:Add("DButton")
			button:Dock(TOP)
			button:DockMargin(8, 8, 8, 0)
			button:SetTall(42)
			button:SetText(item.name .. "  [" .. item.uniqueID .. "]")
			button:SetToolTip(item.description)
			button.DoClick = function()
				net.Start("SchemaGiveHelixItem")
				net.WriteString(item.uniqueID)
				net.SendToServer()
			end
		end

		return panel
	end, "icon16/box.png", 100)
end

local function GetThirdPersonEnabled()
	local client = LocalPlayer()

	if (IsValid(client) and isfunction(client.GetViewMode)) then
		return client:GetViewMode() == "thirdperson"
	end

	if (ix and ix.option and ix.option.Get) then
		return ix.option.Get("thirdPerson", false)
	end

	return false
end

local function SetThirdPersonEnabled(enabled)
	local client = LocalPlayer()

	if (IsValid(client) and isfunction(client.SetViewMode)) then
		client:SetViewMode(enabled and "thirdperson" or "firstperson")
		return
	end

	if (ix and ix.option and ix.option.Set) then
		ix.option.Set("thirdPerson", enabled)
	end
end

if (ix and ix.option and ix.option.Add) then
	ix.option.Add("thirdPerson", ix.type.bool, false, {
		category = "appearance"
	})
end

local thirdPersonDistance = 100
local thirdPersonHeight = 12
local thirdPersonStateFile = "thirsperson.lua"

function Schema:LoadThirdPersonState()
	local data = file.Read(thirdPersonStateFile, "DATA")

	if (data == "true" or data == "1") then
		return true
	end

	if (data == "false" or data == "0") then
		return false
	end

	return false
end

function Schema:SaveThirdPersonState(enabled)
	if (file and file.Write) then
		file.Write(thirdPersonStateFile, enabled and "true" or "false")
	end
end

local function ForceFirstPerson()
	local client = LocalPlayer()

	if (!IsValid(client) or !isfunction(client.GetViewMode)) then
		return false
	end

	local enabled = client:GetViewMode() == "thirdperson"
	self:SaveThirdPersonState(enabled)
	client:SetViewMode("firstperson")

	return enabled
end

local function RestoreThirdPersonState()
	local client = LocalPlayer()

	if (!IsValid(client) or !isfunction(client.SetViewMode)) then
		return false
	end

	local enabled = self:LoadThirdPersonState()
	client:SetViewMode(enabled and "thirdperson" or "firstperson")

	return enabled
end

hook.Add("CalcView", "SchemaThirdPersonCamera", function(client, origin, angles, fov)
	if (!GetThirdPersonEnabled() or !IsValid(client) or !client:Alive()
		or IsValid(ix.gui.characterMenu)) then
		return
	end

	local view = {}
	local direction = angles:Forward()
	local target = origin - direction * thirdPersonDistance + Vector(0, 0, thirdPersonHeight)
	local trace = util.TraceHull({
		start = origin + Vector(0, 0, thirdPersonHeight),
		endpos = target,
		mins = Vector(-4, -4, -4),
		maxs = Vector(4, 4, 4),
		filter = client
	})

	view.origin = trace.Hit and trace.HitPos + trace.HitNormal * 6 or target
	view.angles = angles
	view.fov = fov
	view.drawviewer = true

	return view
end)

hook.Add("ShouldDrawLocalPlayer", "SchemaThirdPersonDrawPlayer", function()
	return GetThirdPersonEnabled()
end)

-- Example client function that will print to the chatbox.
function Schema:ExampleFunction(text, ...)
	if (text:sub(1, 1) == "@") then
		text = L(text:sub(2), ...)
	end

	LocalPlayer():ChatPrint(text)
end
