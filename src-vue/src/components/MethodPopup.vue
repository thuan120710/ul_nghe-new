<template>
  <div class="method-popup-overlay" @click.self="$emit('close')">
    <div class="method-popup">
      <!-- Header Section -->
      <div class="popup-header">
        <h2 class="popup-title">{{ jobName }}</h2>
        <button class="btn-close-popup" @click="$emit('close')">
          <img src="/image/clone2.png" alt="Close" class="close-icon" />
        </button>
      </div>

      <!-- Container Section -->
      <div class="popup-container">
        <div class="options-list">
          <button 
            v-for="(option, key) in methods" 
            :key="key"
            class="option-button"
            @click="selectMethod(option)"
          >
            {{ option.buttonname }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  jobName: {
    type: String,
    required: true
  },
  methods: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['close', 'selectMethod'])

const selectMethod = (option) => {
  emit('selectMethod', option)
}
</script>

<style scoped>
.method-popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.method-popup {
  width: 650px;
  background: transparent;
  display: flex;
  flex-direction: column;
  overflow: hidden;

  border-radius: 0.625rem;
  border: 1px solid var(--Gold, #FECD08);
  background: var(--Grey-2, #3A393C);
}

/* Header Section - Phần tiêu đề */
.popup-header {
  position: relative;

  display: flex;
  padding: 1rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  align-self: stretch;
  background: var(--Grey-1, #5D5D5F);
}

.popup-title {
  color: #FFF;
  text-align: center;

  /* Heading 1 W */
  font-family: "Baloo 2";
  font-size: 1.5rem;
  font-style: normal;
  font-weight: 700;
  line-height: 1.5rem; /* 100% */
}

.btn-close-popup {
  position: absolute;
  right: 32px;

  width: 1.6875rem;
  height: 1.5rem;
  flex-shrink: 0;
  aspect-ratio: 9/8;
  fill: var(--Gold, #FECD08);
}

.btn-close-popup:hover {
  transform: scale(1.1);
}

.close-icon {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

/* Container Section - Phần chứa options */
.popup-container {
 background: var(--Grey-2, #3A393C);
  padding: 32px;
  flex: 1;
}

.options-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.option-button {
  background: rgba(255, 255, 255, 0.95);
  border: none;
  border-radius: 0.625rem;
  color: #000;
  font-family: "Baloo 2";
  font-size: 1.5rem;
  font-weight: 700;
  text-transform: uppercase;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);

  display: flex;
  padding: 1rem 0.625rem;
  justify-content: center;
  align-items: center;
  gap: 0.625rem;
  align-self: stretch;
  border-radius: 0.625rem;
  background: var(--White, #FFF);
}

.option-button:hover {
  background: #FECD08;
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(254, 205, 8, 0.5);
}

.option-button:active {
  transform: translateY(-1px);
}
</style>
