<template>
  <div class="app-container">
    <div class="ui-wrapper" :style="{ transform: `scale(${uiScale})` }">
      <JobsUI 
        v-if="isVisible"
        :playerData="playerData"
        :jobData="jobData"
        :rankingData="rankingData"
        @close="handleClose"
        @startJob="handleStartJob"
        @stopJob="handleStopJob"
        @upgradeSkill="handleUpgradeSkill"
        @watchVideo="handleWatchVideo"
      />
    </div>
    
    <div class="video-wrapper" :style="{ transform: `scale(${uiScale})` }">
      <VideoModal 
        :isVisible="showVideoModal"
        :videoUrl="currentVideoUrl"
        @close="handleCloseVideo"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import JobsUI from './components/JobsUI.vue'
import VideoModal from './components/VideoModal.vue'

const isVisible = ref(false)
const showVideoModal = ref(false)
const currentVideoUrl = ref('')
const isWorking = ref(false)
const uiScale = ref(1)

const playerData = ref({
  name: 'Christiano Ronaldo',
  level: 5,
  avatar: './image/avatar.png'
})

const jobData = ref({
  name: 'VỆ SINH',
  image: 'image/vesinh.png',
  description: 'Đang tải...',
  videoUrl: '',
  requirements: { level: 1, exp: 0, tools: [] },
  guide: { title: 'HƯỚNG DẪN', description: '', steps: [] },
  skills: { level: 1, exp: 0, maxExp: 100, nextLevel: 1, maxLevel: 1, description: '' },
  rewards: [],
  hasLevel: false,
  isWorking: false
})

const rankingData = ref({
  title: 'BẢNG XẾP HẠNG NGHỀ',
  videoUrl: 'image/Comp1.mp4',
  ranks: []
})

const handleClose = () => {
  isVisible.value = false
  fetch(`https://${GetParentResourceName()}/closeMenu`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({})
  })
}

const handleStartJob = (selectedMethod) => {
  const jobConfig = jobData.value
  
  // Nếu có selectedMethod (từ popup), sử dụng thông tin của method đó
  let eventname, eventtype, eventfunction
  
  if (selectedMethod) {
    // Người chơi đã chọn method từ popup
    eventname = selectedMethod.eventname
    eventtype = selectedMethod.eventtype
    eventfunction = selectedMethod.eventfunction || {}
    // Thêm buttonname vào eventfunction để Lua có thể lưu lại
    // Tạo một copy của eventfunction để không modify object gốc
    eventfunction = { ...eventfunction, buttonname: selectedMethod.buttonname }
  } else if (jobConfig.acceptJob) {
    // Không có popup, sử dụng acceptJob mặc định
    eventname = jobConfig.acceptJob.eventname
    eventtype = jobConfig.acceptJob.eventtype
    eventfunction = {}
  } else {
    return
  }
  
  fetch(`https://${GetParentResourceName()}/acceptJob`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      eventname: eventname,
      eventtype: eventtype,
      eventfunction: eventfunction
    })
  }).then(response => response.json())
    .then(result => {
      if (result === true) {
        // Chỉ khi result === true mới cập nhật trạng thái
        isWorking.value = true
        jobData.value.isWorking = true
        // Lưu lại option đã chọn
        if (selectedMethod) {
          jobData.value.selectedMethod = selectedMethod
        }
      }
      // Nếu result === false, không làm gì cả (giữ nguyên trạng thái)
    })
}

const handleStopJob = () => {
  const jobConfig = jobData.value
  if (jobConfig.cancelJob) {
    fetch(`https://${GetParentResourceName()}/cancelJob`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        eventname: jobConfig.cancelJob.eventname,
        eventtype: jobConfig.cancelJob.eventtype,
        eventfunction: jobConfig.cancelJob.eventfunction
      })
    }).then(() => {
      isWorking.value = false
      jobData.value.isWorking = false
      // Xóa option đã chọn khi kết thúc công việc
      jobData.value.selectedMethod = null
    })
  }
}

const handleUpgradeSkill = () => {
  const jobConfig = jobData.value
  if (jobConfig.upgradeJob && jobConfig.upgradeJob.eventname) {
    fetch(`https://${GetParentResourceName()}/upgradeJobs`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        eventname: jobConfig.upgradeJob.eventname,
        eventtype: jobConfig.upgradeJob.eventtype
      })
    }).then(response => response.json())
      .then(result => {
        if (result.ketqua) {
          // Update job data with new values
          if (result.LevelJob) jobData.value.skills.level = result.LevelJob
          if (result.JobPoint) jobData.value.skills.exp = result.JobPoint
          if (result.careerNextLevel) jobData.value.skills.maxExp = result.careerNextLevel
        }
      })
  }
}

const handleWatchVideo = () => {
  console.log('🎬 Watch video clicked')
  console.log('🎬 Current jobData.videoUrl:', jobData.value.videoUrl)
  if (jobData.value.videoUrl) {
    currentVideoUrl.value = jobData.value.videoUrl
    showVideoModal.value = true
    console.log('🎬 Video modal opened with URL:', currentVideoUrl.value)
  } else {
    console.error('❌ No video URL available')
  }
}

const handleCloseVideo = () => {
  showVideoModal.value = false
  currentVideoUrl.value = ''
}

const GetParentResourceName = () => {
  return window.location.hostname === 'localhost' ? 'f17-jobs' : window.GetParentResourceName()
}

// Hàm tính toán scale dựa trên kích thước màn hình
const calculateScale = () => {
  const designWidth = 1920  // Chiều rộng thiết kế gốc
  const designHeight = 1080 // Chiều cao thiết kế gốc
  
  const scaleX = window.innerWidth / designWidth
  const scaleY = window.innerHeight / designHeight
  
  // Lấy scale nhỏ hơn để UI scale theo tỷ lệ màn hình
  uiScale.value = Math.min(scaleX, scaleY)
}

onMounted(() => {
  // Tính scale ban đầu
  calculateScale()
  
  // Lắng nghe sự kiện resize
  window.addEventListener('resize', calculateScale)
  window.addEventListener('message', (event) => {
    const { action } = event.data
    
    if (action === 'show') {
      isVisible.value = true
      
      // Nhận trạng thái từ Lua
      if (event.data.isWorking !== undefined) {
        isWorking.value = event.data.isWorking
      }
      
      // Map player data
      playerData.value = {
        name: `${event.data.firstName || ''} ${event.data.lastName || ''}`.trim(),
        level: event.data.currentLevel || 1,
        avatar: event.data.avatar || './image/avatar.png'
      }
      
      // Map job data from Config.JobsMenu structure
      const jobConfig = event.data.jobs
      if (jobConfig) {
        // Xử lý videoUrl từ config
        let videoUrl = ''
        if (jobConfig.guide?.videoID) {
          // Nếu có videoID trong config, tạo URL YouTube
          videoUrl = `https://www.youtube.com/watch?v=${jobConfig.guide.videoID}`
          console.log('📹 Video ID from config:', jobConfig.guide.videoID)
          console.log('📹 Generated video URL:', videoUrl)
        } else {
          console.warn('⚠️ No videoID found in config.guide')
        }
        
        // Tính toán level yêu cầu dựa trên cấp độ nghề hiện tại
        const careerLevel = event.data.CareerLevel || 1
        let requiredLevel = 100  // Mặc định
        
        if (jobConfig.careerLevel) {
          // Lấy level yêu cầu dựa trên cấp độ nghề hiện tại
          const levelKey = `level${careerLevel}`
          requiredLevel = jobConfig.careerLevel[levelKey] || 100
        }
        
        // Map rewards từ config (load từ ox_inventory)
        const rewards = (jobConfig.rewards || []).map(reward => {
          let iconPath = './image/other.png' // fallback
          
          if (reward.description) {
            // Load icon từ ox_inventory
            iconPath = `nui://ox_inventory/web/images/${reward.description}`
          }
          
          return {
            name: reward.rewardName || '',
            description: reward.description || '',
            icon: iconPath
          }
        })
        
        // Map tool requirements từ config (load từ ox_inventory)
        let toolRequirements = []
        if (jobConfig.requirements) {
          if (Array.isArray(jobConfig.requirements)) {
            toolRequirements = jobConfig.requirements.map(req => {
              let iconPath = './image/other.png' // fallback
              
              if (req.description) {
                // Load icon từ ox_inventory
                iconPath = `nui://ox_inventory/web/images/${req.description}`
              }
              
              return {
                name: req.requirementName || '',
                description: req.description || '',
                icon: iconPath
              }
            })
          }
        }
        
        console.log('🔧 Tool Requirements:', toolRequirements)
        console.log('🎁 Rewards:', rewards)
        
        jobData.value = {
          name: jobConfig.name || '',
          image: `./image/${jobConfig.home?.img || 'vesinh.png'}`,
          toolImage: jobConfig.toolImage ? `./image/${jobConfig.toolImage}` : null,
          description: jobConfig.home?.description || '',
          videoUrl: videoUrl,
          requirements: { 
            level: jobConfig.requiredLevel || 1, 
            exp: 0,
            tools: toolRequirements,  // Thêm tool requirements vào đây
            // Thêm dữ liệu biến động thị trường từ market
            marketMoney: jobConfig.home?.market?.money || 0,
            marketExp: jobConfig.home?.market?.exp || 0
          },
          guide: { 
            title: jobConfig.guide?.title || 'HƯỚNG DẪN', 
            description: jobConfig.guide?.description || '' 
          },
          skills: { 
            level: careerLevel, 
            exp: event.data.CareerProgress || 0, 
            maxExp: event.data.CareerNextLevel || 100,
            playerLevel: event.data.currentLevel || 1,  // Level nhân vật hiện tại
            requiredLevel: requiredLevel,  // Level yêu cầu để nâng cấp nghề
            maxLevel: jobConfig.maxLevel || 1,
            description: jobConfig.careerLevel?.name ? `Nâng cấp nghề ${jobConfig.careerLevel.name} để mở khóa thêm nhiều tính năng và tăng thu nhập.` : ''
          },
          process: jobConfig.home?.process || {
            money: { current: 0, target: 60 },
            exp: { current: 0, target: 200 },
            active: { current: 0, target: 20 }
          },  // Thêm process stats từ config
          rewards: rewards,  // Thêm rewards từ config
          hasLevel: jobConfig.hasLevel || false,
          acceptJob: jobConfig.acceptJob,
          upgradeJob: jobConfig.upgradeJob,
          cancelJob: jobConfig.cancelJob,
          button: jobConfig.button || {},  // Thêm button config
          isWorking: isWorking.value,  // Sử dụng state từ Lua
          selectedMethod: event.data.selectedMethod || null  // Nhận selectedMethod từ Lua
        }
      }
      
      // Map ranking data
      const jobImagePath = jobConfig?.home?.img ? `./image/${jobConfig.home.img}` : './image/vesinh.png'
      const currentPlayerName = `${event.data.firstName || ''} ${event.data.lastName || ''}`.trim()
      
      if (event.data.jobRanking && Array.isArray(event.data.jobRanking)) {
        rankingData.value = {
          title: 'BẢNG XẾP HẠNG NGHỀ',
          jobImage: jobImagePath,
          videoUrl: './image/Comp1.mp4',
          currentPlayerName: currentPlayerName,  // Thêm tên người chơi hiện tại
          ranks: event.data.jobRanking.map((player, index) => ({
            position: index + 1,
            name: player.name || 'Unknown',
            level: player.cid || 'N/A',
            phone: player.count || 0
          }))
        }
      } else {
        // Default empty ranking
        rankingData.value = {
          title: 'BẢNG XẾP HẠNG NGHỀ',
          jobImage: jobImagePath,
          videoUrl: './image/Comp1.mp4',
          currentPlayerName: currentPlayerName,  // Thêm tên người chơi hiện tại
          ranks: []
        }
      }
    } else if (action === 'hideUI') {
      isVisible.value = false
    }
  })

  // ESC key to close
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && isVisible.value) {
      handleClose()
    }
  })
})

onUnmounted(() => {
  window.removeEventListener('resize', calculateScale)
})
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  user-select: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
}

body {
  font-family: 'Baloo 2', sans-serif;
  overflow: hidden;
}

/* Loại bỏ hiệu ứng gạch chân và bôi đen */
ul, li, a, button, div, span {
  text-decoration: none !important;
  outline: none !important;
}

ul, li {
  list-style: none;
}

/* Loại bỏ hiệu ứng bôi đen khi click và hover */
*:focus {
  outline: none !important;
}

*::selection {
  background: transparent !important;
}

*::-moz-selection {
  background: transparent !important;
}

.app-container {
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.ui-wrapper {
  transform-origin: center center;
  transition: transform 0.3s ease;
}

.video-wrapper {
  transform-origin: center center;
  transition: transform 0.3s ease;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.video-wrapper > * {
  pointer-events: auto;
}
</style>
