local QRCore = exports['qr-core']:GetCoreObject()
local sharedItems = QRCore.Shared.Items

-- Loot Body ---
RegisterNetEvent('xtr-looting:server:LootBody', function(netID)
    local src = source
    local Player = QRCore.Functions.GetPlayer(src)
    local callback = false
    if not Player then return end

    -- Check distance between player and NetID of ped --
    local DeadEntity = NetworkGetEntityFromNetworkId(netID)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(src))
    local DeadCoords = GetEntityCoords(DeadEntity)
    local dist = #(PlayerCoords - DeadCoords)
    if dist > 5 then return end

    -- Random Item Chance / Money Amount --
    local randomChance = math.random(1, 100)
    local moneyAmount = math.random(Config.Money.min, Config.Money.max) / 100

    if Player.Functions.AddMoney('cash', moneyAmount) then -- Add Money
        if randomChance <= Config.ItemChance then -- Random Chance to Get Items
            local randomItems = math.random(1, #Config.Items)
            local itemCount = 0
            for x = 1, #Config.Items[randomItems] do
                local itemInfo = Config.Items[randomItems][x]
                if Player.Functions.AddItem(itemInfo.item, itemInfo.amount) then -- Get Items
                    TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[itemInfo.item], 'add', itemInfo.amount)
                    itemCount = itemCount + 1
                    if itemCount == #Config.Items[randomItems] then break end
                end
            end
        end
    end
end)