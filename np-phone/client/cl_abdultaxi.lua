RegisterUICallback("np-ui:abdultaxi:getDrivers", function(data, cb)
    local success, drivers = RPC.execute("np-ui:abdultaxi:fetchDrivers")
    cb({data = drivers, meta = { ok = true, message = "done" }})
end)

RegisterUICallback("np-ui:abdultaxi:signOnDuty", function(data, cb)
    local success, drivers = RPC.execute("np-ui:abdultaxi:addCharOnDuty")
    cb({data = drivers, meta = { ok = true, message = "done" }})
end)

RegisterUICallback("np-ui:abdultaxi:signOffDuty", function(data, cb)
    local success, drivers = RPC.execute("np-ui:abdultaxi:removeCharFromDuty")
    cb({data = drivers, meta = { ok = true, message = "done" }})
end)

RegisterUICallback("np-ui:abdultaxi:callDriver", function(data, cb)
    cb({data = {}, meta = { ok = true, message = "done" }})
    local myNumber = exports["isPed"]:isPed("phone_number")
    local driverNumber = data.driver.number

    if (tostring(myNumber) == tostring(driverNumber)) then
        return
    end
    
    -- If for some reason the driver number is null do nothing
    if driverNumber == nil then return end
    RPC.execute("phone:callStart", tostring(myNumber), tostring(driverNumber))
end)


RegisterUICallback("np-ui:abdultaxi:updateStatus", function(data, cb)
    local success, drivers = RPC.execute("np-ui:abdultaxi:updateDriverStatus", data.status)
    cb({data = drivers, meta = { ok = true, message = "done" }})
end)