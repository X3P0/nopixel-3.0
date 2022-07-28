let showPrompt = false;
let listener;
let openedBait = false;

setImmediate(async () => {
    while (!exports['np-config'].IsConfigReady()) {
        await Delay(100);
    }
    const spawnPublicZones = exports["np-config"].GetMiscConfig('crafting.spawn.public');
    const craftingSpots = await RPC.execute("np-inventory:getCraftingSpots");
    craftingSpots.forEach(spot => {
        if (spot.zoneData.options.data.public && !spawnPublicZones) return;
        const name = `np-inventory:crafting:${spot.id}`;
        exports["np-polyzone"].AddBoxZone(name, spot.zoneData.position, spot.zoneData.length, spot.zoneData.width, spot.zoneData.options);
    })
})

on("np-polyzone:enter", async (zone, data) => {
    if (!zone.startsWith("np-inventory:crafting:")) return;

    if (data.gangOnly) {
        const currentGang = await exports['np-gangsystem'].GetCurrentGang();

        if (!currentGang) return;
    }

    listener = setTick(() => {
        if (openedBait && data.progression && data.inventories[0].id === "baitinventory") return;
        if (!showPrompt) {
            exports["np-ui"].showInteraction(data.prompt);
            showPrompt = true;
        }
        if (IsControlJustPressed(0, data.key)) {
            exports["np-ui"].hideInteraction();
            if (data.progression) {
                const progression = exports["np-progression"].GetProgression(data.progression);
                let inventory = data.inventories[0];
                data.inventories.forEach(inv => {
                    if (progression >= inv.progression && inv.progression > inventory.progression) inventory = inv;
                });
                emit("server-inventory-open", inventory.id, `Crafting:${inventory.id}`);
                if (inventory.id == "baitinventory") openedBait = true;
            }else {
                emit("server-inventory-open", data.inventory, "Craft");
            }
        }
    });
});

on("np-polyzone:exit", (zone, data) => {
    if (!zone.startsWith("np-inventory:crafting:") || !listener) return;
    clearTick(listener);
    listener = null;
    showPrompt = false;
    exports["np-ui"].hideInteraction();
});
