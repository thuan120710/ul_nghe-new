<template>
  <div class="jobs-ui">
    <!-- Header -->
    <div class="ui-header">
      <PlayerInfo :player="playerData" />
      <div class="logo">
        <img src="/image/logo.png" alt="F17 City" />
      </div>
      <button class="btn-close" @click="$emit('close')">✕</button>
    </div>

    <!-- Main Content - 3 Columns -->
    <div class="ui-content">
      <!-- Left Panel: Job Details -->
      <JobDetails 
        :job="jobData"
        @watchVideo="$emit('watchVideo')"
      />

      <!-- Center Panel: Job Actions -->
      <JobActions 
        :job="jobData"
        @startJob="(method) => $emit('startJob', method)"
        @stopJob="$emit('stopJob')"
        @upgradeSkill="$emit('upgradeSkill')"
      />

      <!-- Right Panel: Ranking -->
      <RankingPanel :ranking="rankingData" />
    </div>
  </div>
</template>

<script setup>
import PlayerInfo from './PlayerInfo.vue'
import JobDetails from './JobDetails.vue'
import JobActions from './JobActions.vue'
import RankingPanel from './RankingPanel.vue'

defineProps({
  playerData: Object,
  jobData: Object,
  rankingData: Object
})

defineEmits(['close', 'startJob', 'stopJob', 'upgradeSkill', 'watchVideo'])
</script>

<style scoped>
.jobs-ui {
  /* width: 1541px;
  height: 924px; */
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  transform: scale(1.2);
  transform-origin: center;
  display: flex;
  width: 96.3125rem;
  height: 57.75rem;
  flex-direction: column;
  justify-content: center;
  flex-shrink: 0;
  aspect-ratio: 512/307;
  border-radius: 1.25rem;
  background: rgba(93, 93, 95, 0.50);
  box-shadow: -4px -4px 4px 0 #2D2D2D inset, 2px 2px 4px 0 #797979 inset;
}

.ui-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 0.6rem;
}

.logo img {
  height: 70px;
  padding-right: 150px;
}

.btn-close {
  width: 35px;
  height: 35px;
  background: rgba(93, 93, 95, 0.50);
  color: #ff0000;
  font-size: 20px;
  cursor: pointer;
  transition: all 0.3s;

  display: flex;
  padding: 1rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  border-radius: 0.3125rem;
  border: 1px solid var(--Red-Pink, #ED2449);
  }

.btn-close:hover {
  background: rgba(255, 0, 0, 0.4);
  transform: scale(1.1);
}

.ui-content {
  flex: 1;
  display: grid;
  grid-template-columns: 471px 471px 471px;
  gap: 2rem;
  overflow: hidden;
  height: 768px;
  padding-left: 10px;
}
</style>
