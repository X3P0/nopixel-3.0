local currentRadioChannel = 0
function LoadTokoModule()
  function addPlayerToRadio(channel)
    currentRadioChannel = channel
		TriggerServerEvent("TokoVoip:addPlayerToRadio", channel, GetPlayerServerId(PlayerId()))
	end

	function removePlayerFromRadio(channel)
		TriggerServerEvent("TokoVoip:removePlayerFromRadio", channel, GetPlayerServerId(PlayerId()))
	end

	function isPlayerInChannel(channel)
		return RadioChannels[channel] ~= nil
	end

	exports('addPlayerToRadio', addPlayerToRadio)
	exports('removePlayerFromRadio', removePlayerFromRadio)
	exports('isPlayerInChannel', isPlayerInChannel)

	TriggerEvent("np:voice:toko:ready")

	Debug("[Toko] Module Loaded")
end