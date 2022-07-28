let currentSubscription = null;

on("np-music:showBroadcastContextMenu", (channel) => {

  const items = exports["np-inventory"].getItemsOfType("musictape", 20, true)
    .reduce((acc, musictape) => {
      const { title, artist, url } = JSON.parse(musictape.information);
      acc.push({
        title,
        description: artist,
        action: "np-ui:music:setBroadcast",
        key: { channel, url }
      })
      return acc;
    }, [{
      i18nTitle: true,
      title: "Stop broadcasting",
      description: "",
      action: "np-ui:music:setBroadcast",
      key: { channel, url: null }
    }]);

  if (items.length === 0) {    
    TriggerEvent("DoLongHudText", "You have no music tapes.", 2)
    return;
  }

  exports["np-ui"].showContextMenu(items);
});

RegisterUICallback("np-ui:music:setBroadcast", (data, cb) => {
  cb({ data: {}, meta: { ok: true, message: '' } });
  const { channel, url } = data.key;
  RPC.execute("np-music:setBroadcast", channel, url);
});

onNet("np-music:updateBroadcast", (channel, channelData) => {
  if (channel === currentSubscription) {
    if (!channelData) {
      exports["np-ui"].closeApplication("musicplayer", {});
      return;
    }
    openBroadcast(channelData);
  }
});

const openBroadcast = (channelData) => {
  exports["np-ui"].closeApplication("musicplayer", {});
  exports["np-ui"].openApplication("musicplayer", channelData, false);
}

on("np-music:subscribe", async (channel) => {
  currentSubscription = channel;
  const channelData = await RPC.execute("np-music:getChannel", channel);
  if (channelData) {
    openBroadcast(channelData);
  }
});

on("np-music:unsubscribe", () => {
  exports["np-ui"].closeApplication("musicplayer", {});
  currentSubscription = null;
});
