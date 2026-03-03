import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const saved = localStorage.getItem("padeex-theme") || "dark"
    this.#apply(saved)
  }

  toggle() {
    const current = document.documentElement.getAttribute("data-theme") || "dark"
    const next = current === "dark" ? "light" : "dark"
    this.#apply(next)
    localStorage.setItem("padeex-theme", next)
  }

  #apply(theme) {
    document.documentElement.setAttribute("data-theme", theme)
  }
}
