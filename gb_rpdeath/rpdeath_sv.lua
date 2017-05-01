TriggerEvent('es:addCommand', 'killme', function(source, args, user)
	TriggerClientEvent('gabs:kill', source)
end)

TriggerEvent('es:addCommand', 'healme', function(source, args, user)
	TriggerClientEvent('gabs:rpdheal', source)
end)

RegisterServerEvent('gabs:rpdhopital_sv')
AddEventHandler('gabs:rpdhopital_sv', function()
  TriggerClientEvent('gabs:rpdhopital_cl', source, 357.43, -593.36, 28.79)
end)

RegisterServerEvent('gabs:rpduseitem_sv')
AddEventHandler('gabs:rpduseitem_sv', function()
  TriggerClientEvent('gabs:rpdheal', source)
end)