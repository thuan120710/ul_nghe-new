<template>
  <div class="job-details">
    <!-- Job Image -->
    <div class="job-image">
      <img :src="job.image" :alt="job.name" />
    </div>

    <!-- Job Description -->
    <div class="job-description">
      <div class="section-title">Giới thiệu nghề {{ job.name }}</div>
      <div class="description-text" v-html="job.description"></div>
    </div>

    <!-- Rewards Section (nếu có) -->
    <div class="rewards-section" v-if="job.rewards && job.rewards.length > 0">
      <div class="label">Phần thưởng:</div>
      <div class="rewards">
        <div 
          v-for="(reward, index) in job.rewards" 
          :key="index"
          class="reward-item"
        >
          <img :src="reward.icon" :alt="reward.name" />
        </div>
      </div>
    </div>

    <!-- Requirements Section (nếu có) -->
    <div class="requirements-section" v-if="job.tools && job.tools.length > 0">
      <div class="label">Yêu cầu dụng cụ:</div>
      <div class="requirements">
        <div 
          v-for="(tool, index) in job.tools" 
          :key="index"
          class="req-item"
        >
          <img :src="tool.icon" :alt="tool.name" />
        </div>
      </div>
    </div>

    <!-- Guide Section -->
    <div class="guide-section" v-if="job.guide">
      <div class="guide-label">{{ job.guide.title }}</div>
      <div class="guide-text" v-html="job.guide.description"></div>
    </div>

    <!-- Video Button -->
    <button class="btn-video" @click="$emit('watchVideo')" v-if="job.videoUrl">
      XEM VIDEO HƯỚNG DẪN
      <img src="/image/Primary.png" alt="Play" class="video-icon" />
    </button>
  </div>
</template>

<script setup>
defineProps({
  job: {
    type: Object,
    required: true
  }
})

defineEmits(['watchVideo'])
</script>

<style scoped>
.job-details {
  width: 471px;
  height: 768px;
  background: #3A393C;
  border: 2px solid #FECD08;
  border-radius: 8px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 15px;
  overflow-y: auto;
}

.job-image {
  position: relative;
  width: 426px;
  height: 167.44px;
  border-radius: 6px;
  overflow: hidden;
}

.job-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.job-description {
  width: 407px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.section-title {
  color: var(--FECD08, #FECD08);
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

.description-text {
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

.label {
  color: var(--FECD08, #FECD08);
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

.rewards-section {
  width: 407px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.rewards {
  width: 407px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.reward-item {
  background: #5D5D5F;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  padding: 0.3125rem;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  border-radius: 0.3125rem;
}

.reward-item:hover {
  transform: scale(1.05);
  box-shadow: 0 0 15px rgba(254, 205, 8, 0.5);
}


.reward-item img {
  width: 1.875rem;
  height: 1.875rem;
  aspect-ratio: 1/1;
}

.requirements-section {
  width: 407px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.requirements {
  display: flex;
  gap: 10px;
}

.req-item {
  background: #5D5D5F;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  padding: 0.3125rem;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  border-radius: 0.3125rem;
}

.req-item:hover {
  transform: scale(1.05);
  box-shadow: 0 0 15px rgba(254, 205, 8, 0.5);
}

.req-item img {
  width: 30px;
  height: 30px;
  object-fit: contain;
}

.guide-section {
  width: 420px;
  max-height: 140px;
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  gap: 0.625rem;
  overflow-y: auto;
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE and Edge */
}

/* Ẩn thanh cuộn cho Chrome/Safari */
.guide-section::-webkit-scrollbar {
  display: none;
}

.guide-label {
  color: var(--FECD08, #FECD08);
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
}

.guide-text {
  /* color: #FFFFFF;
  font-size: 15px;
  line-height: 1.5; */
  color: #FFF;
  leading-trim: both;
  text-edge: cap;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
}

.guide-steps {
  display: flex;
  flex-direction: column;
  gap: 6px;
  color: #FFF;
  leading-trim: both;
  text-edge: cap;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
}

.step {
  padding-left: 10px;
  color: #FFF;
  leading-trim: both;
  text-edge: cap;
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
}

.btn-video {
  padding: 0.6rem;
  color: #FFFFFF;
  font-weight: 700;
  font-size: 1.25rem;
  cursor: pointer;
  transition: all 0.3s;
  margin-top: 18px;

  display: flex;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  align-self: stretch;
  border-radius: 0.3125rem;
  background: var(--0132F7, #0132F7);
}

.btn-video:hover {
  background: #FFFFFF;
  transform: translateY(-2px);
  color: #000000;
}

.btn-video .video-icon {
  width: 14px;
  height: 14px;
  object-fit: contain;
}
</style>
