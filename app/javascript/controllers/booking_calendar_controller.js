import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "content"]

  open(event) {
    const el   = event.currentTarget
    const csrf = document.querySelector('meta[name="csrf-token"]').content
    const param = document.querySelector('meta[name="csrf-param"]').content

    this.contentTarget.innerHTML = `
      <div class="cal-panel-booking">
        <h3 class="cal-panel-title">${el.dataset.court}</h3>
        <div class="cal-panel-meta">
          <span><i class="bi bi-person-fill"></i> ${el.dataset.user}</span>
          <span><i class="bi bi-calendar3"></i> ${el.dataset.date}</span>
          <span><i class="bi bi-clock"></i> ${el.dataset.time}</span>
        </div>
        <form method="post" action="${el.dataset.cancelUrl}" class="cal-panel-cancel-form">
          <input type="hidden" name="_method" value="delete">
          <input type="hidden" name="${param}" value="${csrf}">
          <button type="submit"
                  class="sched-btn sched-btn--danger"
                  onclick="return confirm('Cancelar a reserva de ${el.dataset.user}?')">
            <i class="bi bi-x-circle"></i> Cancelar Reserva
          </button>
        </form>
      </div>
    `
    this.panelTarget.classList.add("cal-panel--open")
  }

  close() {
    this.panelTarget.classList.remove("cal-panel--open")
  }
}
