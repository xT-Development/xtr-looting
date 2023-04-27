local QRCore = exports['qr-core']:GetCoreObject()
local sleep = false
local looting = false

local function LootingThread()
    if not Config.BaseEvents then
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
                    if dead and #(deadCoords - pedcoords) <= 10 and not IsPedAPlayer(v) then -- Check Distance, Dead, and if not a Player
                        local lootedcheck = Citizen.InvokeNative(0x8DE41E9902E85756, v)
                        if not lootedcheck and type == 4 then
                            sleep = false
                            if #(deadCoords - pedcoords) <= 1.0 and not looting then -- Smaller Distance Check, and if not Looting
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
    else
        AddEventHandler('events:listener', function(name, _)
            if name == 'EVENT_LOOT_COMPLETE' then
                local pedcoords = GetEntityCoords(PlayerPedId())
                local closestPed, distance = QRCore.Functions.GetClosestPed(pedcoords)
                local netID = PedToNet(closestPed)
                if distance > 3 then return end
                TriggerServerEvent('xtr-looting:server:LootBody', netID) -- Sends NetID for Server Distance Check
                    Citizen.InvokeNative(0x6BCF5F3D8FFE988D, closestPed, true) -- Set Fully Looted
            end
        end)
    end
end

RegisterNetEvent('QRCore:Client:OnPlayerLoaded', function() LootingThread() end)
AddEventHandler('onResourceStart', function(resource) if resource == GetCurrentResourceName() then LootingThread() end end)
