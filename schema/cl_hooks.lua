
-- Here is where all of your clientside hooks should go.

local f6WasDown = false

hook.Add("Think", "SchemaThirdPersonToggle", function()
	local f6IsDown = input.IsKeyDown(KEY_F6)

	if (f6IsDown and !f6WasDown and !IsValid(vgui.GetKeyboardFocus())) then
		local client = LocalPlayer()
		local current = false

		if (IsValid(client) and isfunction(client.GetViewMode)) then
			current = client:GetViewMode() == "thirdperson"
		elseif (ix and ix.option and ix.option.Get) then
			current = ix.option.Get("thirdPerson", false)
		end

		local desired = !current
		Schema:SaveThirdPersonState(desired)

		if (IsValid(client) and isfunction(client.SetViewMode)) then
			client:SetViewMode("firstperson")
			timer.Simple(0.05, function()
				if (!IsValid(client)) then
					return
				end

				local restored = Schema:LoadThirdPersonState()
				client:SetViewMode(restored and "thirdperson" or "firstperson")
			end)
		elseif (ix and ix.option and ix.option.Set) then
			ix.option.Set("thirdPerson", desired)
		end
	end

	f6WasDown = f6IsDown
end)

-- Disables the crosshair permanently.
function Schema:CharacterLoaded(character)
	self:ExampleFunction("@serverWelcome", character:GetName())
end
