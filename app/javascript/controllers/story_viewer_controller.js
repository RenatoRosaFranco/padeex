import { Controller } from "@hotwired/stimulus"

const DURATION = 5000

export default class extends Controller {
  static targets = ["modal", "bars", "authorAvatar", "authorName", "authorTime", "content"]
  static values  = { stories: Array, current: { type: Number, default: 0 } }

  connect() {
    this._timer = null
  }

  disconnect() {
    this._clearTimer()
  }

  open(event) {
    const idx = parseInt(event.currentTarget.dataset.storyIndex, 10)
    this.currentValue = idx
    this.modalTarget.classList.add("stv--open")
    document.body.style.overflow = "hidden"
    this._render()
  }

  close() {
    this._clearTimer()
    this.modalTarget.classList.remove("stv--open")
    document.body.style.overflow = ""
  }

  next() {
    this._clearTimer()
    if (this.currentValue < this.storiesValue.length - 1) {
      this.currentValue++
      this._render()
    } else {
      this.close()
    }
  }

  prev() {
    this._clearTimer()
    if (this.currentValue > 0) {
      this.currentValue--
      this._render()
    }
  }

  keydown(event) {
    if (!this.modalTarget.classList.contains("stv--open")) return
    if (event.key === "ArrowRight") this.next()
    if (event.key === "ArrowLeft")  this.prev()
    if (event.key === "Escape")     this.close()
  }

  _render() {
    const story = this.storiesValue[this.currentValue]
    this._renderBars()
    this._renderHeader(story)
    this._renderContent(story)
    this._startTimer()
  }

  _renderBars() {
    const total   = this.storiesValue.length
    const current = this.currentValue

    this.barsTarget.innerHTML = Array.from({ length: total }, (_, i) => {
      if (i < current) {
        return `<div class="stv__bar"><div class="stv__bar-fill stv__bar-fill--done"></div></div>`
      } else if (i === current) {
        return `<div class="stv__bar"><div class="stv__bar-fill stv__bar-fill--active" style="animation-duration:${DURATION}ms"></div></div>`
      } else {
        return `<div class="stv__bar"><div class="stv__bar-fill"></div></div>`
      }
    }).join("")
  }

  _renderHeader(story) {
    const av = this.authorAvatarTarget
    if (story.avatar_url) {
      av.innerHTML = `<img src="${story.avatar_url}" class="stv__avatar-img" alt="${story.name}">`
    } else {
      av.textContent = story.initials
    }
    this.authorNameTarget.textContent = story.username ? `@${story.username}` : story.name
    this.authorTimeTarget.textContent = story.time_label
  }

  _renderContent(story) {
    const el = this.contentTarget
    if (story.image_url) {
      el.style.background = ""
      el.innerHTML = `<img src="${story.image_url}" class="stv__img" alt="">`
    } else {
      el.innerHTML = ""
      el.style.background = story.gradient
    }
  }

  _startTimer() {
    this._clearTimer()
    this._timer = setTimeout(() => this.next(), DURATION)
  }

  _clearTimer() {
    if (this._timer) {
      clearTimeout(this._timer)
      this._timer = null
    }
  }
}
