# HƯỚNG DẪN TÍCH HỢP TRẠNG THÁI CÔNG VIỆC

## Mục đích
Để UI hiển thị đúng trạng thái "Bắt đầu" / "Kết thúc" công việc, các resource nghề cần thông báo trạng thái cho backupulnghe.

**Trạng thái được lưu vào Player State nên sẽ được giữ nguyên khi restart backupulnghe hoặc reconnect.**

## Cách tích hợp

### 1. Khi bắt đầu công việc THÀNH CÔNG
Sau khi kiểm tra cooldown, điều kiện và cho phép người chơi bắt đầu công việc, gọi:

```lua
-- Client-side
exports['backupulnghe-2-5']:UpdateWorkingStatus(true, 'tên_event_bắt_đầu')

-- Hoặc dùng event
TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', true, 'tên_event_bắt_đầu')
```

**Ví dụ:**
```lua
RegisterNetEvent('f17_vesinh:cl:DoJob', function(callback, data)
    -- Kiểm tra cooldown
    if cooldownActive then
        QBCore.Functions.Notify('Bạn đang trong thời gian cooldown!', 'error')
        if callback then callback(false) end
        return
    end
    
    -- Bắt đầu công việc thành công
    cooldownActive = true
    exports['backupulnghe-2-5']:UpdateWorkingStatus(true, 'f17_vesinh:cl:DoJob')
    
    if callback then callback(true) end
    -- ... code công việc
end)
```

### 2. Khi kết thúc công việc
Khi người chơi hoàn thành hoặc hủy công việc, gọi:

```lua
-- Client-side
exports['backupulnghe-2-5']:UpdateWorkingStatus(false)

-- Hoặc dùng event
TriggerEvent('f17-jobs:cl:UpdateWorkingStatus', false)
```

**Ví dụ:**
```lua
RegisterNetEvent('f17_vesinh:cl:CancelJob', function()
    -- Kết thúc công việc
    cooldownActive = false
    exports['backupulnghe-2-5']:UpdateWorkingStatus(false)
    
    -- ... code dọn dẹp
end)
```

### 3. Khi bắt đầu THẤT BẠI (cooldown, không đủ điều kiện)
KHÔNG gọi UpdateWorkingStatus, chỉ trả về false trong callback:

```lua
RegisterNetEvent('f17_vesinh:cl:DoJob', function(callback, data)
    if cooldownActive then
        QBCore.Functions.Notify('Bạn đang trong thời gian cooldown!', 'error')
        if callback then callback(false) end  -- Chỉ trả về false
        return  -- KHÔNG gọi UpdateWorkingStatus
    end
    
    -- ... tiếp tục nếu pass kiểm tra
end)
```

## Lưu ý quan trọng

1. **Chỉ gọi UpdateWorkingStatus(true) khi bắt đầu THÀNH CÔNG**
2. **Luôn gọi UpdateWorkingStatus(false) khi kết thúc công việc**
3. **Tham số eventname phải trùng với eventname trong config.lua của backupulnghe**
4. **Nếu nghề có nhiều cấp độ, eventname phải giống nhau cho tất cả cấp độ**
5. **Trạng thái được lưu vào Player State, sẽ tồn tại khi restart backupulnghe**
6. **Khi người chơi disconnect, Player State tự động xóa**

## Ưu điểm của giải pháp này

- ✅ Trạng thái được giữ nguyên khi restart backupulnghe
- ✅ Trạng thái được giữ nguyên khi người chơi mở/đóng menu nhiều lần
- ✅ Tự động xóa khi người chơi disconnect
- ✅ Không cần database, không cần callback phức tạp

## Danh sách nghề cần tích hợp

- [ ] vesinh (f17_vesinh)
- [ ] xaydung (f17_xaydung)
- [ ] thomo (f17_thomo)
- [ ] nuoithu (f17_nuoithu)
- [ ] food/grabfood (f17_grabfood)
- [ ] thodien (f17_thodien)
- [ ] ngheauto (f17_ngheauto)
- [ ] tomtit (f17_tomtit)
- [ ] taxi (f17_taxi)
- [ ] lansanho (f17_lansanho)
- [ ] vanchuyen (f17_vanchuyen)
- [ ] sanban (f17_sanban)
- [ ] lankhobau (f17_lankhobau)
