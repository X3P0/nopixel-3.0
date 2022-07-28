function toggleRadioAnimation(pState)
  local isInTrunk = exports["isPed"]:isPed("intrunk")
  local isDead = exports["isPed"]:isPed("dead")

  if isInTrunk then return end
  if isDead then return end

  LoadAnimationDic("cellphone@")

  if pState then
    TriggerEvent("attachItemRadio","radio01")
    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
  else
    StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
    TriggerEvent("destroyPropRadio")
  end
end

function closeEvent()
  TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.6)
  toggleRadioAnimation(false)
end