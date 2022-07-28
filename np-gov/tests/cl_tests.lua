RegisterCommand("ballot", function()
    SendUIMessage({ source = "np-nui", app = "ballot", show = true });
    SetUIFocus(true, true)
end, false)

RegisterCommand("ballotmanager", function()
    SendUIMessage({ source = "np-nui", app = "ballotmanager", show = true });
    SetUIFocus(true, true)
  end, false)

RegisterCommand("interactions", function(source, args)
    SendUIMessage({
    app = "interactions",
    data = {
        message = "[E] Check in",
        show = true, -- true | false
        type = "error" -- info | warning | error
    },
    source = "np-nui"
});
end, false)

--
--CreateThread(function()
--  PlaySoundFrontend(-1, "ON", "NOIR_FILTER_SOUNDS", true)
--  ClearExtraTimecycleModifier()
--  SetExtraTimecycleModifier("NG_filmnoir_BW01")
--  while true do
--    Citizen.InvokeNative(0xA44FF770DFBC5DAE)
--    Wait(0)
--  end
--end)

-- CreateThread(function()
--   while true do
--     local curVehicle = GetVehiclePedIsIn(PlayerPedId())
--     if curVehicle ~= 0 then
--       SetParticleFxNonLoopedColour(255, 0, 0)
--       local ramp = Citizen.InvokeNative(0x36492c2f0d134c56, curVehicle, Citizen.ResultAsFloat())

--       --print("RAMPUP", ramp)
--       -- UseParticleFxAsset("scr_adversary_slipstream_formation")

--     end
--     Wait(1000)
--   end
-- end)

-- local isEnabled = true
-- Citizen.CreateThread(function()
--   -- Citizen.InvokeNative(0x6DEE944E1EE90CFB, curVehicle, 1)
--   while true do
--     if IsControlJustPressed(0, 38) then
--       print("INVOKIUNG", tostring(isEnabled))
--       local curVehicle = GetVehiclePedIsIn(PlayerPedId())
--         if curVehicle ~= 0 then
--           --     -- print("DRIVEFORCE", GetVehicleHandlingFloat(curVehicle, 'CHandlingData', 'fInitialDriveForce'))
--           --     -- print("fTractionCurveMax", GetVehicleHandlingFloat(curVehicle, 'CHandlingData', 'fTractionCurveMax'))
--           --     -- print("fTractionCurveMin", GetVehicleHandlingFloat(curVehicle, 'CHandlingData', 'fTractionCurveMin'))
--           --     -- print("fTractionCurveLateral", GetVehicleHandlingFloat(curVehicle, 'CHandlingData', 'fTractionCurveLateral'))
--           --     -- print("fTractionSpringDeltaMax", GetVehicleHandlingFloat(curVehicle, 'CHandlingData', 'fTractionSpringDeltaMax'))
--           --     print("fLowSpeedTractionLossMult", GetVehicleHandlingFloat(curVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult'))
--           --     -- print("fCamberStiffness", GetVehicleHandlingFloat(curVehicle, 'CHandlingData', 'fCamberStiffness'))
--           --     -- print("fTractionBiasFront", GetVehicleHandlingFloat(curVehicle, 'CHandlingData', 'fTractionBiasFront'))
--           --     -- print("fTractionLossMult", GetVehicleHandlingFloat(curVehicle, 'CHandlingData', 'fTractionLossMult'))
--           --     -- print("IS IN MODE", tostring(Citizen.InvokeNative(0x48c633e94a8142a7, curVehicle, Citizen.ResultAsInteger())))
--           --   end
--           -- Citizen.InvokeNative(0xAA6A6098851C396F, isEnabled) -- SET_VEHICLE_TRACTION_CONTROL
--           --   Citizen.InvokeNative(0x36DE109527A2C0C4, isEnabled) --- ?
--           --SetVehicleReduceGrip(curVehicle, isEnabled)
--           Citizen.InvokeNative(0x75627043C6AA90AD, GetVehiclePedIsIn(PlayerPedId())) -- Vehicle Collision
--           -- --Citizen.InvokeNative(0xDCE97BDF8A0EABC8, GetVehiclePedIsIn(PlayerPedId()), isEnabled) -- Vehicle stronK?
--           --Citizen.InvokeNative(0xe6c0c80b8c867537, isEnabled) -- Slipstream
--           isEnabled = not isEnabled
--         end
--     end
--     Wait(0)
--   end
-- end)