import { copyFileSync, mkdirSync, readdirSync, existsSync } from 'fs'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))

const sourceDir = join(__dirname, '../html/image')
const targetDir = join(__dirname, 'public/image')

// Create target directory if not exists
if (!existsSync(targetDir)) {
  mkdirSync(targetDir, { recursive: true })
}

// Copy all images
const files = readdirSync(sourceDir)
files.forEach(file => {
  const sourcePath = join(sourceDir, file)
  const targetPath = join(targetDir, file)
  try {
    copyFileSync(sourcePath, targetPath)
    console.log(`✓ Copied: ${file}`)
  } catch (err) {
    console.error(`✗ Failed to copy ${file}:`, err.message)
  }
})

console.log('\n✅ All images copied successfully!')
