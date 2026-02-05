<template>
  <div class="job-actions">
    <!-- Top Section: Job Icon & Start Job -->
    <div class="job-start-section">
      <!-- Job Icon -->
      <div class="job-icon">
        <div class="icon-circle">
          <div class="icon-bg"></div>
          <img :src="job.toolImage || job.image" :alt="job.name" class="job-tool-icon" />
        </div>
        <div class="job-name">{{ job.name }}</div>
      </div>

      <!-- Requirements Info -->
      <div class="requirements-header">
        <span class="req-label">Biến động thị trường</span>
        <span class="req-badge level-badge">Level {{ job.requirements?.level || 1 }}</span>
        <span class="req-badge exp-badge">EXP {{ job.requirements?.exp || 0 }}</span>
      </div>

      <!-- Three Stars Row -->
      <div class="stars-row">
        <div class="star-group">
          <div class="star-label">
            Thu nhập
            <img src="/image/iconquygiatoc.png" alt="Thu nhập" class="label-icon" />
          </div>
          <div class="difficulty-stars">
            <svg v-for="i in 5" :key="i" class="star" :class="{ active: i <= 3 }" xmlns="http://www.w3.org/2000/svg" width="13" height="12" viewBox="0 0 13 12" fill="none">
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
            <svg v-for="i in 5" :key="i" class="star" :class="{ active: i <= 2 }" xmlns="http://www.w3.org/2000/svg" width="13" height="12" viewBox="0 0 13 12" fill="none">
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
            <svg v-for="i in 5" :key="i" class="star" :class="{ active: i <= 5 }" xmlns="http://www.w3.org/2000/svg" width="13" height="12" viewBox="0 0 13 12" fill="none">
              <path d="M6.50195 0.5C6.51697 0.5 6.53189 0.504581 6.54395 0.511719L6.56641 0.533203L8.30273 3.82422L8.41992 4.04688L8.66895 4.08594L12.4443 4.66504L12.4463 4.66602C12.4784 4.6709 12.4934 4.6892 12.498 4.70312C12.5006 4.71063 12.5002 4.71665 12.499 4.72168L12.4873 4.74121L9.78418 7.35547L9.5957 7.53711L9.6377 7.79492L10.2354 11.4434V11.4443C10.2366 11.4523 10.2358 11.4592 10.2334 11.4648C10.2309 11.4706 10.226 11.4781 10.2158 11.4854C10.192 11.5021 10.1576 11.504 10.1338 11.4922H10.1328L6.72266 9.81641L6.50195 9.70801L6.28125 9.81641L2.87012 11.4912C2.84208 11.5048 2.80924 11.5016 2.78613 11.4854C2.76766 11.4722 2.76402 11.4552 2.76562 11.4453L3.36133 7.79492L3.40332 7.53711L3.21582 7.35547L0.513672 4.74219C0.506223 4.73441 0.502534 4.72675 0.500977 4.7207C0.499443 4.71452 0.500046 4.70879 0.501953 4.70312C0.506091 4.69085 0.522385 4.67093 0.554688 4.66602V4.66504L4.33301 4.08594L4.58203 4.04688L4.69922 3.8252L6.4375 0.532227L6.43848 0.533203C6.44198 0.526716 6.44902 0.518775 6.46094 0.511719C6.47293 0.504622 6.48702 0.500037 6.50195 0.5Z" stroke="#FECD08"/>
            </svg>
          </div>
        </div>
      </div>

      <!-- Start/Stop Job Button -->
      <button v-if="!job.isWorking" class="btn-start-job" @click="$emit('startJob')">
        BẮT ĐẦU CÔNG VIỆC
        <img src="/image/Primary3.png" alt="Start" class="button-icon" />
      </button>
      
      <button v-else class="btn-stop-job" @click="$emit('stopJob')">
        KẾT THÚC CÔNG VIỆC ✕
      </button>
    </div>

    <!-- Bottom Section: Skill Level & Upgrade (chỉ hiển thị nếu hasLevel = true) -->
    <div class="job-upgrade-section" v-if="job.hasLevel">
      <!-- Khối 1: Cấp độ nghề hiện tại -->
      <div class="skill-header">
        <span class="section-title">Cấp độ nghề hiện tại</span>
        <span class="skill-level-badge">Level {{ job.skills?.level || 1 }}</span>
      </div>

      <!-- Khối 2: Tích lũy nghề và Level nhận việc -->
      <div class="skill-progress-container">
        <!-- Tích lũy nghề -->
        <div class="skill-progress-item">
          <div class="skill-row">
            <div class="section-title">Tích lũy nghề</div>
            <div class="exp-value">{{ job.skills?.exp || 0 }}<span class="max-exp">/{{ job.skills?.maxExp || 100 }}</span></div>
          </div>
          <div class="exp-bar">
            <div class="exp-progress" :style="{ width: expPercentage + '%' }"></div>
          </div>
        </div>

        <!-- Level nhận việc -->
        <div class="skill-progress-item">
          <div class="skill-row">
            <div class="section-title">Level nhận việc</div>
            <div class="level-value">{{ job.skills?.nextLevel || 1 }}<span class="max-level">/{{ job.skills?.maxLevel || 1 }}</span></div>
          </div>
          <div class="level-bar">
            <div class="level-progress" :style="{ width: levelPercentage + '%' }"></div>
          </div>
        </div>
      </div>

      <!-- Mô tả -->
      <div class="skill-description" v-html="job.skills?.description || ''">
      </div>

      <!-- Upgrade Button -->
      <button class="btn-upgrade" @click="$emit('upgradeSkill')" v-if="job.upgradeJob && job.upgradeJob.eventname">
        NÂNG CẤP NGHỀ
        <img src="/image/Primary2.png" alt="Upgrade" class="button-icon" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  job: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['startJob', 'stopJob', 'upgradeSkill'])

const expPercentage = computed(() => {
  const exp = props.job.skills?.exp || 0
  const maxExp = props.job.skills?.maxExp || 100
  return Math.min((exp / maxExp) * 100, 100)
})

const levelPercentage = computed(() => {
  const nextLevel = props.job.skills?.nextLevel || 1
  const maxLevel = props.job.skills?.maxLevel || 1
  return Math.min((nextLevel / maxLevel) * 100, 100)
})
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

.btn-start-job {
  width: 407px;
  height: 46px;
  padding: 16px;
  background: #FECD08;
  border-radius: 5px;
  color: #000000;
  font-weight: 700;
  font-size: 20px;
  cursor: pointer;
  transition: all 0.3s;
  text-transform: uppercase;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.btn-start-job:hover {
  background: #FFFFFF;
  transform: translateY(-2px);
}

.btn-stop-job {
  width: 407px;
  height: 46px;
  padding: 16px;
  background: #ED2449;
  border-radius: 5px;
  color: #FFFFFF;
  font-weight: 700;
  font-size: 20px;
  cursor: pointer;
  transition: all 0.3s;
  text-transform: uppercase;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  border: 2px solid #FF0066;
  
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

.exp-bar,
.level-bar {
  width: 407px;
  height: 16px;
  background: #3A393C;
  border-radius: 50px ;
  overflow: hidden;
  position: relative;
  border: 2px solid #1A1A1C;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.5);
}

.exp-progress,
.level-progress {
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  background: linear-gradient(90deg, #FECD08 0%, #FFD93D 100%);
  transition: width 0.5s ease;
  border-radius: 50px;
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

.skill-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 10px;
}

.exp-value,
.level-value {
  color: var(--White, #FFF);
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

.exp-value .max-exp,
.level-value .max-level {
 color: #FECD08;
  leading-trim: both;
  text-edge: cap;

  /* Bold 16 */
  font-family: "Baloo 2";
  font-size: 1rem;
  font-style: normal;
  font-weight: 700;
  line-height: normal;
  
}

.section-title {
  color: #FFF;
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
  height: 24px;
  background: #3A393C;
  overflow: hidden;
  margin-bottom: 5px;
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
  height: 24px;
  background: #3A393C;
  overflow: hidden;
  margin-bottom: 5px;
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

.btn-upgrade:disabled {
  background: #666;
  border-color: #666;
  cursor: not-allowed;
  opacity: 0.5;
}
</style>
