local QRCore = exports['qr-core']:GetCoreObject()
local Player = QRCore.Functions.GetPlayerData()
local sleep = false
local looting = false

CreateThread(function()
    while true do
        Wait(0)
        local pedcoords = GetEntityCoords(PlayerPedId())
        local peds = GetGamePool('CPed')
        if not looting then sleep = true end
        for _, v in pairs(peds) do
            local type = GetPedType(v)
            local dead = IsEntityDead(v)
            local deadCoords = GetEntityCoords(v)
            if dead and #(deadCoords - pedcoords) <= 5 and not IsPedAPlayer(v) then -- Check Distance, Dead, and if not a Player
                local lootedcheck = Citizen.InvokeNative(0x8DE41E9902E85756, v)
                if not lootedcheck and type == 4 then
                    if #(deadCoords - pedcoords) <= 1.0 and not looting then -- Smaller Distance Check, and if not Looting
                        sleep = false
                        local netID = PedToNet(v)
                        if IsControlJustReleased(0, QRCore.Shared.Keybinds['E']) then
                            looting = true
                            TriggerServerEvent('xtr-looting:server:LootBody', netID) -- Sends NetID for Server Distance Check
                            Citizen.InvokeNative(0x6BCF5F3D8FFE988D, v, true) -- Set Fully Looted
                            looting = false
                        end
                    end
                end
            end
        end
        if sleep then Wait(500) end -- Sleep if not near peds
    end
end)
