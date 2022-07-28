AddEventHandler("np-business:interactBettaLifeNpc", function()
  local employed = IsEmployedAt("blife")
  if not employed then
    TriggerEvent("DoLongHudText", "They do not recognize you", 2)
    return
  end
  TriggerEvent("server-inventory-open", "42101", "Craft")
end)
