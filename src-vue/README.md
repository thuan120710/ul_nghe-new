# F17 UI Jobs - Vue 3 + Vite

Dự án UI Jobs được xây dựng với Vue 3 + Vite theo chuẩn chuyên nghiệp.

## 🎨 Design System

- **Dark Theme**: Control Panel style
- **Primary Color**: #FECD08 (Yellow)
- **Background**: #3A393C (Main), #5D5D5F (Panel)
- **Text**: #FFFFFF (Default), #000000 (Dark)

## 📁 Cấu trúc dự án

```
src-vue/
├── src/
│   ├── components/
│   │   ├── JobsUI.vue          # Main container
│   │   ├── PlayerInfo.vue      # Player info header
│   │   ├── JobDetails.vue      # Left panel - Job details
│   │   ├── JobActions.vue      # Center panel - Actions
│   │   └── RankingPanel.vue    # Right panel - Ranking
│   ├── assets/
│   │   └── styles/
│   │       └── main.css        # Global styles
│   ├── App.vue                 # Root component
│   └── main.js                 # Entry point
├── index.html
├── vite.config.js
└── package.json
```

## 🚀 Cài đặt

```bash
cd src-vue
npm install
```

## 💻 Development

```bash
npm run dev
```

Ảnh sẽ tự động được copy từ `html/image/` sang `public/image/`

## 🏗️ Build

```bash
npm run build
```

Build sẽ tạo file vào thư mục `../html/`

## 🎮 Test trong game

Nhấn **F2** để toggle UI (test mode)

## 🖼️ Images

Tất cả ảnh được lưu trong `public/image/`:
- `avatar.png` - Avatar người chơi
- `logo.png` - Logo F17 City
- `bg_logo.png` - Badge xếp hạng
- `food.png` - Icon phần thưởng
- `lankhobau.png` - Thợ mỏ
- `lansanho.png` - Làm sàn hộ
- `ngheauto.png` - Nghề auto
- `nuoithu.png` - Nuôi thú
- `sanban.png` - Săn bắn
- `taxi.png` - Lái taxi
- `thodien.png` - Thợ điện
- `thomo.png` - Thợ mộc
- `tromnapcong.png` - Trộm nắp cống
- `vanchuyen.png` - Vận chuyển
- `vesinh.png` - Vệ sinh
- `xaydung.png` - Xây dựng
- `xaydung3.png` - Xây dựng (alt)

## 📦 Components

### JobsUI.vue
Main container chứa toàn bộ UI với 3 cột:
- Left: Job Details
- Center: Job Actions
- Right: Ranking

### PlayerInfo.vue
Hiển thị thông tin player (avatar, name, level)

### JobDetails.vue
- Job image & description
- Rewards
- Requirements
- Guide
- Video button

### JobActions.vue
- Job icon
- Requirements info
- Start job button
- Skill level & exp bar
- Upgrade button

### RankingPanel.vue
- Top 3 badges
- Ranking table với scroll

## 🎨 Color System

```css
--primary: #FECD08
--bg-main: #3A393C
--bg-panel: #5D5D5F
--text-white: #FFFFFF
--text-black: #000000
--blue: #0066FF
--green: #00CC66
--red: #FF0066
```

## 📝 Notes

- Tất cả components sử dụng Composition API
- Props validation đầy đủ
- Emit events rõ ràng
- Responsive & smooth animations
- Clean code & best practices
