local QBCore = exports['qb-core']:GetCoreObject()

--- Events

RegisterNetEvent('qb-aircraft:server:RecievePayment', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('bank', Config.PaymentMoney)
end)

RegisterServerEvent('qb-aircraft:server:givesearchReward')
AddEventHandler('qb-aircraft:server:givesearchReward', function()
    local Player = QBCore.Functions.GetPlayer(source) 
    local randomItem = Config.Items[math.random(1, #Config.Items)]
    if Player.Functions.AddItem(randomItem, 1) then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[randomItem], "add")
    else
        TriggerClientEvent("QBCore:Notify", source, "You dont have enough space", "error")
    end
end)

local ItemTable = {
    "weapon_combatpistol",
    "weapon_assaultrifle",
    "weapon_smg",
    "security_card_01",
    "heavyarmor",
    "drill",
    "lockpick",
    "advancedlockpick",
}

RegisterServerEvent("qb-aircraftheist:server:loot")
AddEventHandler("qb-aircraftheist:server:loot", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for i = 1, math.random(1, 8), 1 do
        local randItem = ItemTable[math.random(1, #ItemTable)]
        Player.Functions.AddItem(randItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add')
        Citizen.Wait(500)
    end
end)	

