local NumberCharset = {}
local Charset = {}

for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

function GeneratePlate(job)
    local generatedPlate
    local doBreak = false
    local plateUnauthorized = false
    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        local plate =GetRandomNumber(2).. GetRandomLetter(3) .. GetRandomNumber(3)

        for k, v in pairs(Config.PlaquesJob) do
            if job ~= nil then
                if v.job == job and job == "police" and job == "ambulance" and job == "mairie" then
                    plate = v.plaque .. GetRandomNumber(4)
                end
            else
                if plate:find(v.plaque) then
                    plateUnauthorized = true
                end
            end
        end

        generatedPlate = string.upper(plate)

        ESX.TriggerServerCallback('h4ci_concess:verifierplaquedispo', function(isPlateTaken)
            if not isPlateTaken and not plateUnauthorized then
                doBreak = true
            end
        end, generatedPlate)

        if doBreak then
            break
        end
    end

    return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
    local callback = 'waiting'

    ESX.TriggerServerCallback('h4ci_concess:verifierplaquedispo', function(isPlateTaken)
        callback = isPlateTaken
    end, plate)

    while type(callback) == 'string' do
        Citizen.Wait(0)
    end

    return callback
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end
