import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "btn"]

  copy() {
    navigator.clipboard.writeText(this.inputTarget.value).then(() => {
      const span = this.btnTarget.querySelector("span")
      span.textContent = "Copiado!"
      setTimeout(() => { span.textContent = "Copiar" }, 2000)
    })
  }
}
