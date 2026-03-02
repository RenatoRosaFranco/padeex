import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form", "paymentMethod"]

  open(event) {
    event.preventDefault()
    this.modalTarget.hidden = false
    document.body.style.overflow = "hidden"
  }

  // data-payment-modal-method-param="card" | "pix"
  confirm(event) {
    const method = event.params.method || "card"
    if (this.hasPaymentMethodTarget) {
      this.paymentMethodTarget.value = method
    }
    this.close()
    this.formTarget.requestSubmit()
  }

  close() {
    this.modalTarget.hidden = true
    document.body.style.overflow = ""
  }
}
