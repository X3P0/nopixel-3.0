Citizen.CreateThread(function()
    exports["np-keybinds"]:registerKeyMapping("", "News", "Toggle Overlay", "+newsOverlay", "-newsOverlay")
    RegisterCommand('+newsOverlay', toggleOverlay, false)
    RegisterCommand('-newsOverlay', function() end, false)

    exports["np-polytarget"]:AddBoxZone("np-newsjob:equipment", vector3(-592.83, -932.86, 23.78), 0.8, 1.8, {
        heading=0,
        minZ=23.58,
        maxZ=24.38,
        data = {
            id = "1"
        }
    })

    exports["np-polytarget"]:AddBoxZone("np-newsjob:controlboard", vector3(-587.06, -932.6, 24.53), 0.6, 3.2, {
        heading=89,
        minZ=24.33,
        maxZ=24.73,
        data = {
            id = "1"
        }
    })

    exports["np-polytarget"]:AddBoxZone("np-newsjob:sequencer", vector3(-589.71, -932.79, 24.53), 0.6, 1.4, {
        heading=89,
        minZ=24.33,
        maxZ=24.73,
        data = {
            id = "1"
        }
    })

    exports["np-polytarget"]:AddBoxZone("np-newsjob:signon", vector3(-603.39, -919.15, 23.78), 0.8, 0.8, {
        heading=0,
        minZ=23.58,
        maxZ=23.98,
        data = {
            id = "1"
        }
    })

    exports["np-polytarget"]:AddBoxZone("np-newsjob:officepc", vector3(-601.52, -921.79, 23.28), 1.6, 0.8, {
        heading=0,
        minZ=23.48,
        maxZ=24.28,
        data = {
            id = "1"
        }
    })

    exports["np-polytarget"]:AddBoxZone("np-newsjob:checkWeather", vector3(-574.47, -919.8, 29.73), 1.2, 1.8, {
        heading=0,
        minZ=28.73,
        maxZ=30.13,
        data = {
            id = "1"
        }
    })

    exports["np-polytarget"]:AddBoxZone("np-newsjob:openArchives", vector3(-572.16, -919.59, 29.73), 2.0, 1.6, {
        heading=0,
        minZ=28.73,
        maxZ=31.33,
        data = {
            id = "1"
        }
    })

    exports["np-polytarget"]:AddBoxZone("np-newsjob:ceoChangeUrl", vector3(-592.82, -921.0, 29.73), 0.4, 3.2, {
        heading=0,
        minZ=29.73,
        maxZ=31.73,
        data = {
            id = "1"
        }
    })

    exports["np-polyzone"]:AddBoxZone("np-newsjob:ceoRoom", vector3(-592.53, -916.25, 29.73), 10.8, 8.6, {
        name="ceo",
        heading=0,
        minZ=28.73,
        maxZ=32.13,
        data = {
            id = "1"
        }
    })

    exports["np-polytarget"]:AddBoxZone("np-newsjob:cinemaChangeUrl", vector3(-619.91, -938.12, -1.18), 0.4, 2.4, {
        heading=0,
        minZ=-1.58,
        maxZ=0.62,
        data = {
            id = "1"
        }
    })

    exports["np-polyzone"]:AddBoxZone("np-newsjob:cinemaRoom", vector3(-601.6, -936.64, -1.18), 36.6, 52.2, {
        heading=0,
        minZ=-8.78,
        maxZ=2.62,
        data = {
            id = "1"
        }
    })
end)
