# HƯỚNG DẪN SỬ DỤNG UI JOBS

## Cách hoạt động

### 1. Khi người chơi bấm E tại NPC nghề:

**File: `client/main.lua`**
```lua
-- Trigger event để mở menu
TriggerEvent('f17-jobs:cl:OpenJobsMenu', 'vesinh') -- Tên nghề từ config
```

### 2. Client Lua gửi data sang NUI:

**File: `client/main.lua` - Function `openMenu(job)`**
- Lấy thông tin player từ QBCore
- Lấy thông tin nghề từ `Config.JobsMenu[jobName]`
- Lấy level nghề, exp từ database (nếu nghề có level)
- Lấy ranking từ server
- Gửi tất cả data sang Vue UI qua `SendNUIMessage`

### 3. Vue UI nhận data và hiển thị:

**File: `src-vue/src/App.vue`**
```javascript
window.addEventListener('message', (event) => {
  const { action, data } = event.data
  
  if (action === 'showUI' && data) {
    // Nhận data từ Lua
    playerData.value = data.player
    jobData.value = data.job
    rankingData.value = data.ranking
    isVisible.value = true
  }
})
```

### 4. Các component hiển thị data:

- **JobDetails.vue**: Hiển thị mô tả nghề, hướng dẫn, video
- **JobActions.vue**: Hiển thị nút bắt đầu nghề, nâng cấp nghề, progress bar
- **RankingPanel.vue**: Hiển thị bảng xếp hạng

## Cấu trúc Config

**File: `config.lua`**

Mỗi nghề có cấu trúc:
```lua
Config.JobsMenu['tên_nghề'] = {
  name = "TÊN HIỂN THỊ",
  requiredLevel = 1,           -- Level yêu cầu
  maxLevel = 3,                -- Level tối đa của nghề
  hasLevel = true,             -- Có hệ thống level không
  
  home = {
    title = "TRANG CHỦ",
    description = "Mô tả nghề...",
    img = "vesinh.png"         -- Tên file ảnh trong /image/
  },
  
  guide = {
    title = "HƯỚNG DẪN",
    description = "Hướng dẫn chi tiết...",
    videoID = "youtube_video_id"
  },
  
  careerLevel = {              -- Chỉ có khi hasLevel = true
    title = "CẤP ĐỘ NGHỀ",
    name = "TÊN NGHỀ",
    target1 = 1400,            -- EXP cần để lên level 2
    level1 = 30,               -- Level nhân vật yêu cầu
    target2 = 2800,            -- EXP cần để lên level 3
    level2 = 65
  },
  
  acceptJob = {
    eventname = 'event_name',
    eventtype = 'client'       -- hoặc 'server'
  },
  
  cancelJob = { ... },
  upgradeJob = { ... },
  
  button = {
    otherbtn = {               -- Các nút khác
      {
        buttonname = 'Nhận thưởng',
        eventname = 'event_name',
        eventtype = 'client'
      }
    }
  }
}
```

## Thêm nghề mới

1. Thêm config nghề mới vào `config.lua`
2. Thêm ảnh nghề vào `src-vue/public/image/` (ví dụ: `nghe_moi.png`)
3. Build lại Vue: `cd src-vue && npm run build`
4. Restart resource trong game

## Build Vue UI

```bash
cd src-vue
npm install          # Lần đầu tiên
npm run build        # Build production
```

File output sẽ được tạo trong thư mục `html/`:
- `html/index.html`
- `html/index-[hash].js`
- `html/index-[hash].css`

## Lưu ý quan trọng

1. **Tên file ảnh**: Phải khớp với `img` trong config (ví dụ: `vesinh.png`)
2. **Video ID**: Chỉ cần ID của YouTube video, không cần full URL
3. **HTML trong description**: Có thể dùng `<br>`, `<b>`, `<i>` trong description
4. **hasLevel**: Nếu `false`, phần upgrade skill sẽ không hiển thị
5. **Event names**: Phải khớp với event đã định nghĩa trong script nghề

## Troubleshooting

### UI không hiển thị:
- Kiểm tra console F8 trong game
- Kiểm tra `action` trong SendNUIMessage phải là `'showUI'`

### Data không đúng:
- Kiểm tra `Config.JobsMenu[jobName]` có tồn tại không
- Kiểm tra console log trong browser (F12)

### Ảnh không hiển thị:
- Kiểm tra file ảnh có trong `html/image/` không
- Kiểm tra tên file khớp với config
