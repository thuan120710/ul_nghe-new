import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  base: './',
  build: {
    outDir: '../html',
    emptyOutDir: true,
    assetsDir: '.',
    rollupOptions: {
      output: {
        entryFileNames: 'index-[hash].js',
        chunkFileNames: 'index-[hash].js',
        assetFileNames: 'index-[hash].[ext]'
      }
    }
  }
})
