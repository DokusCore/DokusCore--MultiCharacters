--------------------------------------------------------------------------------
---------------------------------- DokusCore -----------------------------------
--------------------------------------------------------------------------------
local IsError = false
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterServerEvent('DokusCore:MultiChar:S:CreateCharacter')
AddEventHandler('DokusCore:MultiChar:S:CreateCharacter', function(Data, x,y,z)
  local source = source
  local cName = Data.Firstname.." "..Data.Lastname
  local Nat, CharID = Data.Nationality, Data.CharID
  local Birth, Gender, Steam = Data.Birthdate, Data.Gender, Data.Steam
  local cConfig = TCC(-1, 'DokusCore:C:Core:GetCoreConfig')
  local cUser = TCC(source, 'DokusCore:C:Core:GetCoreUserData')
  local Coords = "{"..x..", "..y..", "..z.."}"

  local mChar = {
    Steam = Steam, Groups = cConfig._Moderation.Users, cName = cName,
    CharID = CharID, Gender = Gender, Nationality = Nat, BirthDate = Birth,
    XP = 0, Level = 0, JobName = cConfig._StartJob.Name, JobGrade = 0, Coords = Coords
  }

  local mBanks = {
    Steam = Steam, sName = cUser.sName, CharID = CharID,
    Money = _StartWealth.Money, BankMoney = _StartWealth.BankMoney,
    Gold = _StartWealth.Gold, BankGold = _StartWealth.BankGold
  }

  MySQL.Async.execute(DB.Characters.InsertTable, mChar, function() end)
  MySQL.Async.execute(DB.Banks.InsertTable, mBanks, function() end)
  local NeedError = false
  local source = source
  if (cName == ' ') then NeedError = true end
  if (Nat == '') then NeedError = true end
  if (Birth == '') then NeedError = true end
  if NeedError then TriggerEvent('DokusCore:MultiChar:S:IncorrectData', source) end
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterServerEvent('DokusCore:MultiChar:S:IncorrectData')
AddEventHandler('DokusCore:MultiChar:S:IncorrectData', function(source)
  IsError = not IsError
  local source = source
  while IsError do
    TriggerClientEvent('DokusCore:C:Core:ShowTip', source, _('MultiChar:IncorrectData', User.Language), 5000)
    Wait(5000)
  end
end)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
