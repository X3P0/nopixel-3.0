RegisterUICallback("np-ui:getNewspaperContent", function(data, cb)
    local upcomingElections, recentElections = GetElectionsData()

    cb({
        data = {
            drugs = GetDrugsNews(),
            stonks = RPC.execute("GetStocksData"),
            recentElections = recentElections,
            upcomingElections = upcomingElections,
            lockups = RPC.execute("GetConvictionList"),
            taxes = GetTaxLevels(),
        },
        meta = { ok = true, message = 'done' }
    })
end)
function GetTaxLevels()
    local taxes = {}

    local validTaxes, taxList = RPC.execute('GetTaxLevels')

    if validTaxes then
        for _, tax in ipairs(taxList) do
            taxes[#taxes + 1] = { type = tax.name, level = tax.level }
        end
    end

    return taxes
end
function GetElectionsData()
    local upcoming, recent = {}, {}

    local success, electionsData = RPC.execute('GetElectionsData')

    if success then
        for _, ballot in pairs (electionsData.upcoming) do
            upcoming[#upcoming + 1] = {date = ballot.start_date, title = ballot.name, description = ballot.description or description}
        end

        for _, ballot in pairs (electionsData.recent) do
            recent[#recent + 1] = {date = ballot.end_date, title = ballot.name, description = ballot.description or description}
        end
    end

    return upcoming, recent
end

function GetDrugsNews()
    local results = RPC.execute("GetDrugNews")

    local str = "Drug Epidemic spotted around "

    for idx, hot in ipairs(results.hot) do
        local separator = GetTextSeparator(idx, #results.hot, ", ", " and ")
        str = str .. ("%s%s"):format(hot, separator)
    end

    str = str .. ", according to recent statistics "

    for idx, drug in ipairs(results.drugs) do
        local separator = GetTextSeparator(idx, #results.drugs, ", ", " and ")
        str = str .. ("%s%s"):format(drug, separator)
    end

    if #results.drugs > 1 then
        str = str .. " are the most sought after drugs around "
    else
        str = str .. " is the most sought after drug around "
    end

    for idx, drug in ipairs(results.sought) do
        local separator = GetTextSeparator(idx, #results.sought, ", ", " and ")
        str = str .. ("%s%s"):format(drug, separator)
    end

    str = str .. " according to LSPD investigations."

    return str
end

RegisterNetEvent("np-ui:displayNews")
AddEventHandler("np-ui:displayNews", function()
  exports["np-ui"]:openApplication("newspaper")
end)

Citizen.CreateThread(function()
  local models = {
    `prop_news_disp_01a`,
    `prop_news_disp_02a`,
    `prop_news_disp_02c`,
    `prop_news_disp_03a`,
    `prop_news_disp_05a`,
  }
  exports["np-interact"]:AddPeekEntryByModel(models, {
    {
      id = "newspaper",
      event = "np-ui:displayNews",
      icon = "newspaper",
      label = "Read Newspaper",
    },
  }, { distance = { radius = 1.5 } })
end)
