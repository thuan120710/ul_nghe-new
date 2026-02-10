<template>
  <div class="player-info">
    <div class="avatar">
      <img :src="player.avatar" alt="Avatar" />
    </div>
    <div class="info">
      <div class="name">{{ player.name }}</div>
      <div class="level">LV{{ player.level }}</div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  player: {
    type: Object,
    required: true
  }
})
</script>

<style scoped>
.player-info {
  display: flex;
  align-items: center;
  gap: 12px;
  padding-top: 20px;
}

.avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  border: 2px solid #FECD08;
  overflow: hidden;
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.name {
  color: #FECD08;
  font-weight: 700;
  font-size: 16px;
}

.level {
  color: #FFFFFF;
  font-size: 14px;
}
</style>
