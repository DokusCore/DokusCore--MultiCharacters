--------------------------------------------------------------------------------
---------------------------------- DokusCore -----------------------------------
--------------------------------------------------------------------------------
function ToggleMenu(bool) SetNuiFocus(bool, bool) SendNUIMessage({action = "ui", toggle = bool}) skyCam(bool) end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function skyCam(bool)
  if bool then
    DoScreenFadeIn(1000)
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(1.0)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", - 2308.48, 379.17, 174.46, 0.0, 0.0, 333.5, 60.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
  else
    SetTimecycleModifier('default')
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    RenderScriptCams(false, false, 1, true, true)
    FreezeEntityPosition(GetPlayerPed(-1), false)
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function SetCoords(Ped, x,y,z, visible, freeze)
  SetEntityVisible(Ped, visible)
  FreezeEntityPosition(Ped, freeze)
  SetEntityCoords(Ped, x,y,z)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function SplitString(s, delimiter)
  result = {};
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
      table.insert(result, match);
  end
  return result;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ConvertToCoords(string)
  local Data = string.gsub(string, "{", "")
  local Data = string.gsub(Data, "}", "")
  local Data = string.gsub(Data, ",", "")
  return Data
end






















--------------------------------------------------------------------------------
