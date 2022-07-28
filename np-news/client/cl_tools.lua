function conditional(condition, trueExpr, falseExpr)
    if condition then
        return trueExpr
    else
        return falseExpr
    end
end

function GetTextSeparator(index, size, normalSeparator, lastSeparator)
    local separator = conditional(size == index, "", conditional((size - 1) == index, lastSeparator, normalSeparator))
    return separator
end