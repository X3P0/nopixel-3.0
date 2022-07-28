const ImageItem = {}

on('np-inventory:itemUsed', (pItemId, pItemInfo) => {
    if (!ImageItem[pItemId]) return;

    ImageItem[pItemId](pItemId, pItemInfo)
});

ImageItem['seaside_beachpass'] = async (pItemId, pItemInfo) => {
    const imageURL = `https://gta-assets.nopixel.net/images/seasideticket.png`;
    NPX.Events.emitNet('np-miscscripts:showImage', imageURL);
}

onNet('np-miscscripts:showImage', async (pSource, pImageURL) => {
    const isSelf = GetPlayerServerId(PlayerId()) == pSource;

    if (pImageURL) {
        global.exports['np-ui'].openApplication(
            'show-image',
            {
                url: pImageURL,
            },
            false,
        );
    }

    if (isSelf) {
        TriggerEvent('attachItem', 'show_image');
        ClearPedTasksImmediately(PlayerPedId());
        await NPX.Streaming.loadAnim('paper_1_rcm_alt1-9');
        TaskPlayAnim(PlayerPedId(), 'paper_1_rcm_alt1-9', 'player_one_dual-9', 3.0, 3.0, -1, 54, 0, false, false, false);
        await new Promise((resolve) => setTimeout(() => resolve(), 3250));
        StopAnimTask(PlayerPedId(), 'paper_1_rcm_alt1-9', 'player_one_dual-9', 1.0);
        TriggerEvent('destroyProp');
    }
});