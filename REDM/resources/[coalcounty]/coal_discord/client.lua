Citizen.CreateThread(function()
    -- Your Discord application ID (from Discord Developer Portal)
	SetDiscordAppId(1437237690486624368)

    -- Large image key: must match the asset name you uploaded
    SetDiscordRichPresenceAsset('coal_county')

    -- Optional hover text for the big image
    SetDiscordRichPresenceAssetText('Coal County')

    while true do
        local players = GetActivePlayers()
        local count = players and #players or 1

        local text = ('Coal County | %d players'):format(count)
        SetRichPresence(text)

        Citizen.Wait(60000)
    end
end)
