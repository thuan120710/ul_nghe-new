local jobName = nil
local LevelJob, JobPoint, careerNextLevel = nil, nil, nil
local isClickButton = false

local openMenuSpamProtect = 0
local function openMenu(job)
    if openMenuSpamProtect > GetGameTimer() then return end
    openMenuSpamProtect = GetGameTimer() + 1000
    PlayerData = QBCore.Functions.GetPlayerData()
    jobName = job
    
    local taxiData = nil
    if jobName and jobName ~= 'taxi' then
        if Config.JobsMenu[jobName].hasLevel then
            local data = lib.callback.await("f17_nghesach:sv:checkNghe", false, jobName)
            LevelJob = data.level
            JobPoint = data.count

            if LevelJob then
                careerNextLevel = Config.JobsMenu[jobName].careerLevel["level"..LevelJob]
            end
        end
    elseif jobName == 'taxi' then
        local mission = PlayerData.metadata["mission"]   
        local progress = lib.callback.await("f17_jobs:sv:checkTaxi", false)
    
        taxiData = {
            npctake = mission["taxinpc"].take,
            npcdone = mission["taxinpc"].done,
            npcprogress = progress.taxinpc,
            tudotake = mission["taxitudo"].take,
            tudodone = mission["taxitudo"].done,
            tudoprogress = progress.taxitudo,
        }
    end

    local jobRanking = lib.callback.await('f17_leaderboard:sv:getJobRanking', false, jobName)

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'show',
        avatar = url,
        firstName = PlayerData.charinfo.firstname,
        lastName = PlayerData.charinfo.lastname,
        currentLevel = Player(GetPlayerServerId(PlayerId())).state.level,
        CareerLevel = LevelJob,
        CareerNextLevel = careerNextLevel,
        CareerProgress = JobPoint,
        CareerTaxi = taxiData,
        jobs = Config.JobsMenu[jobName],
        jobRanking = jobRanking
    })
end

local function CallTrigger(ename, etype, efunc)
    if etype == "client" then
        TriggerEvent(ename, etype, efunc)
    elseif etype == "server" then
        TriggerServerEvent(ename, etype, efunc)
    end
end

RegisterNetEvent('f17-jobs:cl:OpenJobsMenu', function(job)
	openMenu(job)
end)

RegisterNUICallback('closeMenu', function(data, cb)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('acceptJob', function(data, cb)
    if isClickButton then return end
    isClickButton = true
    local doi = promise.new()
    TriggerEvent(data.eventname, function(result)
        if result then
            doi:resolve(true)
        else
            doi:resolve(false)
        end
    end, data)
    local ketqua = Citizen.Await(doi)
    isClickButton = false
    cb(ketqua)
end)

RegisterNUICallback('cancelJob', function(data, cb)
    CallTrigger(data.eventname, data.eventtype, data.eventfunction)
end)

RegisterNUICallback('upgradeJobs', function(data, cb)
    if isClickButton then return end
    isClickButton = true

    local doi = promise.new()

    TriggerEvent(data.eventname, function(success)
        if Config.JobsMenu[jobName].hasLevel then
            local data = lib.callback.await("f17_nghesach:sv:checkNghe", false, jobName)
            LevelJob = data.level
            JobPoint = data.count
            careerNextLevel = Config.JobsMenu[jobName].careerLevel["level" .. LevelJob] or nil
        end

        doi:resolve(success)
    end)

    local ketqua = Citizen.Await(doi)

    local response = {
        ketqua = ketqua,
        LevelJob = LevelJob,
        JobPoint = JobPoint,
        careerNextLevel = careerNextLevel
    }

    isClickButton = false
    cb(response)
end)

RegisterNUICallback('taskJobs', function(data, cb)
    local doi = promise.new()
    TriggerEvent(data.eventname, function(result)
        if result then
            doi:resolve(true)
        else
            doi:resolve(false)
        end
    end)
    local ketqua = Citizen.Await(doi)
    cb(ketqua)
end)

RegisterNUICallback('takeMission', function(data, cb)
    if isClickButton then return end
    isClickButton = true

    local doi = promise.new()
    TriggerEvent(data.eventname, function(result)
        doi:resolve(result == true)
    end)
    local ketqua = Citizen.Await(doi)

    local PlayerData = QBCore.Functions.GetPlayerData()
    local mission = PlayerData.metadata["mission"]
    local progress = lib.callback.await("f17_jobs:sv:checkTaxi", false)

    local taxiData = {
        npctake = mission["taxinpc"].take,
        npcdone = mission["taxinpc"].done,
        npcprogress = progress.taxinpc,
        tudotake = mission["taxitudo"].take,
        tudodone = mission["taxitudo"].done,
        tudoprogress = progress.taxitudo,
    }

    local dataNew = { ketqua = ketqua, CareerTaxi = taxiData }
    isClickButton = false
    cb(dataNew)
end)