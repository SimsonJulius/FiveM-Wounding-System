local playerInjury = {}

function GetCharInjuries(source)
    return playerInjury[source]
end

RegisterServerEvent('wounding:server:SyncInjuries')
AddEventHandler('wounding:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)