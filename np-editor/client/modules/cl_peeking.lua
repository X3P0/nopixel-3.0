local Current_Peeking_Model = {}


function startModelPeeking(data)
	if data == nil then return end

	local parameters = data.parameters or {}
	parameters.isEditorPeek = true
	exports["np-interact"]:AddPeekEntryByModel({ data.model }, {{
		event = data.event,
		id = data.id,
		icon = data.icon,
		label = data.label,
		parameters = parameters,
	  }}, {
		distance = {radius = 5.0},
		isEnabled = data.enabledFunc
	})
end

function loadPeekingModels()
	if PEEK_CONFIG == nil then return end

	for k,v in pairs(actionObjects['interaction']) do
		if PEEK_CONFIG[k] ~= nil then
			if Current_Peeking_Model[k] then return end
			Current_Peeking_Model[k] = true
			for o,i in pairs(PEEK_CONFIG[k]) do
				local data = i
				data.id = data.id..'_'..k
				data.model = GetHashKey(k)
				startModelPeeking(data)
			end
		end
	end
end