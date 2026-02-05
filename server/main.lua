lib.callback.register('f17_jobs:sv:checkTaxi', function(source)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if not xPlayer then return false end

    local cid = xPlayer.PlayerData.citizenid
    local p = promise.new()

    MySQL.query('SELECT taxinpc, taxitudo FROM f17_nhiemvu WHERE citizenid = ? LIMIT 1', { cid }, function(result)
        if result and result[1] then
            local row = result[1]
            p:resolve({
                taxinpc = row.taxinpc or 0,
                taxitudo = row.taxitudo or 0
            })
        else
            MySQL.Async.insert('INSERT INTO f17_nhiemvu (citizenid) VALUES (?)', { cid }, function(insertId)
                if insertId then
                    p:resolve({ taxinpc = 0, taxitudo = 0 })
                else
                    p:reject('Insert failed')
                end
            end)
        end
    end)

    return Citizen.Await(p)
end)