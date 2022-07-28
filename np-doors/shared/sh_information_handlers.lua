--[[

    How to use:

    - Key is the "description field"
    - lockState = true/false/-1 (-1 will trigger on true OR false)
        REMEMBER this is flipped! false = door unlocked, true = door locked
    - text = displays when triggered in a hud text

]]--

INFORMATION_HANDLERS = {
    ["lsbb lost storage gate forceopen"] = {
        lockState = false,
        text = "You forced the door open with a crowbar"
    }
}