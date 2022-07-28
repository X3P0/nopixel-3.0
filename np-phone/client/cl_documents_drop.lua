-- copied from old np-notepad

local serverNotes = {}
RegisterNetEvent("client:updateNotesAdd")
AddEventHandler("client:updateNotesAdd", function(newNote)
    serverNotes[#serverNotes+1] = newNote 
end)
RegisterNetEvent("client:updateNotesRemove")
AddEventHandler("client:updateNotesRemove", function(id)
  if serverNotes and serverNotes[id] then
    table.remove(serverNotes,id)
  end
end)
RegisterNetEvent("client:updateNotes")
AddEventHandler("client:updateNotes", function(serverNotesPassed)
    serverNotes = serverNotesPassed
end)

Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondaryWorld"] = {23,"F"}} 
Citizen.CreateThread(function()
  local interactionActive = false
  while true do
    Citizen.Wait(0)
    if #serverNotes == 0 then
      Citizen.Wait(1000)
    else
      local plyLoc = GetEntityCoords(PlayerPedId())
      local closestNoteDistance = 900.0
      local closestNoteId = 0
      for i = 1, #serverNotes do
        local distance = #(plyLoc - vector3( serverNotes[i]["x"],serverNotes[i]["y"],serverNotes[i]["z"]))

        if distance < 10.0 then
            DrawMarker(27, serverNotes[i]["x"],serverNotes[i]["y"],serverNotes[i]["z"]-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 2.0, 98,0,234,100, 0, 0, 2, 0, 0, 0, 0)
        end

        if distance < closestNoteDistance then
          closestNoteDistance = distance
          closestNoteId = i
        end
      end

      if closestNoteDistance > 100.0 then
        Citizen.Wait(math.ceil(closestNoteDistance*10))
      end
      if serverNotes[closestNoteId] ~= nil then
        local distance = #(plyLoc - vector3( serverNotes[closestNoteId]["x"],serverNotes[closestNoteId]["y"],serverNotes[closestNoteId]["z"]))
        if distance < 2.0 then
            DrawMarker(27, serverNotes[closestNoteId]["x"],serverNotes[closestNoteId]["y"],serverNotes[closestNoteId]["z"]-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 2.0, 98,0,234,100, 0, 0, 2, 0, 0, 0, 0)
            if not interactionActive then
              interactionActive = true
              exports["np-ui"]:showInteraction("[E] Read Note / [F] Destroy Note")
            end
            if IsControlJustReleased(0, Controlkey["generalUse"][1]) then
                SendUIMessage({
                  source = "np-nui",
                  app = "phone",
                  data = {
                    action = "note-qr-code",
                    id = serverNotes[closestNoteId].id,
                    type_id = serverNotes[closestNoteId].type_id,
                  },
                });
                SetUIFocus(true, true);
            end
            if IsControlJustReleased(0, Controlkey["generalUseSecondaryWorld"][1]) then
              RPC.execute("phone:droppedDocumentDestroy", closestNoteId)
              interactionActive = false
              exports["np-ui"]:hideInteraction()
            end
        elseif interactionActive == true then
          interactionActive = false
          exports["np-ui"]:hideInteraction()
        end
      else
        if interactionActive then
          interactionActive = false
          exports["np-ui"]:hideInteraction()
        end
        if serverNotes[closestNoteId] ~= nil then
          table.remove(serverNotes,closestNoteId)
        end
      end
    end
  end
end)
