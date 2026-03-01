import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { apiKey: String }

  connect() {
    if (window.google?.maps?.places) {
      this.#setup()
    } else {
      this.#loadScript().then(() => this.#setup())
    }
  }

  #loadScript() {
    return new Promise((resolve, reject) => {
      if (document.querySelector("#google-maps-script")) {
        resolve()
        return
      }
      const script    = document.createElement("script")
      script.id       = "google-maps-script"
      script.src      = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&libraries=places`
      script.onload   = resolve
      script.onerror  = reject
      document.head.appendChild(script)
    })
  }

  #setup() {
    const autocomplete = new google.maps.places.Autocomplete(this.element, {
      types: ["address"],
      componentRestrictions: { country: "br" },
      fields: ["formatted_address"]
    })

    autocomplete.addListener("place_changed", () => {
      const place = autocomplete.getPlace()
      if (place.formatted_address) {
        this.element.value = place.formatted_address
        this.element.dispatchEvent(new Event("input", { bubbles: true }))
      }
    })
  }
}
