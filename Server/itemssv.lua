ESX = exports['es_extended']:getSharedObject()

ESX.RegisterUsableItem('gauze', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('gauze', 1)

	TriggerClientEvent('wounding:items:gauze', source)
end)

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bandage', 1)

	TriggerClientEvent('wounding:items:bandage', source)
end)

ESX.RegisterUsableItem('firstaid', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('firstaid', 1)

	TriggerClientEvent('wounding:items:firstaid', source)
end)

ESX.RegisterUsableItem('medkit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('medkit', 1)

	TriggerClientEvent('wounding:items:medkit', source)
end)

ESX.RegisterUsableItem('vicodin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('vicodin', 1)

	TriggerClientEvent('wounding:items:vicodin', source)
end)

ESX.RegisterUsableItem('hydrocodone', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hydrocodone', 1)

	TriggerClientEvent('wounding:items:hydrocodone', source)
end)

ESX.RegisterUsableItem('morphine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('morphine', 1)

	TriggerClientEvent('wounding:items:morphine', source)
end)