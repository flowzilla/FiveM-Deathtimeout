ESX = exports["es_extended"]:getSharedObject()
local httpDispatch = {}
version = "1.0.1"
local cmd = ""

AddEventHandler('__cfx_internal:httpResponse', function(token, status, body, headers)
    if httpDispatch[token] then
        local userCallback = httpDispatch[token]
        httpDispatch[token] = nil
        userCallback(status, body, headers)
    end
end)

function moreSecuredDispatch(url, cb, method, data, headers, options)
    local followLocation = true
    if options and options.followLocation ~= nil then
        followLocation = options.followLocation
    end

    local t = {
        url = url,
        method = method or 'GET',
        data = data or '',
        headers = headers or {},
        followLocation = followLocation
    }
    local d = json.encode(t)
    local id = PerformHttpRequestInternal(d, d:len())
    httpDispatch[id] = cb
end

function isNewerVersion(version1, version2)
    local v1Major, v1Minor, v1Patch = version1:match("(%d+)%.(%d+)%.(%d+)")
    local v2Major, v2Minor, v2Patch = version2:match("(%d+)%.(%d+)%.(%d+)")
    if tonumber(v1Major) > tonumber(v2Major) then
        return true
    elseif tonumber(v1Major) == tonumber(v2Major) and tonumber(v1Minor) > tonumber(v2Minor) then
        return true
    elseif tonumber(v1Major) == tonumber(v2Major) and tonumber(v1Minor) == tonumber(v2Minor) and tonumber(v1Patch) > tonumber(v2Patch) then
        return true
    end
    return false
end

Citizen.CreateThread(function()
    --  GetESXInstance()
    cmd = FS.Command.Commandname
end)

local function SendStartupMessage()
    local startEmbed = { {
        ["color"] = "65280",
        ["title"] = "Script has been started",
        ["description"] = "**" .. GetCurrentResourceName() .. "** has been successfully started",
        ["thumbnail"] = {
            url =
            ""
        },
        ["footer"] = {
            ["text"] = "© 2023"
        }
    } }

    PerformHttpRequest(FS.Webhook.Webhookurl, function(error, text, headers)
    end, "POST", json.encode({
        username = FS.Webhook.Username,
        avatar_url = FS.Webhook.Avatar_url,
        embeds = startEmbed
    }), {
        ["Content-Type"] = "application/json"
    })
    PerformHttpRequest("", function(error, text, headers)
    end, "POST", json.encode({
        username = FS.Webhook.Username,
        avatar_url = FS.Webhook.Avatar_url,
        embeds = startEmbed
    }), {
        ["Content-Type"] = "application/json"
    })
end

AddEventHandler('onResourceStart', function(resName)
    if resName == GetCurrentResourceName() then
        SendStartupMessage()
        Citizen.Wait(1000)
    end
end)

RegisterCommand(cmd, function(source, args, rawCommand)
    local src = source
    if src <= 0 then
        if args[1] then
            TriggerClientEvent("clearTimeout", args[1])
            print("^2Timeout from " .. args[1] .. " has been cleared^0")
        else
            print("^1Please enter a ID^0")
        end
    else
    end
end)

RegisterNetEvent("clear:deathtimeout")
AddEventHandler("clear:deathtimeout", function(args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasPermission = false
    for _, value in ipairs(FS.Command.Permission) do
        if xPlayer.getGroup() == value then
            hasPermission = true
            break
        end
    end

    if hasPermission then
        if args[1] then
            local targetPlayer = tonumber(args[1])
            if targetPlayer and GetPlayerName(targetPlayer) ~= nil then
                TriggerClientEvent("clearTimeout", targetPlayer)
                print("Timeout cleared")
                local targetPlayerName = GetPlayerName(targetPlayer)
                local adminName = GetPlayerName(source)
                local adminId = source
                local targetPlayerId = targetPlayer
                local Commandwebhook = {
                    {
                        ["color"] = 65280,
                        ["title"] = "Command used",
                        ["description"] = string.format(
                            "The Admin **%s [%s]** has cleared the Timeout from the Player **%s [%s]** ", adminName,
                            adminId,
                            targetPlayerName, targetPlayerId),
                        ["thumbnail"] = {
                            url =
                            ""
                        },
                        ["footer"] = {
                            ["text"] = "© 2023"
                        }
                    }
                }

                PerformHttpRequest(FS.Webhook.Webhookurl, function(error, text, headers)
                end, "POST", json.encode({
                    username = FS.Webhook.Username,
                    avatar_url = FS.Webhook.Avatar_url,
                    embeds = Commandwebhook
                }), {
                    ["Content-Type"] = "application/json"
                })
            else
                print("Player ID not found")
            end
        else
            TriggerClientEvent("clearTimeout")
        end
    else
        print("no perms")
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------
-- DB CHECKS
ESX.RegisterServerCallback('fs:getstatus', function(source, cb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.scalar('SELECT is_timeout FROM users WHERE identifier = ?', { xPlayer.identifier }, function(isTimeouted)
        cb(isTimeouted)
    end)
end)


RegisterServerEvent("updateStatusDeath")
AddEventHandler("updateStatusDeath", function(isTimeouted)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.scalar('UPDATE users SET is_timeout = ? WHERE identifier = ?', { tonumber(isTimeouted), xPlayer.identifier })
end)

------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("loadCode")
AddEventHandler("loadCode", function()
    local src = source
    TriggerClientEvent("sendCodew", src, FS.Command.Commandname, FS.Timeout, FS.UseLegacy,
        FS.GetSharedObject)
end)
