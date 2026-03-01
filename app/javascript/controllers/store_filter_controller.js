import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "card"]

  filter(event) {
    const category = event.currentTarget.dataset.category

    this.tabTargets.forEach(tab => {
      tab.classList.toggle("store-cat-btn--active", tab.dataset.category === category)
    })

    this.cardTargets.forEach(card => {
      const visible = category === "todos" || card.dataset.category === category
      card.style.display = visible ? "" : "none"
    })
  }
}
