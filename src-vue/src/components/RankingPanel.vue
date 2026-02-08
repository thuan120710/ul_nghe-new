<template>
  <div class="ranking-panel">
    <!-- Top Section with Video Background -->
    <div class="top-section">
      <video 
        ref="videoRef"
        class="video-background" 
        autoplay 
        loop 
        muted 
        playsinline 
        preload="auto"
        @error="videoError = true"
      >
        <source :src="videoSrc" type="video/mp4">
        Your browser does not support the video tag.
      </video>
      <div class="video-overlay" :class="{ 'video-error': videoError }"></div>
      
      <div class="top-content">
        <!-- Title with decorative corners -->
        <div class="panel-header">
          <div class="title">{{ ranking.title }}</div>
        </div>

        <!-- Top 3 Badges -->
        <div class="top-badges">
          <div class="badge-item" v-for="badge in [2, 1, 3]" :key="badge" :class="'position-' + badge">
            <div class="badge-icon" :class="'badge-' + badge">
              <img :src="getBadgeImage(badge)" :alt="'Top ' + badge" class="badge-image" />
            </div>
            <div class="badge-info">
              <div class="badge-name">{{ getTopPlayer(badge).name }}</div>
              <div class="badge-level">{{ getTopPlayer(badge).phone }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Ranking Table -->
    <div class="ranking-table">
      <div class="table-header">
        <div class="col-rank">Xếp hạng</div>
        <div class="col-name">Tên công dân</div>
        <div class="col-cccd">CCCD</div>
        <div class="col-phone">Tích lũy nghề</div>
      </div>

      <div class="table-body">
        <!-- Overlay khi chưa có dữ liệu -->
        <div v-if="!ranking.ranks || ranking.ranks.length === 0" class="no-data-overlay">
          <div class="no-data-content">
            <div class="no-data-icon">📊</div>
            <div class="no-data-text">Thông tin sẽ sớm cập nhật</div>
          </div>
        </div>

        <!-- Dữ liệu bảng xếp hạng -->
        <div 
          v-for="player in ranking.ranks" 
          :key="player.position"
          class="table-row"
          :class="{ 
            'top-rank': player.position <= 3,
            'current-player': isCurrentPlayer(player.name)
          }"
        >
          <div class="col-rank">
            <img 
              v-if="player.position <= 3" 
              :src="`./image/rank${player.position}.png`" 
              :alt="`Rank ${player.position}`"
              class="rank-icon"
            />
            <span v-else class="rank-number">{{ player.position }}</span>
          </div>
          <div class="col-name">{{ player.name }}</div>
          <div class="col-cccd">{{ player.level }}</div>
          <div class="col-phone">{{ player.phone }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'

const props = defineProps({
  ranking: {
    type: Object,
    required: true
  }
})

// Video source - sử dụng đường dẫn từ public folder
const videoSrc = './image/Comp1.mp4'
const videoRef = ref(null)
const videoError = ref(false)

onMounted(() => {
  if (videoRef.value) {
    videoRef.value.addEventListener('error', (e) => {
      console.error('Video load error:', e)
      videoError.value = true
    })
    
    videoRef.value.addEventListener('loadeddata', () => {
      console.log('Video loaded successfully')
    })
    
    // Force play video
    videoRef.value.play().catch(err => {
      console.error('Video play error:', err)
    })
  }
})

const getTopPlayer = (position) => {
  return props.ranking.ranks.find(p => p.position === position) || {}
}

const getBadgeImage = (position) => {
  return `./image/top${position}.png`
}

const isCurrentPlayer = (playerName) => {
  return playerName === props.ranking.currentPlayerName
}
</script>

<style scoped>
.ranking-panel {
  width: 471px;
  height: 768px;
  background: #3A393C;
  border: 2px solid #FECD08;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.top-section {
  position: relative;
  width: 100%;
  height: 384px;
  border-radius: 0;
  overflow: hidden;
  padding: 20px;
}

.video-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  z-index: 0;
}

.video-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

.video-overlay.video-error {
  background: linear-gradient(135deg, #1a2332 0%, #2a3545 100%);
}

.top-content {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.panel-header {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 15px 0;
}

.title {
  text-transform: uppercase;
  letter-spacing: 1px;

  color: var(--FECD08, #FECD08);
  text-align: center;
  font-family: "Baloo 2";
  font-size: 1.25rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

.top-badges {
  display: flex;
  justify-content: space-around;
  align-items: flex-end;
  gap: 15px;
}

.badge-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  transition: transform 0.3s;
}

.badge-item:hover {
  transform: translateY(-5px);
}

.badge-item.position-2 {
  order: 1;
  margin-bottom: 45px;
}

.badge-item.position-1 {
  order: 2;
  margin-bottom: 60px;
}

.badge-item.position-3 {
  order: 3;
  margin-bottom: 35px;
}

.badge-icon {
  position: relative;
  width: 7.1875rem;
  display: flex;
  align-items: center;
  justify-content: center;

  height: 7.1875rem;
  aspect-ratio: 1/1;
}

.badge-icon.badge-1 {
  width: 7.18769rem;
    height: 120px;
    height: 7.18769rem;
    /* align-self: stretch; */
    aspect-ratio: 1 / 1;
}

.badge-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.5));
}

.badge-icon.badge-1 .badge-image {
  filter: drop-shadow(0 0 15px rgba(254, 205, 8, 0.8));
  animation: pulse-gold 2s infinite;
}

@keyframes pulse-gold {
  0%, 100% {
    filter: drop-shadow(0 0 15px rgba(254, 205, 8, 0.8));
  }
  50% {
    filter: drop-shadow(0 0 25px rgba(254, 205, 8, 1));
  }
}

.badge-info {
  border: 1px solid #FECD08;
    border-radius: 10px;

    color: var(--Gold, #FECD08);
  text-align: center;
  leading-trim: both;
  text-edge: cap;
  font-family: "Baloo 2";
  font-size: 0.875rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
  display: flex;
  padding: 0.225rem 0.3125rem;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.badge-name {
  color: var(--Gold, #FECD08);
  text-align: center;
  leading-trim: both;
  text-edge: cap;
  font-family: "Baloo 2";
  font-size: 0.875rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
}

.badge-level {
  color: var(--Gold, #FECD08);
  text-align: center;
  leading-trim: both;
  text-edge: cap;
  font-family: "Baloo 2";
  font-size: 0.875rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
}

.ranking-table {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.table-header {
  display: grid;
  grid-template-columns: 80px 1fr 100px 100px;
  background: #000;
  border-radius: 0;
  font-size: 0.875rem;
  border-top: 2px solid #FECD08;
  border-bottom: 2px solid #FECD08;
  color: #FFF;
  text-align: center;
  font-family: "Baloo 2";
  font-style: normal;
  font-weight: 700;
  line-height: 0.875rem; /* 100% */

  padding: 1rem 1rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  align-self: stretch;
}

.table-body {
  flex: 1;
  overflow-y: auto;
  background: linear-gradient(135deg, 
    #1a2332 0%, 
    #2a3545 25%, 
    #1f2937 50%, 
    #2d3748 75%, 
    #1a2332 100%
  );
  border-radius: 0;
  position: relative;
}

.table-row {
  display: grid;
  grid-template-columns: 80px 1fr 100px 100px;
  font-size: 0.875rem;
  transition: all 0.3s;
  position: relative;
  z-index: 1;
  color: #FFF;
  text-align: center;
  font-family: "Baloo 2";
  font-style: normal;
  line-height: 0.875rem; /* 100% */

  padding: 0.3125rem 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  align-self: stretch;
}

.table-row:nth-child(odd) {
  background: rgba(40, 50, 70, 0.5);
}

.table-row:nth-child(even) {
  background: rgba(25, 35, 50, 0.5);
}

.table-row:hover {
  background: rgba(254, 205, 8, 0.08);
}

.table-row.current-player {
  background: linear-gradient(90deg, 
    rgba(254, 205, 8, 0.3) 0%, 
    rgba(254, 205, 8, 0.2) 50%, 
    rgba(254, 205, 8, 0.3) 100%
  ) !important;
  border-left: 3px solid #FECD08;
  border-right: 3px solid #FECD08;
  box-shadow: 0 0 15px rgba(254, 205, 8, 0.5);
}

.table-row.current-player .col-name {
  color: #FECD08;
  font-weight: 700;
}

.table-row.current-player .col-cccd,
.table-row.current-player .col-phone {
  color: #FECD08;
}

.col-rank {
  display: flex;
  align-items: center;
  justify-content: center;
}

.rank-icon {
  object-fit: contain;
  display: flex;
  height: 2.125rem;
  padding: 0 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  flex: 1 0 0;
}

.rank-number {
  width: 30px;
  height: 30px;
  font-weight: 400;
  display: flex;
  padding: 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  flex: 1 0 0;
}

.col-name {
  display: flex;
  align-items: center;
  font-weight: 700;
  justify-content: center;
  font-family: "Baloo 2";
  line-height: 0.875rem;
  color: #FFF;
  white-space: nowrap;

}

.col-cccd,
.col-phone {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.875rem;
}

.table-header .col-cccd,
.table-header .col-phone {
  font-weight: 700;
}

.table-row .col-cccd,
.table-row .col-phone {
  font-weight: 400;
}

/* Scrollbar styling */
.table-body::-webkit-scrollbar {
  width: 6px;
}

.table-body::-webkit-scrollbar-track {
  background: #3A393C;
  border-radius: 3px;
}

.table-body::-webkit-scrollbar-thumb {
  background: #FECD08;
  border-radius: 3px;
}

.table-body::-webkit-scrollbar-thumb:hover {
  background: #FFD93D;
}

/* No Data Overlay */
.no-data-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(5px);
  z-index: 10;
}

.no-data-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  padding: 2rem;
  background: rgba(58, 57, 60, 0.9);
  border: 2px solid #FECD08;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
}

.no-data-icon {
  font-size: 3rem;
  animation: pulse-icon 2s infinite;
}

@keyframes pulse-icon {
  0%, 100% {
    transform: scale(1);
    opacity: 0.8;
  }
  50% {
    transform: scale(1.1);
    opacity: 1;
  }
}

.no-data-text {
  color: #FECD08;
  text-align: center;
  font-family: "Baloo 2";
  font-size: 1.25rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
  text-transform: uppercase;
  letter-spacing: 1px;
}
</style>
