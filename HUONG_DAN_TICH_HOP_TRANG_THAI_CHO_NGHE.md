# Hướng dẫn tích hợp trạng thái công việc cho các resource nghề

## Vấn đề

UI không tự động chuyển từ nút "BẮT ĐẦU CÔNG VIỆC" sang "KẾT THÚC CÔNG VIỆC" vì resource nghề chưa cập nhật trạng thái.

## Giải pháp

Các resource nghề cần gọi event `f17-jobs:cl:UpdateWorkingStatus` để cập nhật trạng thái.

## Cách tích hợp

### 1. Khi BẮT ĐẦU công việc

Trong event handler bắt đầu công việc, thêm dòng này:

```lua
RegisterNetEvent('f17_lankhobau:cl:DoJob', function(callback, data)
    -- Logic bắt đầu công việc của bạn
    local success = StartJobLogic(data)
    
    if success then
        -- ✅ THÊM DÒNG NÀY - Cập nhật trạng thái đang làm việc
        TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', true, 'f17_lankhobau:cl:DoJob')
        
        QBCore.Functions.Notify('Đã bắt đầu công việc!', 'success')
        callback(true)
    else
        QBCore.Functions.Notify('Không thể bắt đầu công việc!', 'error')
        callback(false)
    end
end)
```

### 2. Khi KẾT THÚC công việc

Trong event handler kết thúc công việc, thêm dòng này:

```lua
RegisterNetEvent('f17_lankhobau:cl:CancelJob', function(etype, efunc)
    -- Cleanup logic
    RemoveBlip()
    DeleteVehicle()
    ResetVariables()
    
    -- ✅ THÊM DÒNG NÀY - Cập nhật trạng thái KHÔNG làm việc
    TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', false, nil)
    
    QBCore.Functions.Notify('Đã kết thúc công việc!', 'success')
end)
```

### 3. Khi NHẬN LƯỢT MỚI (tiếp tục làm việc)

Nếu nghề có chức năng nhận lượt mới mà vẫn tiếp tục làm việc:

```lua
RegisterNetEvent('f17_lankhobau:cl:takeNewRoute', function(etype, efunc)
    -- Logic nhận lượt mới
    local newRoute = lib.callback.await('f17_lankhobau:sv:getNewRoute', false)
    
    if newRoute then
        SetNewLocation(newRoute.coords)
        
        -- ✅ THÊM DÒNG NÀY - Giữ trạng thái đang làm việc
        TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', true, 'f17_lankhobau:cl:DoJob')
        
        QBCore.Functions.Notify('Đã nhận lượt mới!', 'success')
    end
end)
```

## Ví dụ đầy đủ cho nghề Lấn San Hô

```lua
-- f17_lankhobau/client/main.lua

local isWorking = false
local currentBlip = nil
local currentVehicle = nil

-- Bắt đầu công việc
RegisterNetEvent('f17_lankhobau:cl:DoJob', function(callback, data)
    if isWorking then
        QBCore.Functions.Notify('Bạn đang làm việc rồi!', 'error')
        callback(false)
        return
    end
    
    -- Kiểm tra điều kiện
    local canStart = CheckRequirements(data)
    if not canStart then
        QBCore.Functions.Notify('Không đủ điều kiện!', 'error')
        callback(false)
        return
    end
    
    -- Bắt đầu công việc
    isWorking = true
    SpawnBoat()
    CreateBlip()
    
    -- ✅ Cập nhật trạng thái UI
    TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', true, 'f17_lankhobau:cl:DoJob')
    
    QBCore.Functions.Notify('Đã bắt đầu lấn san hô!', 'success')
    callback(true)
end)

-- Kết thúc công việc
RegisterNetEvent('f17_lankhobau:cl:CancelJob', function(etype, efunc)
    if not isWorking then return end
    
    -- Cleanup
    isWorking = false
    RemoveBlip(currentBlip)
    DeleteVehicle(currentVehicle)
    currentBlip = nil
    currentVehicle = nil
    
    -- ✅ Cập nhật trạng thái UI
    TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', false, nil)
    
    QBCore.Functions.Notify('Đã kết thúc công việc!', 'success')
end)

-- Nhận lượt mới
RegisterNetEvent('f17_lankhobau:cl:takeNewRoute', function(etype, efunc)
    if not isWorking then
        QBCore.Functions.Notify('Bạn chưa bắt đầu công việc!', 'error')
        return
    end
    
    -- Lấy vị trí mới
    local newLocation = lib.callback.await('f17_lankhobau:sv:getNewLocation', false)
    
    if newLocation then
        -- Xóa blip cũ
        RemoveBlip(currentBlip)
        
        -- Tạo blip mới
        currentBlip = AddBlipForCoord(newLocation.x, newLocation.y, newLocation.z)
        SetBlipRoute(currentBlip, true)
        
        -- ✅ Giữ trạng thái đang làm việc
        TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', true, 'f17_lankhobau:cl:DoJob')
        
        QBCore.Functions.Notify('Đã nhận lượt mới!', 'success')
    else
        QBCore.Functions.Notify('Không thể nhận lượt mới!', 'error')
    end
end)
```

## Ví dụ cho nghề Vệ Sinh

```lua
-- f17_vesinh/client/main.lua

-- Bắt đầu công việc
RegisterNetEvent('f17_vesinh:cl:acceptVeSinh', function(callback)
    -- Logic bắt đầu
    local success = StartVeSinh()
    
    if success then
        -- ✅ Cập nhật trạng thái
        TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', true, 'f17_vesinh:cl:acceptVeSinh')
        callback(true)
    else
        callback(false)
    end
end)

-- Kết thúc công việc
RegisterNetEvent('f17_vesinh:cl:cancelVeSinh', function(etype, efunc)
    -- Cleanup
    CleanupVeSinh()
    
    -- ✅ Cập nhật trạng thái
    TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', false, nil)
end)

-- Nhận thưởng (không kết thúc công việc)
RegisterNetEvent('f17_vesinh:cl:rewardVeSinh', function(etype, efunc)
    local success = lib.callback.await('f17_vesinh:sv:claimReward', false)
    
    if success then
        QBCore.Functions.Notify('Đã nhận thưởng!', 'success')
        
        -- ✅ Giữ trạng thái đang làm việc
        TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', true, 'f17_vesinh:cl:acceptVeSinh')
    end
end)

-- Nhận lượt mới (không kết thúc công việc)
RegisterNetEvent('f17_vesinh:cl:takeNewRoute', function(etype, efunc)
    local newRoute = GetNewRoute()
    
    if newRoute then
        SetNewRoute(newRoute)
        
        -- ✅ Giữ trạng thái đang làm việc
        TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', true, 'f17_vesinh:cl:acceptVeSinh')
        
        QBCore.Functions.Notify('Đã nhận lượt mới!', 'success')
    end
end)
```

## Lưu ý quan trọng

1. **Luôn gọi khi bắt đầu**: Mỗi khi nghề bắt đầu (callback trả về `true`), phải gọi `UpdateWorkingStatus(true, eventname)`

2. **Luôn gọi khi kết thúc**: Mỗi khi nghề kết thúc, phải gọi `UpdateWorkingStatus(false, nil)`

3. **Giữ trạng thái khi tiếp tục**: Nếu nghề có các action như "Nhận lượt mới", "Nhận thưởng" mà vẫn tiếp tục làm việc, phải gọi `UpdateWorkingStatus(true, eventname)` để giữ trạng thái

4. **EventName phải đúng**: Tham số `eventname` phải là tên event bắt đầu công việc (ví dụ: `'f17_lankhobau:cl:DoJob'`)

## Kiểm tra

Sau khi tích hợp, test bằng cách:

1. Mở F12 Console
2. Bấm "BẮT ĐẦU CÔNG VIỆC"
3. Xem console có log: `🔧 setWorkingStatus() - status: true eventname: f17_xxx:cl:DoJob`
4. Đóng UI và mở lại
5. Xem console có log: `🔍 isCurrentlyWorking() = true`
6. UI phải hiển thị nút "KẾT THÚC CÔNG VIỆC" và các nút `otherbtn`

## Troubleshooting

**Vấn đề**: UI vẫn hiển thị "BẮT ĐẦU CÔNG VIỆC" sau khi bắt đầu nghề

**Nguyên nhân**: Resource nghề chưa gọi `UpdateWorkingStatus(true)`

**Giải pháp**: Thêm `TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', true, eventname)` vào event handler bắt đầu công việc

---

**Vấn đề**: UI không chuyển về "BẮT ĐẦU CÔNG VIỆC" sau khi kết thúc

**Nguyên nhân**: Resource nghề chưa gọi `UpdateWorkingStatus(false)`

**Giải pháp**: Thêm `TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', false, nil)` vào event handler kết thúc công việc
