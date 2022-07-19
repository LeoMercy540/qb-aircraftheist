local QBCore = exports['qb-core']:GetCoreObject()

local boxes = { 388384482}

------ Events

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('qb-aircraft:Cooldownheist')
AddEventHandler('qb-aircraft:Cooldownheist', function(cooldown)
end)


RegisterNetEvent('qb-aircraft:client:getjob', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"wait"})
    QBCore.Functions.Progressbar('name_here', 'Talking to the boss...', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify('You will recive an email with the location of the lab, the go there and start the hack! <br> Take it you will need this!', 'primary')
        SetNewWaypoint(Config.aircraft)
        TriggerServerEvent('QBCore:Server:AddItem', "electronickit", 1)
        Wait(5000)
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = 'Boss',
            subject = 'Human Labs...',
            message = 'You recive the location, now go there and rob the informations for me and i will pay you good!',
            })
    end)
end)



RegisterNetEvent('qb-aircraft:client:starthack', function()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerServerEvent('QBCore:Server:RemoveItem', "electronickit", 1)
            TriggerServerEvent('police:server:policeAlert', 'LABS ROBBERY IN COURSE!')
            TriggerEvent('animations:client:EmoteCommandStart', {"type"})
            QBCore.Functions.Progressbar('cnct_elect', 'CONNECTING ELECTONICS...', 7500, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
            end)
            Wait(7500)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports["memorygame_2"]:thermiteminigame(2, 2, 2, 10,
    function() -- Success
        Wait(100)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        Wait(500)
        QBCore.Functions.Progressbar('po_usb', 'PULLING OUT USB..', 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(5000)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent('QBCore:Server:AddItem', "labs_usb", 1)
        SpawnGuards()
        QBCore.Functions.Notify('You recive an USB <br> Now RUN from the guards or just kill them! And Dont Forget to check the boxes', 'primary')
        Wait(7500)
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = 'Boss',
            subject = 'Human Labs...',
            message = 'I recive some informations that you got what i want, now come here to me and give me it!',
            })
    end,
        function() -- Fail thermite game
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            QBCore.Functions.Notify('You failed Hacking', 'error')
        end)
    else
        QBCore.Functions.Notify('You are missing something', 'error')
    end

    end, "electronickit")
end)

RegisterNetEvent('qb-aircraft:client:EnterUSB', function()
    TriggerServerEvent('QBCore:Server:RemoveItem', "labs_usb", 1)
    TriggerServerEvent('qb-aircraft:server:RecievePayment')
end)




RegisterNetEvent('qb-aircraftheist-collect') -- PEW PEW 
AddEventHandler('qb-aircraftheist-collect', function()
    if not robberyBusy then
        TriggerServerEvent("qb-aircraftheist:server:loot")
        robberyBusy = true
    else
       QBCore.Functions.Notify("Empty.", 'error')
    end
end)


CreateThread(function()
    RequestModel(`g_m_m_armboss_01`)
      while not HasModelLoaded(`g_m_m_armboss_01`) do
      Wait(1)
    end
      labboss = CreatePed(2, `g_m_m_armboss_01`, 632.72, -3015.35, 6.34, 3.39, false, false) -- change here the cords for the ped 
      SetPedFleeAttributes(labboss, 0, 0)
      SetPedDiesWhenInjured(labboss, false)
      TaskStartScenarioInPlace(labboss, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
      SetPedKeepTask(labboss, true)
      SetBlockingOfNonTemporaryEvents(labboss, true)
      SetEntityInvincible(labboss, true)
      FreezeEntityPosition(labboss, true)
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("human-boss", vector3(632.72, -3015.35, 6.34), 1, 1, {
        name="human-boss",
        heading=3.39,
        debugpoly = false,
    }, {
        options = {
            {
                event = "qb-aircraft:client:getjob",
                icon = "far fa-phone",
                label = "Request Job",
                item = "phone",
            },
            {
                event = "qb-aircraft:client:EnterUSB",
                icon = "far fa-phone",
                label = "Recive Payment",
                item = "labs_usb",
            },
        },
        distance = 1.5
    })
        
    exports['qb-target']:AddBoxZone("Hack-aircraft", vector3(3084.24, -4685.79, 26.95), 1, 1, {
        name="Hack-aircraft",
        heading=25.0,
        debugpoly = false,
    }, {
        options = {
            {
            event = "qb-aircraft:client:starthack",
            icon = "far fa-usb",
            label = "Hack System",
            item = "electronickit",
            },
        },
        distance = 1.5
    })
end)


---- Funções

labguards = {
    ['npcguards'] = {}
}

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

function SpawnGuards()
    local ped = PlayerPedId()

    SetPedRelationshipGroupHash(ped, `PLAYER`)
    AddRelationshipGroup('npcguards')

    for k, v in pairs(Config['labguards']['npcguards']) do
        loadModel(v['model'])
        labguards['npcguards'][k] = CreatePed(26, GetHashKey(v['model']), v['coords'], v['heading'], true, true)
        NetworkRegisterEntityAsNetworked(labguards['npcguards'][k])
        networkID = NetworkGetNetworkIdFromEntity(labguards['npcguards'][k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(labguards['npcguards'][k], 0)
        SetPedRandomProps(labguards['npcguards'][k])
        SetEntityAsMissionEntity(labguards['npcguards'][k])
        SetEntityVisible(labguards['npcguards'][k], true)
        SetPedRelationshipGroupHash(labguards['npcguards'][k], `npcguards`)
        SetPedAccuracy(labguards['npcguards'][k], 75)
        SetPedArmour(labguards['npcguards'][k], 100)
        SetPedCanSwitchWeapon(labguards['npcguards'][k], true)
        SetPedDropsWeaponsWhenDead(labguards['npcguards'][k], false)
        SetPedFleeAttributes(labguards['npcguards'][k], 0, false)
        GiveWeaponToPed(labguards['npcguards'][k], `WEAPON_PISTOL`, 255, false, false)
        TaskGoToEntity(labguards['npcguards'][k], PlayerPedId(), -1, 1.0, 10.0, 1073741824.0, 0)
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(labguards['npcguards'][k], 10.0, 10.0, 1)
        end
    end

    SetRelationshipBetweenGroups(0, `npcguards`, `npcguards`)
    SetRelationshipBetweenGroups(5, `npcguards`, `PLAYER`)
    SetRelationshipBetweenGroups(5, `PLAYER`, `npcguards`)
end


