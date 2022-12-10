--gamemode functions
function GM:HUDPaint()
	hook.Run("HUDDrawTargetID")
	hook.Run("HUDDrawPickupHistory")
end