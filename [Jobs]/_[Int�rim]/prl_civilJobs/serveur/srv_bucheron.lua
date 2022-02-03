
local config = {
    Heading = 219.18060302734,
    pedHash = "s_m_y_construct_01",
    AuTravaillebucheron = false,
    ArgentMin = 40,
    ArgentMax = 60,
}






RegisterNetEvent("RED_JOBS:bucheronAntiDump")
AddEventHandler("RED_JOBS:bucheronAntiDump", function()
    TriggerClientEvent("RED_JOBS:bucheronAntiDump", source, config, WorkerChillPos, WorkerWorkingPos)
end)
