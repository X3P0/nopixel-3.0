let currentUI = null
let controlUI = false
let showingMenu = false
let blockingActions = null

function setCommandUI(commandUI,headingData,type){

    if(!commandUI){
        hideMenu()
    }

    if(type == 1){
        enableMenu(true,false)
    }
    else if(type == 2 || type == 3){
        enableMenu(false,true)
    }
    currentUI = commandUI
    if(currentUI == null)
        showingMenu = false

    if(type == 1){
        SendNuiMessage(JSON.stringify({
            action: 'setCurrentInteractionMenu',
            commandUI: currentUI,
            headingData: headingData
        }))
    }
    else if(type == 2 || type == 3){

        let expanded = getOptionState(commandUI.options,"toggleDefaultMenu")
        if(type == 2){
            SetNuiFocus(true,true)
        }

        if(type == 3){
            SetNuiFocus(true,false)
            SetNuiFocusKeepInput(true)
            expanded = getOptionState(commandUI.options,"expandedOnPass")
        }

        SendNuiMessage(JSON.stringify({
            action: 'setCurrentMainMenu',
            playerData: commandUI.playerData,
            options: commandUI.options,
            menuData: commandUI.menuData,
            playerLogs: commandUI.playerLogs,
            adminMode: commandUI.adminMode,
            itemList: commandUI.itemList,
            vehicleList: commandUI.vehicleList,
            vehiclePresetList: commandUI.vehiclePresetList,
            jobList: commandUI.jobList,
            licenseList: commandUI.licenseList,
            favCommands: commandUI.favCommands,
            startExpanded: expanded,
            disconnectedPlayers: commandUI.disconnectedPlayers,
            bannedList: commandUI.bannedList,
            garageList: commandUI.garageList,
        }))
    }
}
global.exports("setCommandUI", setCommandUI);

function getOptionState(options,optionName)
{
    let state = true
    let found = options.find(e => e.optionName === optionName);
    if(found)
        state = found.data

    return state
}

function enableMenu(selection,menu){
    showingMenu = true
    SendNuiMessage(JSON.stringify({
        action: 'show',
        selection: selection,
        menu: menu
    }))
}
global.exports("enableMenu", enableMenu);

function hideMenu(){
    showingMenu = false
    SendNuiMessage(JSON.stringify({
        action: 'show',
        selection: false,
        menu: false
    }))
}

function toggleNUI(){
    if(!showingMenu){
        return
    }
    controlUI = !controlUI;
    SetNuiFocus(controlUI,controlUI);
    SetCursorLocation(0.5, 0.5);
    SendNuiMessage(JSON.stringify({
        action: 'setKeyBinds',
        selectionMenu: global.exports["np-keybinds"].getKeyMapping("+enableSelectionMenu"),
        selectionKey: global.exports["np-keybinds"].getKeyMapping("+adminSelect")
    }))
}
function exitNUI()
{
    controlUI = false
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
}
global.exports("exitNUI", exitNUI);

RegisterNuiCallbackType('closeMenu')
on('__cfx_nui:closeMenu', (data, cb) => {

    controlUI = false
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)

    if(data.toSelect){
        global.exports["np-admin"].enterSelection();
    }

    cb();
});

RegisterNuiCallbackType('hideMenu')
on('__cfx_nui:hideMenu', (data, cb) => {
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)

    cb();
});


RegisterNuiCallbackType('changeInputFocus')
on('__cfx_nui:changeInputFocus', (data, cb) => {
    SetNuiFocusKeepInput(data.focus)
    cb();
});


RegisterNuiCallbackType('insideCommand')
on('__cfx_nui:insideCommand', (data, cb) => {

    if(data.inside){
        if(blockingActions){
            return
        }

        emit('np-binds:should-execute',false)
        blockingActions = setTick(() => {
            DisableControlAction(0, 24, true)
			DisableControlAction(0, 142, true)
            DisableControlAction(1, 38, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(1, 75, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(1, 23, true)
            DisableControlAction(1, 37, true)
            DisableControlAction(0, 245, true)
            DisableControlAction(0, 245, true)
        });

    } else {
        emit('np-binds:should-execute',true)
        if(blockingActions){
            clearTick(blockingActions);
            blockingActions = null
        }
    }

    cb();
});

RegisterCommand("+enableSelectionMenu", () => toggleNUI(), false);
RegisterCommand("-enableSelectionMenu", () => {} , false);
global.exports["np-keybinds"].registerKeyMapping("", "zzAdmin", "Selection Menu", "+enableSelectionMenu", "-enableSelectionMenu", "")



function updatePlayerLogs(playerLogs){
    SendNuiMessage(JSON.stringify({
        action: 'updatePlayerLogs',
        playerLogs: playerLogs,
    }))
}
global.exports("updatePlayerLogs", updatePlayerLogs);

function updateMenuData(menuData){
    SendNuiMessage(JSON.stringify({
        action: 'updateMenuData',
        menuData: menuData,
    }))
}
global.exports("updateMenuData", updateMenuData);

function updateDefinedNames(definedNames){
    SendNuiMessage(JSON.stringify({
        action: 'updateDefinedNames',
        data: definedNames,
    }))
}
global.exports("updateDefinedNames", updateDefinedNames);

function updateAdminMode(isInAdmin){
    SendNuiMessage(JSON.stringify({
        action: 'updateAdminMode',
        adminMode: isInAdmin,
    }))
}
global.exports("updateAdminMode", updateAdminMode);