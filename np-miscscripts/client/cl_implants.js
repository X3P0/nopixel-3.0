const ImplantItem = {}

on('np-inventory:itemUsed', (pItemId, pItemInfo) => {
    if (!ImplantItem[pItemId]) return;

    ImplantItem[pItemId](pItemId, pItemInfo)
});

ImplantItem['microchipimplant'] = async (pItemId, pItemInfo) => {
    const playerPed = PlayerPedId();

    const anim = new AnimationTask(playerPed, 'normal', 'Inserting Implant', 3000, 'amb@code_human_wander_idles@female@idle_a', 'idle_a_hairtouch', 48);

    const result = await anim.start();

    if (result !== 100) return;


    emit('inventory:removeItem', pItemId, 1);

    NPX.Procedures.execute('np-miscscripts:implant:installed', pItemInfo);

    await new Promise((resolve) => setTimeout(resolve, 1000))

    exports['np-fx'].PlayEntitySound(PlayerPedId(), "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1);

    emit('DoLongHudText', 'Implant Activated.', 1)
}

ImplantItem['microchipcontroller'] = async (pItemId, pItemInfo) => {
    emit('DoLongHudText', 'System is currently offline.', 2)
}