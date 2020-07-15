OverdoneServers.M2D = {}
function OverdoneServers.M2D.OutlinedBox(thickness, x, y, w, h, color)
	surface.SetDrawColor(color)
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
	end
end