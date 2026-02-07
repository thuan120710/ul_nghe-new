# Hướng dẫn Export Working Status cho các Script Nghề

## Mục đích
UI Jobs cần kiểm tra trạng thái làm việc của người chơi để hiển thị đúng nút "BẮT ĐẦU CÔNG VIỆC" hoặc "KẾT THÚC CÔNG VIỆC".

## Yêu cầu
Mỗi script nghề (f17_vesinh, f17_xaydung, f17_thomo, v.v.) cần export một function để kiểm tra trạng thái:

### Cách 1: Export function `IsWorking()`
```lua
-- Trong client script của nghề (ví dụ: f17_thomo/client/main.lua)

local isDoingJob = false  -- Biến theo dõi trạng thái

-- Export function
exports('IsWorking', function()
    return isDoingJob
end)

-- Hoặc dùng cú pháp mới hơn:
function IsWorking()
    return isDoingJob
end
exports('IsWorking', IsWorking)
```

### Cách 2: Export function `GetWorkingStatus()`
```lua
-- Nếu script nghề đã có function với tên khác
exports('GetWorkingStatus', function()
    return isDoingJob
end)
```

## Danh sách các nghề cần cập nhật

| Job Name | Resource Name | Export Function Cần Thêm |
|----------|---------------|--------------------------|
| vesinh | f17_vesinh | `IsWorking()` hoặc `GetWorkingStatus()` |
| xaydung | f17_xaydung | `IsWorking()` hoặc `GetWorkingStatus()` |
| thomo | f17_thomo | `IsWorking()` hoặc `GetWorkingStatus()` |
| nuoithu | f17_cstc | `IsWorking()` hoặc `GetWorkingStatus()` |
| food | f17_grabfood | `IsWorking()` hoặc `GetWorkingStatus()` |
| thodien | f17_thodien | `IsWorking()` hoặc `GetWorkingStatus()` |
| ngheauto | f17_ngheauto | `IsWorking()` hoặc `GetWorkingStatus()` |
| tomtit | f17_tomtit | `IsWorking()` hoặc `GetWorkingStatus()` |
| taxi | f17_taxi | `IsWorking()` hoặc `GetWorkingStatus()` |
| lansanho | f17_lansanho | `IsWorking()` hoặc `GetWorkingStatus()` |
| vanchuyen | f17_vanchuyen | `IsWorking()` hoặc `GetWorkingStatus()` |
| sanban | f17_sanban | `IsWorking()` hoặc `GetWorkingStatus()` |
| lankhobau | f17_lankhobau | `IsWorking()` hoặc `GetWorkingStatus()` |

## Ví dụ hoàn chỉnh

```lua
-- f17_thomo/client/main.lua

local isDoingThoMo = false

-- Event bắt đầu công việc
RegisterNetEvent('f17_thomo:cl:DoJob', function(callback)
    if isDoingThoMo then
        -- Đang làm việc rồi
        if callback then callback(false) end
        return
    end
    
    -- Bắt đầu công việc
    isDoingThoMo = true
    -- ... logic khác
    
    if callback then callback(true) end
end)

-- Event kết thúc công việc
RegisterNetEvent('f17_thomo:cl:CancelJob', function()
    isDoingThoMo = false
    -- ... logic khác
end)

-- Export function để UI Jobs kiểm tra trạng thái
exports('IsWorking', function()
    return isDoingThoMo
end)
```

## Lưu ý
- Function export phải trả về `true` khi đang làm việc, `false` khi không làm việc
- Đảm bảo biến trạng thái được cập nhật đúng khi bắt đầu/kết thúc công việc
- UI Jobs sẽ tự động gọi export này khi mở menu để kiểm tra trạng thái
