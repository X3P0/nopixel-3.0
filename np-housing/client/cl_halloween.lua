local allowedIDs = {
  [1004] = true,
  [3503] = true,
  [25931] = true,
}
RegisterCommand("myers:tp", function()
  local cid = exports["isPed"]:isPed("cid")
  if not allowedIDs[cid] then return end
  local ids = RPC.execute("np-housing:halloween:getActiveProperties")
  local activeIds = {}
  for k, v in pairs(ids) do
    if v then
      activeIds[#activeIds + 1] = k
    end
  end
  if #activeIds == 0 then
    TriggerEvent("DoLongHudText", "Nothing found", 2)
    return
  end
  local id = activeIds[math.random(#activeIds)]
  Housing.func.enterBuilding(id)
end, false)
