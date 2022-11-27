--gamemode functions
function GM:AllowPlayerPickup(ply, entity) if entity.IsPhasmophobiaItem then return false end end