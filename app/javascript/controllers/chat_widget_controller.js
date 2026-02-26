import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["drawer", "messages", "input", "toggle"]

  static values = {
    open: { type: Boolean, default: false },
    responses: { type: Array, default: [] }
  }

  connect() {
    this.openValue ? this.open() : this.close()
    document.addEventListener("keydown", this.handleEscape.bind(this))
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleEscape.bind(this))
  }

  toggle() {
    this.openValue ? this.close() : this.open()
  }

  open() {
    this.openValue = true
    this.drawerTarget.classList.add("chat-drawer--open")
    this.toggleTarget?.classList.add("chat-widget-toggle--hidden")
    this.inputTarget?.focus()
  }

  close() {
    this.openValue = false
    this.drawerTarget.classList.remove("chat-drawer--open")
    this.toggleTarget?.classList.remove("chat-widget-toggle--hidden")
  }

  handleEscape(event) {
    if (event.key === "Escape") this.close()
  }

  sendMessage(event) {
    event.preventDefault()
    const text = this.inputTarget.value.trim()
    if (!text) return

    this.addMessage(text, "user")
    this.inputTarget.value = ""

    setTimeout(() => this.replyAsAssistant(text), 600 + Math.random() * 400)
  }

  addMessage(text, role) {
    const div = document.createElement("div")
    div.className = `chat-message chat-message--${role}`
    div.innerHTML = `
      <span class="chat-message__bubble">${this.escapeHtml(text)}</span>
    `
    this.messagesTarget.appendChild(div)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  addTypingIndicator() {
    const div = document.createElement("div")
    div.className = "chat-message chat-message--assistant chat-message--typing"
    div.dataset.typingIndicator = "true"
    div.innerHTML = this.typingIndicatorHtml()
    this.messagesTarget.appendChild(div)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  typingIndicatorHtml() {
    return `
      <span class="chat-message__bubble">
        <span class="chat-typing-dot"></span>
        <span class="chat-typing-dot"></span>
        <span class="chat-typing-dot"></span>
      </span>
    `
  }

  removeTypingIndicator() {
    const el = this.element.querySelector("[data-typing-indicator='true']")
    if (el) el.remove()
  }

  replyAsAssistant(userText) {
    this.addTypingIndicator()

    const replies = this.responsesValue.length > 0 ? this.responsesValue : [
      "Olá! Como posso ajudar você hoje no ecossistema Padeex?"
    ]
    const reply = replies[Math.floor(Math.random() * replies.length)]

    setTimeout(() => {
      this.removeTypingIndicator()
      this.addMessage(reply, "assistant")
    }, 800 + Math.random() * 600)
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
