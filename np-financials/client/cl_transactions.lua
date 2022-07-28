-- GET TRANSACTIONS
RegisterUICallback("np-ui:getAccountTransactions", function(data, cb)
    local accountId, transactionType = data.account_id, data.type
    local success, transactions = RPC.execute("GetTransactionLogs", accountId, transactionType)
    cb({ data = transactions, meta = { ok = success, message = 'done' } })
end)

RegisterUICallback("np-ui:accountDeposit", function(data, cb)
    local accountId, amount, comment = data.account_id, data.amount, data.comment
    local success, error = RPC.execute("BankDeposit", accountId, tonumber(amount), comment)
    cb({ data = {}, meta = { ok = success, message = (not success and error or 'done') } })
end)

RegisterUICallback("np-ui:accountWithdraw", function(data, cb)
    local accountId, amount, comment = data.account_id, data.amount, data.comment
    local success, error = RPC.execute("BankWithdraw", accountId, tonumber(amount), comment)
    cb({ data = {}, meta = { ok = success, message = (not success and error or 'done') } })
end)

RegisterUICallback("np-ui:accountTransfer", function(data, cb)
    local sourceAccountId, targetAccountId, targetStateId, amount, comment  = data.account_id, data.target_account_id, data.target_state_id, data.amount, data.comment
    local transferType, targetPhoneNumber = data.type or 'transfer', data.target_phone_number

    if transferType and transferType == "venmo" then
      if targetPhoneNumber then
        local gotAccount, gotAccountMessage = RPC.execute("GetAccountNumberByPhoneNumber", targetPhoneNumber)
        if gotAccount then
          local success, message = RPC.execute("DoTransaction", sourceAccountId, gotAccountMessage, tonumber(amount), comment, 1, transferType)
          if success then
            local gotServerId, serverId, _ = RPC.execute("phone:getServerIdByPhoneNumber", targetPhoneNumber)
            if gotServerId then
              TriggerServerEvent("np-ui:server-relay", serverId, {
                app = "phone",
                data = {
                  action = "notification",
                  target_app = "wenmo",
                  title = "New transfer!",
                  body = ("You received $%s from %s"):format(amount, data.character.first_name .. ' ' .. data.character.last_name)
                },
                source = "np-nui"
              })
            end
          end
          cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
        else
          cb({ data = {}, meta = { ok = gotAccount, message = (not gotAccount and gotAccountMessage or 'done') } })
        end
      else
        cb({ data = {}, meta = { ok = false, message = 'No number specified.' } })
      end
    else
      local accountStatus, accountTarget = false, targetAccountId
      if targetStateId ~= 0 then
        accountStatus, accountTarget = RPC.execute("GetDefaultBankAccount", targetStateId)
      end
      local success, message = RPC.execute("DoTransaction", sourceAccountId, accountTarget, tonumber(amount), comment, 1, transferType)
      cb({ data = {}, meta = { ok = success, message = (not success and message or 'done') } })
    end
end)
