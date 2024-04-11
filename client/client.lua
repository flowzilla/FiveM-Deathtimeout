ESX = exports["es_extended"]:getSharedObject()
local isInTimeout = false
local initialCheckDone = false
local wasDead = false
local playerped = PlayerPedId()
local commandName = ""
local time = 0
local timefrocfg = 0
local loaded = false
local useLegacy = false
local sharedObject = ""
local timeoutCleared = false
local active = false
Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(0)
    end
    TriggerServerEvent("loadCode")
end)

RegisterNetEvent('sendCodew')
AddEventHandler('sendCodew', function(commandNamee, timee, useleg, sharedobject)
    commandName = commandNamee
    time = timee
    timefrocfg = timee
    useLegacy = useleg
    sharedObject = sharedobject
    RegisterCommand(commandName, function(source, args, rawCommand)
        TriggerServerEvent("clear:deathtimeout", args)
    end)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if useLegacy then
            ESX = exports["es_extended"]:getSharedObject()
        else
            TriggerEvent(sharedObject, function(obj)
                ESX = obj
            end)
        end
        break
    end
end)

AddEventHandler('esx:onPlayerSpawn', function()
    local i = 0
    loaded = true
    if not initialCheckDone then
        initialCheckDone = true
        ESX.TriggerServerCallback('fs:getstatus', function(shouldActive)
            if tonumber(shouldActive) == 1 then
                print("")
            else
                print("")
            end
            Citizen.Wait(1000)
            ESX.TriggerServerCallback('fs:getstatus', function(shouldActive)
                if tonumber(shouldActive) == 1 then
                    hasleft = true
                    wasDead = false
                    --             print("true")
                else
                    --             print("false")
                    hasleft = false
                end
            end)
        end)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsPlayerDead(playerped) and isInTimeout then
            SendNUIMessage({
                action = "hide"
            })
            TriggerServerEvent("updateStatusDeath", 0)
            timeoutCleared = true
            Citizen.CreateThread(function()
                Citizen.Wait(0)
                DisableControlAction(0, 24, false)  -- Attack
                DisableControlAction(0, 140, false) -- MeleeAttackAlternate
                DisableControlAction(0, 141, false) -- MeleeAttackAlternate
                DisableControlAction(0, 142, false) -- MeleeAttackAlternate
                SetCanPedEquipAllWeapons(playerped, true)
                DisablePlayerFiring(player, false)
            end)
        end
    end
end)


Citizen.CreateThread(function()
    local i = 0
    while true do
        Citizen.Wait(1000)
        while loaded do
            Citizen.Wait(300)
            local playerped = PlayerPedId()
            if IsEntityDead(playerped) or hasleft then
                if not wasDead then
                    wasDead = true
                    active = true
                    TriggerServerEvent("updateStatusDeath", 1)
                    --      print("yes")
                    while IsEntityDead(playerped) do
                        --          print("is dead")
                        Citizen.Wait(100)
                    end
                    --       print("not dead")
                    time = timefrocfg
                    i = 0
                    isInTimeout = true
                    SendNUIMessage({
                        action = "show",
                        seconds = time
                    })
                    while i ~= time and not timeoutCleared do
                        i = i + 1
                        Citizen.Wait(1000)
                    end
                    active = false
                    TriggerServerEvent("updateStatusDeath", 0)
                    isInTimeout = false
                    timeoutCleared = false
                    loaded = true
                    hasleft = false
                    Citizen.CreateThread(function()
                        Citizen.Wait(0)
                        DisableControlAction(0, 24, false)  -- Attack
                        DisableControlAction(0, 140, false) -- MeleeAttackAlternate
                        DisableControlAction(0, 141, false) -- MeleeAttackAlternate
                        DisableControlAction(0, 142, false) -- MeleeAttackAlternate
                        SetCanPedEquipAllWeapons(playerped, true)
                        DisablePlayerFiring(player, false)
                    end)
                end
            else
                --  print("no")
                wasDead = false
            end
        end
    end
end)





Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        while active do
            Citizen.Wait(0)
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 140, true) -- MeleeAttackAlternate
            DisableControlAction(0, 141, true) -- MeleeAttackAlternate
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            SetCanPedEquipAllWeapons(playerped, false)
            DisablePlayerFiring(player, true)
        end
    end
end)

RegisterNetEvent('clearTimeout')
AddEventHandler('clearTimeout', function()
    SendNUIMessage({
        action = "hide"
    })

    TriggerServerEvent("updateStatusDeath", 0)
    timeoutCleared = true
    Citizen.CreateThread(function()
        Citizen.Wait(0)
        DisableControlAction(0, 24, false)  -- Attack
        DisableControlAction(0, 140, false) -- MeleeAttackAlternate
        DisableControlAction(0, 141, false) -- MeleeAttackAlternate
        DisableControlAction(0, 142, false) -- MeleeAttackAlternate
        SetCanPedEquipAllWeapons(playerped, true)
        DisablePlayerFiring(player, false)
    end)
end)
