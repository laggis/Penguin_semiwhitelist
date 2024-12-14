Config = {}

-- Discord konfiguration
Config.DiscordToken = "" -- Din Discord bot token
Config.GuildId = "" -- Din Discord server ID
Config.DiscordInviteUrl = "https://discord.gg/YourInviteCode" -- Din Discord inbjudningslänk

-- Server Information
Config.ServerName = "Penguin RP" -- Din Server Namn
Config.ServerLogo = "https://i.imgur.com/gybi9X5.jpg" -- URL till din serverlogotyp
Config.ServerMessage = "Hastighetsbegränsad! Bli whitelistad för högre hastigheter." -- Meddelande som visas

-- Roll IDs
Config.WhitelistRoleId = "" -- Whitelist roll ID
Config.PoliceRoleId = "" -- Polis roll ID
Config.BannedRoleId = "" -- Bannad roll ID
Config.GangRoleIds = {
    ["gang1"] = "", -- Gäng 1 roll ID
    ["gang2"] = "", -- Gäng 2 roll ID
    -- Lägg till fler gäng efter behov
}

-- Gäng territorier (koordinater där gängförmågor är aktiverade)
Config.GangTerritories = {
    ["gang1"] = {
        {x = 0.0, y = 0.0, z = 0.0, radius = 100.0}, -- Exempel territorium
    },
    ["gang2"] = {
        {x = 200.0, y = 200.0, z = 0.0, radius = 100.0}, -- Exempel territorium
    }
}

-- Hastighetsgränser
Config.SpeedLimit = 50 -- Standard hastighetsgräns för icke-whitelistade spelare (MPH)
Config.GangSpeedLimit = 80 -- Hastighetsgräns för gängmedlemmar i deras territorium (MPH)

-- Uppdateringsintervall (i millisekunder)
Config.UpdateInterval = 1000 -- Hur ofta hastighet och restriktioner kontrolleras

-- Behörigheter
Config.Restrictions = {
    canShootInTerritory = true, -- Om gängmedlemmar kan skjuta i sitt territorium
    canSpeedInTerritory = true  -- Om gängmedlemmar kan köra fort i sitt territorium
}
