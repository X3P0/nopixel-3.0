RegisterNetEvent('mka-grapple:ropeCreated')
AddEventHandler('mka-grapple:ropeCreated', function(plyServerId, grappleId, dest)
  if plyServerId == GetPlayerServerId(PlayerId()) then
    return
  end
  Grapple.new(dest, {plyServerId=plyServerId, grappleId=grappleId})
end)
