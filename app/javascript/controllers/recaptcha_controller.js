import { Controller } from "@hotwired/stimulus"

// reCAPTCHA v3 invisível: intercepta o submit do form, obtém token e envia junto.
// Requer data-controller="recaptcha" e data-recaptcha-site-key-value no form.
export default class extends Controller {
  static values = {
    siteKey: { type: String, default: "" }
  }

  connect() {
    this.siteKey = this.siteKeyValue || document.querySelector("meta[name='recaptcha-site-key']")?.content
    if (!this.siteKey) return

    this.boundSubmit = this.handleSubmit.bind(this)
    this.element.addEventListener("submit", this.boundSubmit, { capture: true })
    this.loadScript()
  }

  disconnect() {
    this.element.removeEventListener("submit", this.boundSubmit, { capture: true })
  }

  loadScript() {
    if (window.grecaptcha) {
      this.scriptLoaded = true
      return
    }
    if (document.querySelector("script[src*='recaptcha/api.js']")) return

    const script = document.createElement("script")
    script.src = `https://www.google.com/recaptcha/api.js?render=${this.siteKey}`
    script.async = true
    script.onload = () => { this.scriptLoaded = true }
    document.head.appendChild(script)
  }

  async handleSubmit(event) {
    if (!this.siteKey || !this.scriptLoaded) return
    if (this.element.querySelector('input[name="recaptcha_token"]')) return // já tem token (re-submit)

    event.preventDefault()
    event.stopImmediatePropagation()

    try {
      await this.waitForGrecaptcha()
      const token = await window.grecaptcha.execute(this.siteKey, { action: "submit" })

      const input = document.createElement("input")
      input.type = "hidden"
      input.name = "recaptcha_token"
      input.value = token
      this.element.appendChild(input)

      this.element.requestSubmit()
    } catch (err) {
      console.error("[Recaptcha]", err)
      this.element.requestSubmit()
    }
  }

  waitForGrecaptcha() {
    return new Promise((resolve) => {
      if (window.grecaptcha?.execute) {
        resolve()
        return
      }
      const check = setInterval(() => {
        if (window.grecaptcha?.execute) {
          clearInterval(check)
          resolve()
        }
      }, 50)
      setTimeout(() => {
        clearInterval(check)
        resolve()
      }, 5000)
    })
  }
}
