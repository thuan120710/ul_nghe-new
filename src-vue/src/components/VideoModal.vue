<template>
  <div v-if="isVisible" class="video-modal-overlay" @click="handleClose">
    <div class="video-modal" @click.stop>
      <!-- Close Button -->
      <button class="btn-close" @click="handleClose">✕</button>

      <!-- Video Container -->
      <div class="video-container">
        <iframe
          v-if="embedUrl"
          :src="embedUrl"
          frameborder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen
          class="video-player"
        ></iframe>
        <div v-else class="error-message">
          URL video không hợp lệ
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  isVisible: {
    type: Boolean,
    default: false
  },
  videoUrl: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['close'])

// Chuyển đổi YouTube URL sang embed URL
const embedUrl = computed(() => {
  if (!props.videoUrl) return ''
  
  // Xử lý các dạng URL YouTube khác nhau
  let videoId = ''
  
  // Dạng: https://www.youtube.com/watch?v=VIDEO_ID
  if (props.videoUrl.includes('youtube.com/watch')) {
    const urlParams = new URLSearchParams(props.videoUrl.split('?')[1])
    videoId = urlParams.get('v')
  }
  // Dạng: https://youtu.be/VIDEO_ID
  else if (props.videoUrl.includes('youtu.be/')) {
    videoId = props.videoUrl.split('youtu.be/')[1].split('?')[0]
  }
  // Dạng: https://www.youtube.com/embed/VIDEO_ID
  else if (props.videoUrl.includes('youtube.com/embed/')) {
    videoId = props.videoUrl.split('embed/')[1].split('?')[0]
  }
  
  if (videoId) {
    return `https://www.youtube.com/embed/${videoId}?autoplay=1&rel=0`
  }
  
  return ''
})

const handleClose = () => {
  emit('close')
}
</script>

<style scoped>
.video-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.85);
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: 18.5rem;
  z-index: 9999;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.video-modal {
  position: relative;
  background: transparent;
  animation: slideUp 0.3s ease;
  width: 111rem;
  height: 58rem;
}

@keyframes slideUp {
  from {
    transform: translateY(50px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.btn-close {
  width: 35px;
  height: 35px;
  background: rgba(255, 0, 0, 0.2);
  color: #ff0000;
  font-size: 20px;
  cursor: pointer;
  transition: all 0.3s;
  z-index: 10;

  display: flex;
  padding: 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  border-radius: 3.125rem;
  border: 1px solid var(--Red-Pink, #ED2449);
  position: absolute;
  right: 0;
  top: -2.375rem;
}

.btn-close:hover {
  background: rgba(255, 0, 0, 0.4);
  transform: scale(1.1);
}

.video-container {
  position: relative;
  width: 100%;
  height: 100%;
  background: #000;
  border: 3px solid #FECD08;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 0 20px rgba(254, 205, 8, 0.4);
}

.video-player {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.error-message {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #ff0000;
  font-family: "Baloo 2", sans-serif;
  font-size: 1.2rem;
  text-align: center;
}
</style>
