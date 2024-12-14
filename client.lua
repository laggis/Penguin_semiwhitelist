local playerPerms = {
    isWhitelisted = false,
    isPolice = false,
    gangs = {}
}

Citizen.CreateThread(function()
    TriggerServerEvent('checkPermissions')
end)

RegisterNetEvent('updatePermissions')
AddEventHandler('updatePermissions', function(perms)
    playerPerms = perms
end)

function IsInGangTerritory()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    for gangName, _ in pairs(playerPerms.gangs) do
        if Config.GangTerritories[gangName] then
            for _, territory in ipairs(Config.GangTerritories[gangName]) do
                local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(territory.x, territory.y, territory.z))
                if distance <= territory.radius then
                    return true, gangName
                end
            end
        end
    end
    
    return false, nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local inTerritory, gangName = IsInGangTerritory()

        if not playerPerms.isWhitelisted and not playerPerms.isPolice and not (inTerritory and Config.Restrictions.canShootInTerritory) then
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            
            -- Visa meddelande när spelaren försöker skjuta
            if IsControlPressed(0, 24) then
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('~r~Du måste vara whitelistad för att använda vapen!\nGå med i vår Discord: ' .. Config.DiscordInviteUrl)
                EndTextCommandDisplayHelp(0, false, true, -1)
            end
        end
    end
end)

local showSpeedMessage = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.UpdateInterval)
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local speedMPH = GetEntitySpeed(vehicle) * 2.236936
            local speedKMH = GetEntitySpeed(vehicle) * 3.6
            local inTerritory, gangName = IsInGangTerritory()
            
            if playerPerms.isPolice then
                SetVehicleMaxSpeed(vehicle, 0.0)
                showSpeedMessage = false
            elseif not playerPerms.isWhitelisted then
                if speedKMH > Config.SpeedLimit then
                    SetVehicleMaxSpeed(vehicle, Config.SpeedLimit / 3.6)
                    showSpeedMessage = true
                else
                    showSpeedMessage = false
                end
            else
                showSpeedMessage = false
            end
        else
            showSpeedMessage = false
        end
    end
end)

-- Separate thread for displaying the message
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Run every frame
        if showSpeedMessage then
            DrawText2D('~y~Hastighetsbegränsad! Bli whitelistad för högre hastigheter.\nGå med i Discord: ' .. Config.DiscordInviteUrl, 0.5, 0.15)
        end
    end
end)

-- Display server message
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if not playerPerms.isWhitelisted then
            SetTextScale(0.5, 0.5)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(255, 255, 255, 255)
            SetTextEntry("STRING")
            AddTextComponentString(Config.ServerMessage)
            DrawText(0.5, 0.05, 0)
        end
    end
end)

function DrawText2D(text, x, y)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.6, 0.6)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end
