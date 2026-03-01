import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["confirm", "selectedSlot", "dateHidden", "dateInput", "timeDisplay"]
  static values  = { basePath: String }

  changeDate(event) {
    const frame = document.getElementById("slots")
    frame.src = `${this.basePathValue}?date=${event.target.value}`
    this.hideConfirm()
  }

  selectSlot(event) {
    const time = event.params.time

    this.element.querySelectorAll(".slot-btn--selected").forEach(btn =>
      btn.classList.remove("slot-btn--selected")
    )
    event.currentTarget.classList.add("slot-btn--selected")

    this.selectedSlotTarget.value = time
    this.dateHiddenTarget.value   = this.dateInputTarget.value
    this.timeDisplayTarget.textContent = `${time} — ${this.dateInputTarget.value}`

    this.confirmTarget.classList.add("sched-confirm--visible")
    this.confirmTarget.scrollIntoView({ behavior: "smooth", block: "nearest" })
  }

  cancelSelection() {
    this.element.querySelectorAll(".slot-btn--selected").forEach(btn =>
      btn.classList.remove("slot-btn--selected")
    )
    this.hideConfirm()
  }

  hideConfirm() {
    this.confirmTarget.classList.remove("sched-confirm--visible")
    this.selectedSlotTarget.value = ""
  }
}
