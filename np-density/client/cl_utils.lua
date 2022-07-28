function tableContains(tbl, value)
  for k, v in pairs(tbl) do
    if v == value then return true end
  end
  return false
end
