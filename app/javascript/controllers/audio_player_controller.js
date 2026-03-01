import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["playBtn", "barFill", "barThumb", "elapsed", "duration", "speed"]
  static values  = { text: String }

  connect() {
    if (!window.speechSynthesis) {
      this.element.hidden = true
      return
    }

    this.chars       = this.textValue.length
    this.charIndex   = 0
    this.rate        = 1
    this.playing     = false
    this.utterance   = null
    this.ticker      = null
    this._charOffset = 0

    this._estimateDuration()
    this._updateProgress()
  }

  toggle() {
    this.playing ? this._pause() : this._play()
  }

  rewind() {
    const wasPlaying = this.playing
    this._cancel()
    this.charIndex = Math.max(0, this.charIndex - 300)
    this._updateProgress()
    if (wasPlaying) this._play()
  }

  forward() {
    const wasPlaying = this.playing
    this._cancel()
    this.charIndex = Math.min(this.chars - 1, this.charIndex + 300)
    this._updateProgress()
    if (wasPlaying) this._play()
  }

  seek(e) {
    const rect  = e.currentTarget.getBoundingClientRect()
    const ratio = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width))
    const wasPlaying = this.playing
    this._cancel()
    this.charIndex = Math.floor(ratio * this.chars)
    this._updateProgress()
    if (wasPlaying) this._play()
  }

  cycleSpeed() {
    const speeds = [0.75, 1, 1.25, 1.5, 2]
    const idx    = speeds.indexOf(this.rate)
    this.rate    = speeds[(idx + 1) % speeds.length]
    this.speedTarget.textContent = `${this.rate}x`
    this._estimateDuration()
    if (this.playing) { this._cancel(); this._play() }
  }

  disconnect() {
    speechSynthesis.cancel()
    clearInterval(this.ticker)
  }

  // ── private ────────────────────────────────────────────

  _play() {
    const text = this.textValue.slice(this.charIndex)
    this._charOffset = this.charIndex

    this.utterance      = new SpeechSynthesisUtterance(text)
    this.utterance.lang = "pt-BR"
    this.utterance.rate = this.rate

    this.utterance.onboundary = (e) => {
      if (e.name === "word") {
        this.charIndex = this._charOffset + e.charIndex
        this._updateProgress()
      }
    }

    this.utterance.onend = () => {
      this.playing   = false
      this.charIndex = 0
      this._updatePlayBtn()
      this._updateProgress()
      clearInterval(this.ticker)
    }

    speechSynthesis.cancel()
    speechSynthesis.speak(this.utterance)
    this.playing = true
    this._updatePlayBtn()
    this._startTicker()
  }

  _pause() {
    speechSynthesis.cancel()
    this.playing = false
    this._updatePlayBtn()
    clearInterval(this.ticker)
  }

  _cancel() {
    speechSynthesis.cancel()
    this.playing = false
    clearInterval(this.ticker)
    this._updatePlayBtn()
  }

  _startTicker() {
    clearInterval(this.ticker)
    this.ticker = setInterval(() => this._updateProgress(), 300)
  }

  _updateProgress() {
    const ratio = this.chars > 0 ? this.charIndex / this.chars : 0
    const pct   = `${ratio * 100}%`
    this.barFillTarget.style.width  = pct
    this.barThumbTarget.style.left  = pct
    this.elapsedTarget.textContent  = this._fmt(ratio * this._totalSecs)
  }

  _estimateDuration() {
    // ~13 chars/sec at rate 1x (pt-BR TTS average)
    this._totalSecs = this.chars / (13 * this.rate)
    this.durationTarget.textContent = this._fmt(this._totalSecs)
  }

  _updatePlayBtn() {
    const icon = this.playing ? "bi-pause-fill" : "bi-play-fill"
    this.playBtnTarget.innerHTML = `<i class="bi ${icon}"></i>`
  }

  _fmt(secs) {
    const s = Math.max(0, Math.floor(secs))
    return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`
  }
}
