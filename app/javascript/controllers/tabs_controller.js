import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values  = { active: String }

  connect() {
    const urlTab = new URLSearchParams(window.location.search).get("tab") || this.activeValue
    this.activate(urlTab, false)
  }

  switch(event) {
    event.preventDefault()
    const tab = event.currentTarget.dataset.tab
    this.activate(tab, true)
  }

  activate(tab, pushState) {
    const found = this.tabTargets.find(t => t.dataset.tab === tab)
    const target = found ? tab : this.tabTargets[0]?.dataset.tab
    if (!target) return

    this.tabTargets.forEach(t => t.classList.toggle("active", t.dataset.tab === target))
    this.panelTargets.forEach(p => p.classList.toggle("hidden", p.dataset.tab !== target))

    if (pushState) {
      const url = new URL(window.location)
      url.searchParams.set("tab", target)
      history.pushState({}, "", url)
    }
  }
}
