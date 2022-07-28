local currentJob = nil

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
  currentJob = job
end)

function getHasRaceUsbAndAlias()
  local characterId = exports["isPed"]:isPed("cid")
  local racingCreateUsbItem = exports["np-inventory"]:GetInfoForFirstItemOfName("racingusb0")
  local racingUsbItem = exports["np-inventory"]:GetInfoForFirstItemOfName("racingusb2")
  local pdRacingUsbItem = exports["np-inventory"]:GetInfoForFirstItemOfName("racingusb3")
  local has_usb_racing = racingUsbItem ~= nil and racingUsbItem.quality > 0
  local has_usb_racing_create = racingCreateUsbItem ~= nil and racingCreateUsbItem.quality > 0
  local has_usb_pd_racing = pdRacingUsbItem ~= nil and currentJob == "police"
  local usbMetadata = has_usb_racing and json.decode(racingUsbItem.information) or {}
  local usbCreateMetadata = has_usb_racing_create and json.decode(racingCreateUsbItem.information) or {}
  has_usb_racing = has_usb_racing and characterId == usbMetadata.characterId
  has_usb_racing_create = has_usb_racing_create and characterId == usbCreateMetadata.characterId
  local racingAlias = has_usb_racing and usbMetadata.Alias or nil
  return { has_usb_racing = has_usb_racing, has_usb_racing_create = has_usb_racing_create, has_usb_pd_racing = has_usb_pd_racing, racingAlias = racingAlias }
end
exports("getHasRaceUsbAndAlias", getHasRaceUsbAndAlias)

function canJoinOrStartRace(expectedVehicleClass)
  local ped = PlayerPedId()
  local veh = GetVehiclePedIsIn(ped, false)
  if veh == 0 then return "Must be in vehicle" end
  local driver = GetPedInVehicleSeat(veh, -1)
  if ped ~= driver then return "Must be the driver" end
  local vehicleClass = exports["np-vehicles"]:GetVehicleRatingClass(veh)
  local vehicleClassError = isUnacceptedVehicleClass(expectedVehicleClass, vehicleClass)
  if vehicleClassError ~= nil then return vehicleClassError end
  return true
end
exports("canJoinOrStartRace", canJoinOrStartRace)
