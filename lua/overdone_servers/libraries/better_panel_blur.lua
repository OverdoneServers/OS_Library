--Pulled from /garrysmod/lua/derma/derma_utils.lua

local matBlurScreen = Material( "pp/blurscreen" )

--[[function Derma_DrawBackgroundBlur( panel, starttime )

	local Fraction = 1

	if ( starttime ) then
		Fraction = math.Clamp( (SysTime() - starttime) / 1, 0, 1 )
	end

	local x, y = panel:LocalToScreen( 0, 0 )

	local wasEnabled = DisableClipping( true )

	-- Menu cannot do blur
	if ( !MENU_DLL ) then
		surface.SetMaterial( matBlurScreen )
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i=0.33, 1, 0.33 do
			matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
			matBlurScreen:Recompute()
			if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
		end
	end

	surface.SetDrawColor( 10, 10, 10, 200 * Fraction )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )

	DisableClipping( wasEnabled )

end]]