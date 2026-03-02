import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["code", "button"]

  copy() {
    const text = this.codeTarget.value

    navigator.clipboard.writeText(text).then(() => {
      this.flashCopied()
    }).catch(() => {
      this.codeTarget.select()
      document.execCommand("copy")
      this.flashCopied()
    })
  }

  flashCopied() {
    const btn  = this.buttonTarget
    const orig = btn.innerHTML
    btn.innerHTML = '<i class="bi bi-check-lg"></i> Copiado!'
    btn.disabled  = true
    setTimeout(() => {
      btn.innerHTML = orig
      btn.disabled  = false
    }, 2500)
  }
}
