AddEventHandler("np-inventory:itemUsed", function (name, info)
    if name ~= "sginvite" then return end

    local cid = exports["isPed"]:isPed("cid")
    local data = json.decode(info)

    if not data or data.cid ~= cid then return end

    exports["np-ui"]:openApplication("halloween", {
        cardNumber = data.number,
        inviteCode = data.invite
    })
    --TriggerEvent("DoLongHudText", "You have received instructions in your clipboard. Keep this for yourself.")
end)