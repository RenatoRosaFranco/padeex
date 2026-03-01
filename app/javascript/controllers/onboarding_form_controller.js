import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["usernameStatus", "submitBtn"]

  checkUsername(event) {
    const input    = event.target
    const username = input.value.trim()
    const status   = this.hasUsernameStatusTarget ? this.usernameStatusTarget : null

    clearTimeout(this._usernameTimer)

    if (!status) return

    if (username.length < 3) {
      status.dataset.state = ""
      this.#unlockSubmit()
      return
    }

    status.dataset.state = "loading"
    this.#lockSubmit()

    this._usernameTimer = setTimeout(async () => {
      try {
        const res  = await fetch(`/onboarding/username-check?username=${encodeURIComponent(username)}`)
        const data = await res.json()
        status.dataset.state = data.available ? "available" : "taken"
        data.available ? this.#unlockSubmit() : this.#lockSubmit()
      } catch {
        status.dataset.state = ""
        this.#unlockSubmit()
      }
    }, 400)
  }

  #lockSubmit() {
    if (this.hasSubmitBtnTarget) this.submitBtnTarget.disabled = true
  }

  #unlockSubmit() {
    if (this.hasSubmitBtnTarget) this.submitBtnTarget.disabled = false
  }

  formatPhone(event) {
    const input  = event.target
    const digits = input.value.replace(/\D/g, "").slice(0, 11)
    let formatted = ""

    if (digits.length === 0) {
      formatted = ""
    } else if (digits.length <= 2) {
      formatted = `(${digits}`
    } else if (digits.length <= 6) {
      formatted = `(${digits.slice(0, 2)}) ${digits.slice(2)}`
    } else if (digits.length <= 10) {
      formatted = `(${digits.slice(0, 2)}) ${digits.slice(2, 6)}-${digits.slice(6)}`
    } else {
      formatted = `(${digits.slice(0, 2)}) ${digits.slice(2, 7)}-${digits.slice(7)}`
    }

    input.value = formatted
  }

  formatCnpj(event) {
    const input  = event.target
    const digits = input.value.replace(/\D/g, "").slice(0, 14)
    let formatted = ""

    if (digits.length <= 2) {
      formatted = digits
    } else if (digits.length <= 5) {
      formatted = `${digits.slice(0, 2)}.${digits.slice(2)}`
    } else if (digits.length <= 8) {
      formatted = `${digits.slice(0, 2)}.${digits.slice(2, 5)}.${digits.slice(5)}`
    } else if (digits.length <= 12) {
      formatted = `${digits.slice(0, 2)}.${digits.slice(2, 5)}.${digits.slice(5, 8)}/${digits.slice(8)}`
    } else {
      formatted = `${digits.slice(0, 2)}.${digits.slice(2, 5)}.${digits.slice(5, 8)}/${digits.slice(8, 12)}-${digits.slice(12)}`
    }

    input.value = formatted
  }

  formatCpf(event) {
    const input  = event.target
    const digits = input.value.replace(/\D/g, "").slice(0, 11)
    let formatted = ""

    if (digits.length <= 3) {
      formatted = digits
    } else if (digits.length <= 6) {
      formatted = `${digits.slice(0, 3)}.${digits.slice(3)}`
    } else if (digits.length <= 9) {
      formatted = `${digits.slice(0, 3)}.${digits.slice(3, 6)}.${digits.slice(6)}`
    } else {
      formatted = `${digits.slice(0, 3)}.${digits.slice(3, 6)}.${digits.slice(6, 9)}-${digits.slice(9)}`
    }

    input.value = formatted
  }
}
