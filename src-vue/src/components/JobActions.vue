<template>
  <div class="job-actions">
    <!-- Method Popup - Chỉ hiển thị khi CHƯA làm việc -->
    <MethodPopup 
      v-if="showMethodPopup && !job.isWorking"
      :jobName="job.name"
      :methods="job.button?.methodbtn || {}"
      @close="showMethodPopup = false"
      @selectMethod="handleMethodSelect"
    />

    <!-- Top Section: Job Icon & Start Job -->
    <div class="job-start-section" :class="{ 'working-state': job.isWorking }">
      <!-- Job Icon - Layout khác nhau khi đang làm việc -->
      <div class="job-icon" :class="{ 'working-layout': job.isWorking }">
        <div class="icon-circle" :class="{ 'small': job.isWorking }">
          <div class="icon-bg"></div>
          <img 
            :src="getToolImage" 
            :alt="job.name" 
            class="job-tool-icon"
            @error="handleImageError"
            @load="handleImageLoad"
          />
        </div>
        <div class="job-name">
          <span v-if="!job.isWorking">{{ job.name }}</span>
          <span v-else>Đang làm việc {{ job.name }} (LV{{ job.skills?.level || 1 }})...</span>
        </div>
      </div>

      <!-- Requirements Info - Chỉ hiển thị khi CHƯA làm việc -->
      <div v-if="!job.isWorking" class="requirements-header">
        <span class="req-label">Biến động thị trường</span>
        <span class="req-badge" :class="marketMoneyPercent >= 0 ? 'money-positive' : 'money-negative'">
          IC {{ marketMoneyPercent >= 0 ? '+' : '' }}{{ marketMoneyPercent }}%
        </span>
        <span class="req-badge" :class="marketExpPercent >= 0 ? 'exp-positive' : 'exp-negative'">
          EXP {{ marketExpPercent >= 0 ? '+' : '' }}{{ marketExpPercent }}%
        </span>
      </div>

      <!-- Three Stars Row - Chỉ hiển thị khi CHƯA làm việc -->
      <div v-if="!job.isWorking" class="stars-row">
        <div class="star-group">
          <div class="star-label">
            Thu nhập
            <img src="/image/iconquygiatoc.png" alt="Thu nhập" class="label-icon" />
          </div>
          <div class="difficulty-stars">
            <svg v-for="i in 5" :key="i" class="star" :class="{ active: i <= moneyStars }" xmlns="http://www.w3.org/2000/svg" width="13" height="12" viewBox="0 0 13 12" fill="none">
              <path d="M6.50195 0.5C6.51697 0.5 6.53189 0.504581 6.54395 0.511719L6.56641 0.533203L8.30273 3.82422L8.41992 4.04688L8.66895 4.08594L12.4443 4.66504L12.4463 4.66602C12.4784 4.6709 12.4934 4.6892 12.498 4.70312C12.5006 4.71063 12.5002 4.71665 12.499 4.72168L12.4873 4.74121L9.78418 7.35547L9.5957 7.53711L9.6377 7.79492L10.2354 11.4434V11.4443C10.2366 11.4523 10.2358 11.4592 10.2334 11.4648C10.2309 11.4706 10.226 11.4781 10.2158 11.4854C10.192 11.5021 10.1576 11.504 10.1338 11.4922H10.1328L6.72266 9.81641L6.50195 9.70801L6.28125 9.81641L2.87012 11.4912C2.84208 11.5048 2.80924 11.5016 2.78613 11.4854C2.76766 11.4722 2.76402 11.4552 2.76562 11.4453L3.36133 7.79492L3.40332 7.53711L3.21582 7.35547L0.513672 4.74219C0.506223 4.73441 0.502534 4.72675 0.500977 4.7207C0.499443 4.71452 0.500046 4.70879 0.501953 4.70312C0.506091 4.69085 0.522385 4.67093 0.554688 4.66602V4.66504L4.33301 4.08594L4.58203 4.04688L4.69922 3.8252L6.4375 0.532227L6.43848 0.533203C6.44198 0.526716 6.44902 0.518775 6.46094 0.511719C6.47293 0.504622 6.48702 0.500037 6.50195 0.5Z" stroke="#FECD08"/>
            </svg>
          </div>
        </div>
        <div class="divider"></div>
        <div class="star-group">
          <div class="star-label">
            EXP
            <img src="/image/iconlevelgiatoc.png" alt="EXP" class="label-icon" />
          </div>
          <div class="difficulty-stars">
            <svg v-for="i in 5" :key="i" class="star" :class="{ active: i <= expStars }" xmlns="http://www.w3.org/2000/svg" width="13" height="12" viewBox="0 0 13 12" fill="none">
              <path d="M6.50195 0.5C6.51697 0.5 6.53189 0.504581 6.54395 0.511719L6.56641 0.533203L8.30273 3.82422L8.41992 4.04688L8.66895 4.08594L12.4443 4.66504L12.4463 4.66602C12.4784 4.6709 12.4934 4.6892 12.498 4.70312C12.5006 4.71063 12.5002 4.71665 12.499 4.72168L12.4873 4.74121L9.78418 7.35547L9.5957 7.53711L9.6377 7.79492L10.2354 11.4434V11.4443C10.2366 11.4523 10.2358 11.4592 10.2334 11.4648C10.2309 11.4706 10.226 11.4781 10.2158 11.4854C10.192 11.5021 10.1576 11.504 10.1338 11.4922H10.1328L6.72266 9.81641L6.50195 9.70801L6.28125 9.81641L2.87012 11.4912C2.84208 11.5048 2.80924 11.5016 2.78613 11.4854C2.76766 11.4722 2.76402 11.4552 2.76562 11.4453L3.36133 7.79492L3.40332 7.53711L3.21582 7.35547L0.513672 4.74219C0.506223 4.73441 0.502534 4.72675 0.500977 4.7207C0.499443 4.71452 0.500046 4.70879 0.501953 4.70312C0.506091 4.69085 0.522385 4.67093 0.554688 4.66602V4.66504L4.33301 4.08594L4.58203 4.04688L4.69922 3.8252L6.4375 0.532227L6.43848 0.533203C6.44198 0.526716 6.44902 0.518775 6.46094 0.511719C6.47293 0.504622 6.48702 0.500037 6.50195 0.5Z" stroke="#FECD08"/>
            </svg>
          </div>
        </div>
        <div class="divider"></div>
        <div class="star-group">
          <div class="star-label">
            Độ chủ động
            <img src="/image/tocdo.png" alt="Độ khó" class="label-icon" />
          </div>
          <div class="difficulty-stars">
            <svg v-for="i in 5" :key="i" class="star" :class="{ active: i <= activeStars }" xmlns="http://www.w3.org/2000/svg" width="13" height="12" viewBox="0 0 13 12" fill="none">
              <path d="M6.50195 0.5C6.51697 0.5 6.53189 0.504581 6.54395 0.511719L6.56641 0.533203L8.30273 3.82422L8.41992 4.04688L8.66895 4.08594L12.4443 4.66504L12.4463 4.66602C12.4784 4.6709 12.4934 4.6892 12.498 4.70312C12.5006 4.71063 12.5002 4.71665 12.499 4.72168L12.4873 4.74121L9.78418 7.35547L9.5957 7.53711L9.6377 7.79492L10.2354 11.4434V11.4443C10.2366 11.4523 10.2358 11.4592 10.2334 11.4648C10.2309 11.4706 10.226 11.4781 10.2158 11.4854C10.192 11.5021 10.1576 11.504 10.1338 11.4922H10.1328L6.72266 9.81641L6.50195 9.70801L6.28125 9.81641L2.87012 11.4912C2.84208 11.5048 2.80924 11.5016 2.78613 11.4854C2.76766 11.4722 2.76402 11.4552 2.76562 11.4453L3.36133 7.79492L3.40332 7.53711L3.21582 7.35547L0.513672 4.74219C0.506223 4.73441 0.502534 4.72675 0.500977 4.7207C0.499443 4.71452 0.500046 4.70879 0.501953 4.70312C0.506091 4.69085 0.522385 4.67093 0.554688 4.66602V4.66504L4.33301 4.08594L4.58203 4.04688L4.69922 3.8252L6.4375 0.532227L6.43848 0.533203C6.44198 0.526716 6.44902 0.518775 6.46094 0.511719C6.47293 0.504622 6.48702 0.500037 6.50195 0.5Z" stroke="#FECD08"/>
            </svg>
          </div>
        </div>
      </div>

      <!-- Other Buttons - Hiển thị khi đang làm việc và có otherbtn -->
      <div v-if="job.isWorking && hasOtherBtn" class="other-buttons-container" :class="{ 'vertical-layout': otherBtnCount >= 3 }">
        <button 
          v-for="(btn, index) in job.button.otherbtn" 
          :key="index"
          class="other-button"
          :class="{ 'wide-button': otherBtnCount >= 3 }"
          @click="handleOtherBtnClick(btn)"
        >
          {{ btn.buttonname }}
        </button>
      </div>

      <!-- Start/Stop Job Button -->
      <button v-if="!job.isWorking" class="btn-start-job" @click="handleStartJob">
        BẮT ĐẦU CÔNG VIỆC
        <img src="/image/Primary3.png" alt="Start" class="button-icon" />
      </button>
      
      <button v-else class="btn-stop-job" @click="$emit('stopJob')">
        KẾT THÚC CÔNG VIỆC
        <img src="/image/clone.png" alt="Stop" class="button-icon" />
      </button>
    </div>

    <!-- Bottom Section: Skill Level & Upgrade (luôn hiển thị) -->
    <!-- UI mới cho nghề không có upgrade -->
    <div v-if="!job.hasLevel || !job.upgradeJob || !job.upgradeJob.eventname" class="job-upgrade-section no-upgrade">
      <!-- Background Video -->
      <video 
        class="background-video" 
        autoplay 
        loop 
        muted 
        playsinline
      >
        <source src="/image/capdo.mp4" type="video/mp4">
      </video>

      <!-- Content -->
      <div class="no-upgrade-content">
        <!-- Khối 1: Cấp độ nghề hiện tại + TỐI ĐA -->
        <div class="upgrade-block">
          <div class="no-upgrade-title">Cấp độ nghề hiện tại</div>
          <div class="level-badge-wrapper">
            <img src="/image/Frame135.png" alt="Frame" class="badge-frame" />
            <div class="level-badge-text">TỐI ĐA</div>
          </div>
        </div>

        <!-- Khối 2: Tổng điểm tích lũy + Điểm -->
        <div class="upgrade-block">
          <div class="points-title">Tổng điểm tích lũy</div>
          <div class="points-badge-wrapper">
            <img src="/image/Frame136.png" alt="Frame" class="badge-frame" />
            <div class="points-badge-text">{{ job.skills?.exp || 0 }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- UI cũ cho nghề có upgrade -->
    <div v-else class="job-upgrade-section">
      <!-- Khối 1: Cấp độ nghề hiện tại -->
      <div class="skill-header">
        <span class="section-title">Cấp độ nghề hiện tại</span>
        <span class="skill-level-badge" v-if="job.hasLevel">Level {{ job.skills?.level || 1 }}</span>
        <span class="skill-level-badge no-level" v-else>VÔ CẤP</span>
      </div>

      <!-- Khối 2: Tích lũy nghề và Level nhân vật -->
      <div class="skill-progress-container">
        <!-- Tích lũy nghề -->
        <div class="skill-progress-item">
          <div class="skill-row">
            <div class="section-title">Tích lũy nghề</div>
            <div class="exp-value">
              <span class="current-value">{{ job.skills?.exp || 0 }}</span>
              <span class="max-value">/{{ job.skills?.maxExp || 0 }}</span>
            </div>
          </div>
          <div class="exp-bar">
            <div class="exp-progress" :style="{ width: expPercentage + '%' }"></div>
          </div>
        </div>

        <!-- Level nhân vật -->
        <div class="skill-progress-item">
          <div class="skill-row">
            <div class="section-title">Level nhân vật</div>
            <div class="level-value">
              <span class="current-value">{{ job.skills?.playerLevel || 1 }}</span>
              <span class="max-value">/{{ job.skills?.requiredLevel || 1 }}</span>
            </div>
          </div>
          <div class="level-bar">
            <div class="level-progress" :style="{ width: levelPercentage + '%' }"></div>
          </div>
        </div>
      </div>

      <!-- Mô tả -->
      <div class="skill-description" v-html="job.skills?.description || 'Tích lũy đủ điểm nghề và Level của bạn để nâng cấp nghề.<br>Khi nâng cấp nghề bạn sẽ được nhận thêm phần thưởng thu nhập và EXP khi làm nghề.'">
      </div>

      <!-- Upgrade Button -->
      <button 
        class="btn-upgrade" 
        :class="{ disabled: !job.hasLevel || !job.upgradeJob || !job.upgradeJob.eventname }"
        :disabled="!job.hasLevel || !job.upgradeJob || !job.upgradeJob.eventname"
        @click="job.hasLevel && job.upgradeJob && job.upgradeJob.eventname ? $emit('upgradeSkill') : null"
      >
        <span v-if="!job.hasLevel">KHÔNG CÓ NÂNG CẤP</span>
        <span v-else>NÂNG CẤP NGHỀ</span>
        <img src="/image/Primary2.png" alt="Upgrade" class="button-icon" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import MethodPopup from './MethodPopup.vue'

const props = defineProps({
  job: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['startJob', 'stopJob', 'upgradeSkill', 'otherBtnClick'])

const showMethodPopup = ref(false)

// Handler khi ảnh load thành công
const handleImageLoad = (event) => {
  console.log('✅ Image loaded successfully:', event.target.src)
}

// Handler khi ảnh load thất bại
const handleImageError = (event) => {
  console.error('❌ Image failed to load:', event.target.src)
  console.error('Trying fallback to job.image:', props.job.image)
  // Fallback về ảnh mặc định
  event.target.src = props.job.image
}

// Computed để lấy ảnh tool theo level
const getToolImage = computed(() => {
  let toolImage = props.job.toolImage
  
  // Xử lý path từ Lua có thể có "./image/" prefix hoặc dấu phẩy
  if (typeof toolImage === 'string') {
    toolImage = toolImage.replace('./image/', '').replace(/^image\//, '').split(',')[0].trim()
  }
  
  const currentLevel = props.job.skills?.level || 1
  
  // Nếu nghề có level, tự động thêm số level vào tên file
  if (props.job.hasLevel && toolImage) {
    // Loại bỏ .png nếu có
    const baseName = toolImage.replace('.png', '')
    // Tạo tên file theo pattern: baseName + level + .png
    const leveledImage = `./image/${baseName}${currentLevel}.png`
    console.log('Job:', props.job.name, 'Level:', currentLevel, 'Image:', leveledImage)
    return leveledImage
  }
  
  // Nếu toolImage là string thông thường (nghề không có level)
  if (toolImage) {
    // Thêm .png nếu chưa có
    const fileName = toolImage.endsWith('.png') ? toolImage : `${toolImage}.png`
    return `./image/${fileName}`
  }
  
  // Fallback về image mặc định
  return props.job.image
})

const expPercentage = computed(() => {
  const exp = props.job.skills?.exp || 0
  const maxExp = props.job.skills?.maxExp || 100
  return Math.min((exp / maxExp) * 100, 100)
})

const levelPercentage = computed(() => {
  const playerLevel = props.job.skills?.playerLevel || 1
  const requiredLevel = props.job.skills?.requiredLevel || 1
  return Math.min((playerLevel / requiredLevel) * 100, 100)
})

// Tính phần trăm biến động IC (tiền)
// Dữ liệu đã là % từ f17_biendong, không cần tính toán
const marketMoneyPercent = computed(() => {
  const marketMoney = props.job.requirements?.marketMoney
  if (marketMoney === undefined || marketMoney === null) return 0
  
  // marketMoney đã là % biến động từ f17_biendong (ví dụ: 14, -10)
  return Math.round(marketMoney)
})

// Tính phần trăm biến động EXP
const marketExpPercent = computed(() => {
  const marketExp = props.job.requirements?.marketExp
  if (marketExp === undefined || marketExp === null) return 0
  
  // marketExp đã là % biến động từ f17_biendong (ví dụ: 14, -10)
  return Math.round(marketExp)
})

// Tính số sao cho Thu nhập (Money) - từ 0-5 sao
const moneyStars = computed(() => {
  const process = props.job.process
  if (!process || !process.money) return 0
  
  const current = process.money.current || 0
  const target = process.money.target || 60
  const percentage = (current / target) * 100
  
  // Chuyển đổi phần trăm thành số sao (0-5)
  // 0-20% = 1 sao, 20-40% = 2 sao, 40-60% = 3 sao, 60-80% = 4 sao, 80-100% = 5 sao
  return Math.ceil(percentage / 20) || 0
})

// Tính số sao cho EXP - từ 0-5 sao
const expStars = computed(() => {
  const process = props.job.process
  if (!process || !process.exp) return 0
  
  const current = process.exp.current || 0
  const target = process.exp.target || 200
  const percentage = (current / target) * 100
  
  // Chuyển đổi phần trăm thành số sao (0-5)
  return Math.ceil(percentage / 20) || 0
})

// Tính số sao cho Độ chủ động (Active) - từ 0-5 sao
const activeStars = computed(() => {
  const process = props.job.process
  if (!process || !process.active) return 0
  
  const current = process.active.current || 0
  const target = process.active.target || 20
  const percentage = (current / target) * 100
  
  // Chuyển đổi phần trăm thành số sao (0-5)
  return Math.ceil(percentage / 20) || 0
})

// Kiểm tra xem nghề có methodBtn không
const hasMethodBtn = computed(() => {
  const methodBtn = props.job.button?.methodbtn
  return methodBtn && Object.keys(methodBtn).length > 0
})

// Xử lý khi bấm nút "Bắt đầu công việc"
const handleStartJob = () => {
  // Chỉ hiển thị popup khi CHƯA làm việc và có methodBtn
  if (!props.job.isWorking && hasMethodBtn.value) {
    // Nếu có methodBtn và chưa làm việc, hiển thị popup
    showMethodPopup.value = true
  } else {
    // Nếu không có methodBtn, trigger event startJob bình thường
    emit('startJob')
  }
}

// Xử lý khi chọn method từ popup
const handleMethodSelect = (option) => {
  showMethodPopup.value = false
  // Emit event với thông tin method được chọn
  emit('startJob', option)
}

// Kiểm tra xem nghề có otherBtn không
const hasOtherBtn = computed(() => {
  const otherBtn = props.job.button?.otherbtn
  return otherBtn && Array.isArray(otherBtn) && otherBtn.length > 0
})

// Đếm số lượng otherbtn
const otherBtnCount = computed(() => {
  const otherBtn = props.job.button?.otherbtn
  return otherBtn && Array.isArray(otherBtn) ? otherBtn.length : 0
})

// Xử lý khi bấm nút otherbtn - chỉ gọi event của button
const handleOtherBtnClick = (btn) => {
  emit('otherBtn', btn)
}
</script>

<style scoped>
.job-actions {
  width: 471px;
  height: 768px;
  display: flex;
  flex-direction: column;
  gap: 32px;
  overflow-y: auto;
}

.job-start-section {
  border: 2px solid #FECD08;
  border-radius: 10px;

  display: flex;
  padding: 2rem;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  flex: 1 0 0;
  align-self: stretch;
  background: rgba(0, 0, 0, 0.50);
  transition: background 0.3s ease;
}

/* Style khi đang làm việc */
.job-start-section.working-state {
  border-radius: 0.625rem;
  border: 2px solid var(--FECD08, #FECD08);
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.50) 0%, #F9E000 100%);
}

.job-upgrade-section {
  width: 471px;
  height: 368px;
  background: rgba(0, 0, 0, 0.50);
  border: 2px solid #FECD08;
  border-radius: 10px;
  padding: 32px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.job-icon {
  width: 407px;
  height: 140px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

/* Layout khi đang làm việc - logo nhỏ bên trái */
.job-icon.working-layout {
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  height: auto;
  gap: 16px;
}

.icon-circle {
  position: relative;
  overflow: hidden;
  display: flex;
  height: 5.75rem;
  padding: 1rem;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border-radius: 3.125rem;
  border: 1px solid var(--FECD08, #FECD08);
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.00) 0%, #4CBA6F 100%);
  transition: all 0.3s ease;
}

/* Logo nhỏ lại khi đang làm việc */
.icon-circle.small {
  height: 3.5rem;
  width: 3.5rem;
  padding: 0.5rem;
  flex-shrink: 0;
}

.icon-bg {
  position: absolute;
  width: 100%;
  height: 100%;
      background: radial-gradient(circle, rgb(6 35 25 / 73%) 0%, rgba(0, 80, 50, 0.3) 100%);
  z-index: 0;
}

.job-tool-icon {
  position: relative;
  width: 3.75rem;
  flex: 1 0 0;
  aspect-ratio: 1/1;
  transition: all 0.3s ease;
}

/* Icon nhỏ lại khi đang làm việc */
.icon-circle.small .job-tool-icon {
  width: 2.5rem;
}

.job-name {
  color: var(--FECD08, #FECD08);
  text-align: center;
  font-family: "Baloo 2";
  font-size: 1.5rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

/* Text căn trái khi đang làm việc */
.working-layout .job-name {
  text-align: left;
  flex: 1;
  font-size: 1.3rem;
}

.requirements-info {
  width: 100%;
  background: #5D5D5F;
  border-radius: 6px;
  padding: 15px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.requirements-header {
  /* width: 407px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 25px; */

  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  align-self: stretch;
}

.req-label {
  white-space: nowrap;

  color: #FFF;
  text-align: center;
  leading-trim: both;
  text-edge: cap;

  /* Regular 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
}

.req-badge {
  padding: 4px 12px;
  font-weight: 700;
  font-size: 12px;
  white-space: nowrap;
}

.money-positive {
  border: 1px solid #00CC66;
  color: #4CBA6F;
  text-align: center;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
  display: flex;
  padding: 0rem 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  height: 20px;
}

.money-negative {
  border: 1px solid #FF0066;
  color: #ED2449;
  text-align: center;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
  display: flex;
  padding: 0rem 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  height: 20px;
}

.exp-positive {
  border: 1px solid #00CC66;
  color: #4CBA6F;
  text-align: center;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
  display: flex;
  padding: 0rem 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  height: 20px;
}

.exp-negative {
  border: 1px solid #FF0066;
  color: #ED2449;
  text-align: center;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
  display: flex;
  padding: 0rem 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  height: 20px;
}

.level-badge {
  border: 1px solid #00CC66 ;

  color: var(--4CBA6F, #4CBA6F);
  text-align: center;
  leading-trim: both;
  text-edge: cap;

  /* Bold 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
  display: flex;
  padding: 0rem 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
}

.exp-badge {
  border: 1px solid #FF0066;

  color: var(--0132F7, #ED2449);
  text-align: center;
  leading-trim: both;
  text-edge: cap;

  /* Bold 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;

  display: flex;
  padding: 0rem 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
}

.stars-row {
  /* width: 407px;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: space-between; */
  gap: 5px;
  display: flex;
  padding: 0.625rem 0;
  justify-content: center;
  align-items: center;
  align-self: stretch;
}

.star-group {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
}

.divider {
  width: 1px;
  height: 40px;
  background: rgba(255, 255, 255, 0.2);
  margin: 0 10px;
}

.star-label {
  white-space: nowrap;
  display: flex;
  align-items: center;
  gap: 6px;
  color: #FFF;
  text-align: center;
  leading-trim: both;
  text-edge: cap;

  /* Regular 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
}

.label-icon {
  width: 0.875rem;
  height: 0.875rem;
  aspect-ratio: 1/1;
}

.difficulty-stars {
  display: flex;
  align-items: center;
  gap: 0.3125rem;
}

.star {
  width: 13px;
  height: 12px;
}

.star path {
  stroke-width: 1px;
  fill: none;
}

.star.active path {
  stroke: #FECD08;
  stroke-width: 1px;
  fill: #FECD08;
}

.other-buttons-container {
  width: 407px;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: nowrap;
  margin-bottom: 10px;
}

/* Layout dọc khi có 3+ options */
.other-buttons-container.vertical-layout {
  flex-direction: column;
  align-items: stretch;
  gap: 0.75rem;
  flex-wrap: nowrap;
}

.other-button {
  border: none;
  border-radius: 0.625rem;
  color: #000;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-weight: 700;
  text-transform: uppercase;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
  display: flex;
  padding: 0.6rem 1.5rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  background: var(--White, #FFF);
  flex: 1;
  white-space: nowrap;
}

/* Nút dài ra khi có 3+ options */
.other-button.wide-button {
  width: 100%;
  flex: unset;
  padding: 0.6rem 0.625rem;
}

.other-button:hover {
  background: #FECD08;
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(254, 205, 8, 0.5);
}

.other-button:active {
  transform: translateY(-1px);
}

.btn-start-job {
  width: 407px;
  height: 46px;
  cursor: pointer;
  transition: all 0.3s;
  text-transform: uppercase;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #000;
  leading-trim: both;
  text-edge: cap;

  /* Bold 20 */
  font-family: "Baloo 2";
  font-size: 1.25rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;

  border-radius: 0.3125rem;
  background: var(--Gold, #FECD08);
  display: flex;
  padding: 1rem 0;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  align-self: stretch;
}

.btn-start-job:hover {
  background: #FFFFFF;
  transform: translateY(-2px);
}

.btn-stop-job {
  width: 407px;
  height: 46px;
  cursor: pointer;
  transition: all 0.3s;
  text-transform: uppercase;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  border-radius: 0.3125rem;
  background: var(--0132F7, #ED2449);
  color: var(--White, #FFF);
  leading-trim: both;
  text-edge: cap;

  /* Bold 20 */
  font-family: "Baloo 2";
  font-size: 1.25rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
  display: flex;
  padding: 1rem 0;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  align-self: stretch;
  
}

.btn-stop-job:hover {
  background: #FF0066;
  transform: translateY(-2px);
}

.button-icon {
  width: 14px;
  height: 14px;
  object-fit: contain;
}

.skill-section {
  width: 100%;
  background: #5D5D5F;
  border-radius: 6px;
  padding: 15px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.skill-section {
  width: 100%;
  background: #5D5D5F;
  border-radius: 6px;
  padding: 15px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.skill-section {
  width: 100%;
  background: #5D5D5F;
  border-radius: 6px;
  padding: 15px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.skill-header {
  width: 407px;
  height: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.skill-progress-container {
  width: 407px;
  display: flex;
  flex-direction: column;
  gap: 0px;
}

.skill-progress-item {
  width: 407px;
  height: 58px;
  display: flex;
  flex-direction: column;
  gap: 0px;
}

.skill-row {
  width: 407px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}


.exp-progress,
.level-progress {
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  background: linear-gradient(90deg, #FECD08 0%, #FFD93D 100%);
  transition: width 0.5s ease;
}

.skill-level-badge {
    border: 1px solid #FECD08;

    display: flex;
    padding: 0rem 0.625rem;
    justify-content: center;
    align-items: center;
    gap: 0.625rem;
    color: var(--FECD08, #FECD08);
    text-align: center;
    leading-trim: both;
    text-edge: cap;

    /* Bold 16 */
    font-family: "Baloo 2";
    font-size: 1rem;
    font-style: normal;
    font-weight: 700;
    line-height: normal;
}

.skill-level-badge.no-level {
    border-color: #666;
    color: #666;
}

.skill-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.exp-value,
.level-value {
  text-align: center;
  leading-trim: both;
  text-edge: cap;

  /* Bold 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

.exp-value .current-value,
.level-value .current-value {
  color: var(--White, #FFF);
}

.exp-value .max-value,
.level-value .max-value {
  color: #FECD08;
}

.section-title {
  color: var(--White, #FFF);
  text-align: center;
  leading-trim: both;
  text-edge: cap;

  /* Bold 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
}

.skill-level {
  color: #FFFFFF;
  font-weight: 700;
  font-size: 15px;
  padding: 8px;
  background: #3A393C;
  border-radius: 4px;
  text-align: center;
}

.exp-bar {
  position: relative;
  width: 100%;
  height: 1.2rem;
  overflow: hidden;
  border-radius: 3.125rem;
  background: var(--Grey-2, #3A393C);
}

.exp-progress {
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  background: linear-gradient(90deg, #FECD08 0%, #FFD93D 100%);
  transition: width 0.5s ease;
}

.level-bar {
  position: relative;
  width: 100%;
  height: 1.2rem;
  overflow: hidden;
  border-radius: 3.125rem;
  background: var(--Grey-2, #3A393C);
}

.level-progress {
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  background: linear-gradient(90deg, #FECD08 0%, #FFD93D 100%);
  transition: width 0.5s ease;
}

.exp-text {
  position: absolute;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #FFFFFF;
  font-weight: 700;
  font-size: 13px;
  z-index: 1;
}

.skill-level {
  color: #FFFFFF;
  font-weight: 700;
  font-size: 15px;
  padding: 8px;
  background: #3A393C;
  border-radius: 4px;
  text-align: center;
}

.level-info {
  color: #FFFFFF;
  font-weight: 700;
  font-size: 14px;
  padding: 8px;
  background: #3A393C;
  border-radius: 4px;
  text-align: center;
}

.skill-description {
  /* width: 407px;
  color: #FFFFFF;
  font-family: 'Baloo 2', sans-serif;
  font-weight: 400;
  font-style: normal;
  font-size: 15px;
  line-height: 175%;
  letter-spacing: 0%;
  border-radius: 4px;
  margin-top: 12px;
  margin-bottom: 12px; */
    color: #FFF;
  leading-trim: both;
  text-edge: cap;

  /* Regular 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
}

.btn-upgrade {
  width: 407px;
  height: 51px;
  cursor: pointer;
  transition: all 0.3s;
  text-transform: uppercase;

  color: #000;
  leading-trim: both;
  text-edge: cap;

  /* Bold 20 */
  font-family: "Baloo 2";
  font-size: 1.25rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
  border-radius: 0.3125rem;
  opacity: 0.5;
  background: var(--4CBA6F, #4CBA6F);
  display: flex;
  padding: 1rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  align-self: stretch;
}

.btn-upgrade:hover {
  background: #FFFFFF;
  transform: translateY(-2px);
}

.btn-upgrade.disabled,
.btn-upgrade:disabled {

  display: flex;
  padding: 1rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  align-self: stretch;
  border-radius: 0.3125rem;
  opacity: 0.5;
  background: var(--5D5D5F, #5D5D5F);
}

.btn-upgrade.disabled:hover,
.btn-upgrade:disabled:hover {
  background: #3A393C;
  transform: none;
}

/* Styles cho UI không có upgrade */
.job-upgrade-section.no-upgrade {
  position: relative;
  overflow: hidden;
  display: flex;
  padding: 2rem;
  flex-direction: column;
  justify-content: space-between;
  align-items: flex-start;
  flex: 1 0 0;
  align-self: stretch;
  border-radius: 0.625rem;
  border: 2px solid var(--FECD08, #FECD08);
}

.background-video {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  z-index: 0;
}

.no-upgrade-content {
  z-index: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  gap: 2rem;
  flex: 1 0 0;
  align-self: stretch;
}

.upgrade-block {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  align-self: stretch;
  margin-top: -4px;
}

.no-upgrade-title {
  color: #FFF;
  leading-trim: both;
  text-edge: cap;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

.level-badge-wrapper,
.points-badge-wrapper {
  position: relative;
  display: flex;
  width: 12.5rem;
  height: 6.25rem;
  padding: 0.625rem 1.25rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
}

.badge-frame {
  position: absolute;
  object-fit: contain;
  z-index: 0;
  display: flex;
  padding: 0.625rem 1.25rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
}

.level-badge-text {
  position: relative;
  color: #000;
  text-align: center;
  leading-trim: both;
  text-edge: cap;

  /* Bold 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

.points-title {
  color: #FFF;
  leading-trim: both;
  text-edge: cap;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

.points-badge-text {
  position: relative;
  color: #000;
  text-align: center;
  leading-trim: both;
  text-edge: cap;

  /* Bold 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

</style>
