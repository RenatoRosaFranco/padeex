import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["passwordInput", "strengthBar", "strengthLabel"]

  toggleVisibility(event) {
    const btn   = event.currentTarget
    const input = btn.closest(".auth-input-wrap").querySelector("input")
    const icon  = btn.querySelector("i")

    if (input.type === "password") {
      input.type = "text"
      icon.className = "bi bi-eye-slash"
    } else {
      input.type = "password"
      icon.className = "bi bi-eye"
    }
  }

  checkStrength(event) {
    const val = event.target.value
    const { score, label } = this.#score(val)

    this.strengthBarTarget.dataset.score = score
    this.strengthLabelTarget.textContent  = label
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
      // Landline: (XX) XXXX-XXXX
      formatted = `(${digits.slice(0, 2)}) ${digits.slice(2, 6)}-${digits.slice(6)}`
    } else {
      // Mobile: (XX) XXXXX-XXXX
      formatted = `(${digits.slice(0, 2)}) ${digits.slice(2, 7)}-${digits.slice(7)}`
    }

    input.value = formatted
  }

  #score(password) {
    if (!password) return { score: 0, label: "" }

    let points = 0
    if (password.length >= 8)        points++
    if (password.length >= 12)       points++
    if (/[A-Z]/.test(password))      points++
    if (/[0-9]/.test(password))      points++
    if (/[^A-Za-z0-9]/.test(password)) points++

    const levels = [
      { score: 1, label: "Muito fraca" },
      { score: 2, label: "Fraca"       },
      { score: 3, label: "Média"       },
      { score: 4, label: "Forte"       },
      { score: 5, label: "Muito forte" },
    ]

    return levels[Math.min(points, 5) - 1] || { score: 1, label: "Muito fraca" }
  }
}
