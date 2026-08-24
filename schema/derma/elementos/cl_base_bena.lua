--[[
##################################################################################
	© 2023-2026 Bena (https://discord.com/invite/axhEYdVd9A)
	Creado para la comunidad G.E.N.O.S, quien tiene derechos de su uso.
##################################################################################
--]]

local PANEL = {}
PANEL.ANIM_DESLIZAMIENTO = 0.5
PANEL.ANIM_ALPHA = 0.25
local Color = Color
local timer = timer
local surface = surface
local draw = draw
local vgui = vgui
local isstring = isstring
local isfunction = isfunction

-- Funciones para elementos frecuentes
function PANEL:Contenedor(bScroll, padre)
	local contenedor =  padre and padre:Add(bScroll and "DScrollPanel" or "DPanel") or self:Add(bScroll and "DScrollPanel" or "DPanel")
	contenedor:Dock(FILL)
	contenedor:DockMargin(0,0,0,10)
	contenedor.Paint = function() return end

	-- Si hay scroll se establece el diseño del scrollbar
	if (bScroll) then
		local navBar = contenedor:GetVBar()
		navBar.Paint = function(_, w, h)
			draw.RoundedBox(15, 0, 0, w * 0.5, h, Color(59,56,88,58))
		end

		navBar.btnGrip.Paint = function(_, w, h)
			draw.RoundedBox(15, 0, 0, w * 0.5, h, Color(106,101,153,58))
		end
	end

	return contenedor
end

function PANEL:Div(padre)
	local div = padre and padre:Add("DPanel") or self:Add("DPanel")
	div:Dock(TOP)
	div.Paint = function(this, w, h)
		surface.DrawRect(0, 0, this:GetWide(), 1)
	end

	return div
end

function PANEL:DivAlternativo(padre)
	local div = padre and padre:Add("DPanel") or self:Add("DPanel")
	div:Dock(TOP)
	div.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, 1, color_white)
	end
end

function PANEL:AnimacionCierre(waitTime, callback)
	waitTime = waitTime or 5

	timer.Simple(waitTime, function()
		if (!self or !self:IsValid()) then return end
		self:CreateAnimation(self.ANIM_DESLIZAMIENTO, {
			target = {posX = 1.3},
			easing = "inCirc",
			Think = function(_, panel)
				panel:SetX(ScrW() * panel.posX)
			end,
			OnComplete = function(_, panel)

				if (callback and isfunction(callback)) then
					callback()
				end

				panel:Remove()
			end
		})
	end)
end

function PANEL:CrearBoton(parent, texto, color, strFuente)
	local botonContainer = parent:Add("DPanel")
	botonContainer:Dock(TOP)
	botonContainer:DockMargin(10, 10, 10, 0)
	botonContainer:SetTall(30)
	botonContainer.Paint = function() return end

	local boton = botonContainer:Add("DButton")
	boton:Dock(FILL)
	boton:SetText(texto)
	boton:SetFont(strFuente)
	boton:SetContentAlignment(5)
	boton:SizeToContents()
	boton.Paint = function(this, w, h)
		draw.RoundedBox(5,0,0,w,h,color)
	end
	return botonContainer, boton
end

function PANEL:BotonSimple(parent, texto, color, strFuente)
	local boton = parent:Add("DButton")
	boton:Dock(FILL)
	boton:SetText(texto)
	boton:SetFont(strFuente)
	boton:SetContentAlignment(5)
	boton:SizeToContents()
	boton.Paint = function(this, w, h)
		draw.RoundedBox(5,0,0,w,h,color)
	end
	return boton

end
-- DERMA

function PANEL:Init()
	self:SetSize(ScrW() * 0.22, ScrH() * 0.6)
	self:Center()
	self:SetTitle("")
	self:SetDraggable(true)
	self:MakePopup()

	self.Paint = function(_, w, h)
		draw.RoundedBox(15,0,0,w,h, Color(29,29,41))
	end
end


function PANEL:Rellenar(args)
	self.tituloLbl = self:Add("DLabel")
	self.tituloLbl:Dock(TOP)
	self.tituloLbl:SetText(isstring(self.titulo) and self.titulo or "Menú")
	self.tituloLbl:SetFont("gnsFuenteSubMenu")
	self.tituloLbl:SizeToContents()
	self.tituloLbl:SetContentAlignment(5)
	self.tituloLbl.Paint = function() return end

	self.divisorTitulo = self:Div()

	-- Función para modificar alguno de los valores de arriba (tamaño)
	if (self.PostInit and isfunction(self.PostInit)) then
		self:PostInit()
	end

	-- Función en estableceremos la forma en la que se mostrará el menú (animaciones)
	if (self.Muestreo and isfunction(self.Muestreo)) then
		self:Muestreo()
	end

	if (self.Contenido and isfunction(self.Contenido)) then
		self:Contenido(#args > 0 and args)
	end

end
vgui.Register("gnsBenaBase", PANEL, "DFrame")