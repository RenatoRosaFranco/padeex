import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "badge", "modal", "modalList", "sentinel", "loading", "dropdownList"]
  static values  = { unreadCount: Number }

  connect() {
    this._outsideClick = this._onOutsideClick.bind(this)
    this._setupObserver()
  }

  disconnect() {
    document.removeEventListener("click", this._outsideClick)
    this._observer?.disconnect()
  }

  // ── Dropdown ────────────────────────────────────────────────

  toggleDropdown(event) {
    event.stopPropagation()
    this.dropdownTarget.classList.contains("is-open")
      ? this._closeDropdown()
      : this._openDropdown()
  }

  _openDropdown() {
    this.dropdownTarget.classList.add("is-open")
    document.addEventListener("click", this._outsideClick)
  }

  _closeDropdown() {
    this.dropdownTarget.classList.remove("is-open")
    document.removeEventListener("click", this._outsideClick)
  }

  _onOutsideClick(event) {
    if (!this.element.contains(event.target)) this._closeDropdown()
  }

  // ── Modal ────────────────────────────────────────────────────

  openModal() {
    this._closeDropdown()
    this.modalTarget.showModal()
    if (!this._loaded) this._loadPage(1)
  }

  closeModal() {
    this.modalTarget.close()
  }

  // Close modal when clicking the backdrop
  modalTargetConnected(modal) {
    modal.addEventListener("click", (e) => {
      if (e.target === modal) this.closeModal()
    })
  }

  // ── Notifications ────────────────────────────────────────────

  markRead(event) {
    const item  = event.currentTarget
    const id    = item.dataset.notificationId
    const url   = item.dataset.notificationUrl

    if (item.classList.contains("notif-item--unread")) {
      item.classList.remove("notif-item--unread")
      item.querySelector(".notif-item__dot")?.remove()
      this._decrement()

      fetch(`/dashboard/notifications/${id}/mark_read`, {
        method:  "PATCH",
        headers: { "X-CSRF-Token": this._csrf(), "Accept": "application/json" }
      })
    }

    if (url) Turbo.visit(url)
  }

  async markAllRead() {
    await fetch("/dashboard/notifications/mark_all_read", {
      method:  "PATCH",
      headers: { "X-CSRF-Token": this._csrf(), "Accept": "application/json" }
    })

    this.element.querySelectorAll(".notif-item--unread").forEach(el => {
      el.classList.remove("notif-item--unread")
      el.querySelector(".notif-item__dot")?.remove()
    })

    this._setBadge(0)
  }

  // ── Infinite scroll ──────────────────────────────────────────

  _setupObserver() {
    this._observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return
        const sentinel = entry.target
        const page     = parseInt(sentinel.dataset.page)
        this._observer.unobserve(sentinel)
        sentinel.remove()
        this._loadPage(page)
      })
    }, { threshold: 0.1 })
  }

  sentinelTargetConnected(sentinel) {
    this._observer?.observe(sentinel)
  }

  async _loadPage(page) {
    if (page === 1 && this.hasLoadingTarget) {
      this.loadingTarget.style.display = "flex"
    }

    const res  = await fetch(`/dashboard/notifications?page=${page}`, {
      headers: { "Accept": "text/html", "X-Requested-With": "XMLHttpRequest" }
    })
    const html = await res.text()

    if (page === 1 && this.hasLoadingTarget) {
      this.loadingTarget.remove()
    }

    const tmp = document.createElement("div")
    tmp.innerHTML = html
    Array.from(tmp.childNodes).forEach(node => this.modalListTarget.appendChild(node))
    this._loaded = true
  }

  // ── Badge helpers ────────────────────────────────────────────

  _decrement() {
    this._setBadge(Math.max(0, this.unreadCountValue - 1))
  }

  _setBadge(count) {
    this.unreadCountValue = count
    if (!this.hasBadgeTarget) return
    if (count <= 0) {
      this.badgeTarget.remove()
    } else {
      this.badgeTarget.textContent = count > 99 ? "99+" : count
    }
  }

  _csrf() {
    return document.querySelector('[name="csrf-token"]')?.content ?? ""
  }
}
