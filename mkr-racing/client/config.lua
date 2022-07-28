config = {
  checkpointRadius = 10.0, -- Default radius of checkpoints
  checkpointBufferRadius = 1.0, -- Buffer radius around checkpoints
  checkpointBlipColor = 7, -- Color of the checkpoint blip
  checkpointBlipScale = 1.2, -- Scale of the checkpoint blip
  checkpointBlipLookahead = 2, -- How many checkpoints after the current to create a blip for
  checkpointPropLookahead = 1, -- How many checkpoints after the current to spawn props (checkpointObjectHash) for
  checkpointGPSRouteColor = 142, -- Color of GPS route to checkpoint
  vehicleOnlyCheckpoints = false, -- Whether the player has to be in a vehicle to hit checkpoints
  drawCheckpointMarkers = false, -- Whether or not to draw the "arcade style" checkpoint markers
  nui = {
    hudOnly = false, -- Toggle for the non-hud UI (tablet). If true, only the in-race HUD will be active
    hud = {
      showPosition = false, -- Toggle for showing the racer's position on the HUD
      showPositionOnFinish = true, -- Whether the racer's position shows on the HUD when they finish the race (overrides showPosition)
      -- Only 1 property can be used per each direction. Meaning if you use left
      -- you can't use right, and if you use top, you can't use bottom. This is due to how
      -- absolute positioning works in css. If you use both, it will change the size of the element
      position = {
        top = nil,
        bottom = '25px',
        left = nil,
        right = '25px'
      }
    }
  },
  commandsEnabled = false,
  debug = {
    showCheckpointHitLine = false,
  },
}

-- These config options have to be set down here because of the tilde (``) syntax
-- that isn't handled well by Lua syntax highlighters/intellisense
config.checkpointObjectHash = `prop_offroad_tyres02` -- Hash of the objects that spawn to the left and right of checkpoints
config.startObjectHash = `prop_beachflag_01` -- Hash of the object that spawn to the left and right of the start of the race
