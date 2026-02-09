# Hướng dẫn sử dụng handleEndJob cho otherbtn

## Tổng quan

`handleEndJob` là một function trong Vue component (App.vue) được tạo để gọi trực tiếp đến `cancelJob` callback. Điều này cho phép bạn kết thúc công việc từ các nút `otherbtn` trong UI một cách đơn giản.

## Cách hoạt động

### Flow logic đơn giản:

```
Vue Component (otherbtn click) 
  → emit('endJob', btn)
    → handleEndJob(btn)
      → Trigger btn.eventname (nếu có)
      → handleStopJob() 
        → fetch('cancelJob')
          → Lua client (RegisterNUICallback('cancelJob'))
            → setWorkingStatus(false)
```

### Code trong App.vue:

```javascript
const handleEndJob = (btn) => {
  // Nếu btn có eventname riêng, trigger event đó trước
  if (btn && btn.eventname) {
    fetch(`https://${GetParentResourceName()}/taskJobs`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        eventname: btn.eventname
      })
    })
  }
  
  // Sau đó gọi cancelJob để kết thúc công việc
  handleStopJob()
}
```

## Cách sử dụng

### Trong config.lua:

Chỉ cần thêm `otherbtn` với `eventname` của bạn:

```lua
button = {
  otherbtn = {
    {
      buttonname = 'Nhận thưởng',
      eventname = 'f17_vesinh:cl:rewardVeSinh',
      eventtype = 'client'
    },
    {
      buttonname = 'Nhận lượt mới',
      eventname = 'f17_vesinh:cl:takeNewRoute',
      eventtype = 'client'
    }
  }
}
```

### Trong file client của nghề:

Xử lý logic của bạn, **KHÔNG CẦN** gọi cancelJob thủ công:

```lua
-- f17_vesinh/client/main.lua
RegisterNetEvent('f17_vesinh:cl:rewardVeSinh', function(result)
    -- Logic nhận thưởng của bạn
    local success = lib.callback.await('f17_vesinh:sv:claimReward', false)
    
    if success then
        QBCore.Functions.Notify('Đã nhận thưởng!', 'success')
        -- UI sẽ TỰ ĐỘNG gọi cancelJob sau khi event này hoàn thành
    else
        QBCore.Functions.Notify('Chưa đủ điều kiện!', 'error')
    end
    
    -- Trả về kết quả cho taskJobs callback
    if result then result(success) end
end)
```

## Ví dụ thực tế

### Ví dụ 1: Nghề Vệ Sinh - Nhận thưởng

```lua
-- config.lua
['vesinh'] = {
    -- ... config khác
    cancelJob = {
        eventname = 'f17_vesinh:cl:cancelVeSinh',
        eventtype = 'client',
        eventfunction = {}
    },
    button = {
        otherbtn = {
            {
                buttonname = 'Nhận thưởng',
                eventname = 'f17_vesinh:cl:rewardVeSinh',
                eventtype = 'client'
            }
        }
    }
}

-- f17_vesinh/client/main.lua
RegisterNetEvent('f17_vesinh:cl:rewardVeSinh', function(result)
    -- Kiểm tra điều kiện
    local canClaim = CheckIfCanClaimReward()
    
    if canClaim then
        -- Nhận thưởng
        TriggerServerEvent('f17_vesinh:sv:giveReward')
        QBCore.Functions.Notify('Đã nhận thưởng!', 'success')
        
        -- UI sẽ TỰ ĐỘNG kết thúc công việc (gọi cancelJob)
        if result then result(true) end
    else
        QBCore.Functions.Notify('Chưa đủ điều kiện!', 'error')
        if result then result(false) end
    end
end)

-- Event cancelJob (được gọi TỰ ĐỘNG bởi UI)
RegisterNetEvent('f17_vesinh:cl:cancelVeSinh', function()
    -- Cleanup logic
    RemoveBlip()
    DeleteVehicle()
    -- ... các cleanup khác
end)
```

### Ví dụ 2: Nghề Xây Dựng - Nhận lượt mới

```lua
-- config.lua
['xaydung'] = {
    -- ... config khác
    button = {
        otherbtn = {
            {
                buttonname = 'Nhận lượt mới',
                eventname = 'f17_xaydung:cl:takeNewRound',
                eventtype = 'client'
            }
        }
    }
}

-- f17_xaydung/client/main.lua
RegisterNetEvent('f17_xaydung:cl:takeNewRound', function(result)
    -- Lấy lượt mới
    local newRound = lib.callback.await('f17_xaydung:sv:getNewRound', false)
    
    if newRound then
        -- Cập nhật vị trí mới
        SetNewWorkLocation(newRound.coords)
        QBCore.Functions.Notify('Đã nhận lượt mới!', 'success')
        
        -- UI sẽ TỰ ĐỘNG kết thúc công việc cũ
        if result then result(true) end
    else
        QBCore.Functions.Notify('Không thể nhận lượt mới!', 'error')
        if result then result(false) end
    end
end)
```

## Lưu ý quan trọng

1. **Tự động kết thúc**: Khi bấm nút `otherbtn`, UI sẽ TỰ ĐỘNG gọi `cancelJob` sau khi event của bạn hoàn thành

2. **Không cần gọi thủ công**: Bạn KHÔNG CẦN gọi `cancelJob` trong event handler của mình

3. **Trạng thái tự động**: `isWorking` sẽ tự động được set về `false` sau khi `cancelJob` được gọi

4. **UI tự động cập nhật**: 
   - Nút "KẾT THÚC CÔNG VIỆC" → "BẮT ĐẦU CÔNG VIỆC"
   - Ẩn các nút `otherbtn`
   - Hiển thị lại thông tin requirements và stars

5. **Callback pattern**: Sử dụng `taskJobs` callback để nhận kết quả từ event của bạn

## So sánh với cách cũ

### Cách CŨ (phức tạp):
```lua
-- Phải tự gọi cancelJob thủ công
RegisterNetEvent('f17_vesinh:cl:rewardVeSinh', function()
    -- Logic nhận thưởng
    ClaimReward()
    
    -- Phải tự gọi cancelJob
    local jobConfig = Config.JobsMenu['vesinh']
    TriggerEvent(jobConfig.cancelJob.eventname)
end)
```

### Cách MỚI (đơn giản):
```lua
-- UI tự động gọi cancelJob
RegisterNetEvent('f17_vesinh:cl:rewardVeSinh', function(result)
    -- Chỉ cần logic nhận thưởng
    local success = ClaimReward()
    
    -- Trả về kết quả, UI lo phần còn lại
    if result then result(success) end
end)
```

## Tóm tắt

- `handleEndJob` tự động gọi `cancelJob` sau khi event của `otherbtn` hoàn thành
- Bạn chỉ cần viết logic xử lý trong event handler
- UI tự động cập nhật trạng thái và kết thúc công việc
- Đơn giản hơn, ít code hơn, ít lỗi hơn!
