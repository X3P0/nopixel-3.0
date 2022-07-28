function tablelength(tbl)
  if tbl == nil then return 0 end
  local count = 0
  for _ in pairs(tbl) do count = count + 1 end
  return count
end

function tableToArray(tbl)
  local ret = {}
  for k, v in pairs(tbl) do
    ret[#ret+1] = v
  end
  return ret
end

function isLocalVehicle(vin)
  return vin == nil or string.sub(vin or "", 1, 1) == "1"
end

function isRentalVehicle(vin)
  return vin ~= nil and string.sub(vin or "", 2, 3) == "RN"
end

function isLocalOrRentalVehicle(vin)
  return vin and (isLocalVehicle(vin) or isRentalVehicle(vin))
end
