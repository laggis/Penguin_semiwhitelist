
local playerCache = {
    whitelist = {},
    police = {},
    gangs = {},
    roles = {}
}


function GetDiscordRoles(player, deferrals)
    local discordId = nil
    for _, id in ipairs(GetPlayerIdentifiers(player)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    
    if not discordId then return false end
    
    local endpoint = ("https://discord.com/api/v9/guilds/%s/members/%s"):format(Config.GuildId, discordId)
    local headers = {
        ["Authorization"] = "Bot " .. Config.DiscordToken
    }
    
    PerformHttpRequest(endpoint, function(err, text, headers)
        if text then
            local data = json.decode(text)
            if data and data.roles then

                if deferrals then
                    for _, role in ipairs(data.roles) do
                        if role == Config.BannedRoleId then
                            deferrals.done(string.format([[
❌ Du är bannad från denna server!

För att överklaga:
1. Gå med i vår Discord: %s
2. Öppna en ticket]], Config.DiscordInviteUrl))
                            return
                        end
                    end
                end


                playerCache.whitelist[player] = false
                for _, role in ipairs(data.roles) do
                    if role == Config.WhitelistRoleId then
                        playerCache.whitelist[player] = true
                        break
                    end
                end
                
                playerCache.police[player] = false
                for _, role in ipairs(data.roles) do
                    if role == Config.PoliceRoleId then
                        playerCache.police[player] = true
                        break
                    end
                end
                

                playerCache.gangs[player] = {}
                for gangName, roleId in pairs(Config.GangRoleIds) do
                    for _, role in ipairs(data.roles) do
                        if role == roleId then
                            playerCache.gangs[player][gangName] = true
                            break
                        end
                    end
                end
                
                playerCache.roles[player] = data.roles
                
                if deferrals then
                    if playerCache.whitelist[player] then
                        deferrals.update(string.format("^2✓ Välkommen till %s^7", Config.ServerName))
                    else
                        deferrals.update(string.format([[
^3⚠️ Du är inte whitelistad^7

Du kan spela med begränsad tillgång.
Gå med i vår Discord för full tillgång: %s]], Config.DiscordInviteUrl))
                    end
                    Wait(1000)
                    deferrals.done()
                else

                    TriggerClientEvent('updatePermissions', player, {
                        isWhitelisted = playerCache.whitelist[player],
                        isPolice = playerCache.police[player],
                        gangs = playerCache.gangs[player]
                    })
                end
            end
        end
    end, "GET", "", headers)
end


AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local player = source
    deferrals.defer()

    deferrals.update(string.format([[
^1Välkommen till %s^7

⏳ Kontrollerar din Discord...]], Config.ServerName))


    local discordId = nil
    for _, id in ipairs(GetPlayerIdentifiers(player)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end

    if not discordId then
        deferrals.update(string.format([[
⚠️ Discord hittades inte!

Du kan ansluta, men med begränsad tillgång.
För full tillgång:
1. Se till att Discord körs
2. Länka Discord till FiveM
3. Gå med i vår Discord: %s]], Config.DiscordInviteUrl))
        Wait(5000)
        deferrals.done()
        return
    end


    GetDiscordRoles(player, deferrals)
end)


AddEventHandler('playerDropped', function()
    local player = source
    playerCache.whitelist[player] = nil
    playerCache.police[player] = nil
    playerCache.gangs[player] = nil
    playerCache.roles[player] = nil
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) 
        for player, _ in pairs(playerCache.roles) do
            if GetPlayerPing(player) > 0 then
                GetDiscordRoles(player)
            end
        end
    end
end)

RegisterNetEvent('checkPermissions')
AddEventHandler('checkPermissions', function()
    local player = source
    GetDiscordRoles(player)
end)
