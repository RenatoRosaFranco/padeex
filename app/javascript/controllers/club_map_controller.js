import { Controller } from "@hotwired/stimulus"

const PAGE_SIZE = 12

const DARK_STYLES = [
  { elementType: "geometry",                      stylers: [{ color: "#0f1022" }] },
  { elementType: "labels.text.fill",              stylers: [{ color: "#8892b0" }] },
  { elementType: "labels.text.stroke",            stylers: [{ color: "#07080f" }] },
  { featureType: "road",             elementType: "geometry",         stylers: [{ color: "#181a38" }] },
  { featureType: "road",             elementType: "geometry.stroke",  stylers: [{ color: "#07080f" }] },
  { featureType: "road.highway",     elementType: "geometry",         stylers: [{ color: "#3628c5" }] },
  { featureType: "road.highway",     elementType: "geometry.stroke",  stylers: [{ color: "#07080f" }] },
  { featureType: "water",            elementType: "geometry",         stylers: [{ color: "#07080f" }] },
  { featureType: "water",            elementType: "labels.text.fill", stylers: [{ color: "#3628c5" }] },
  { featureType: "poi",              elementType: "geometry",         stylers: [{ color: "#0f1022" }] },
  { featureType: "poi.park",         elementType: "geometry",         stylers: [{ color: "#0d1a0d" }] },
  { featureType: "transit",          elementType: "geometry",         stylers: [{ color: "#181a38" }] },
  { featureType: "administrative",   elementType: "geometry.stroke",  stylers: [{ color: "#3628c5" }] },
  { featureType: "administrative.locality", elementType: "labels.text.fill", stylers: [{ color: "#f0f4ff" }] },
]

export default class extends Controller {
  static targets = ["map", "card", "count", "searchInput", "panel", "empty", "sentinel", "loader", "modalOverlay", "modalTitle", "modalBody"]

  connect() {
    this.allClubs      = window.__CLUBS__ || []
    this.filteredClubs = [...this.allClubs]
    this.page          = 0
    this.markers       = {}
    this.infoWindow    = null
    this.activeId      = null

    this.countTarget.textContent = this.allClubs.length
    this.renderBatch()
    this.setupObserver()
    this.loadGoogleMaps()
  }

  disconnect() {
    this.observer?.disconnect()
    this._themeObserver?.disconnect()
    clearTimeout(this._searchTimer)
    this.panelTarget?.querySelectorAll(".explore-card").forEach(el => clearInterval(el._slideInterval))
  }

  // ---- Infinite scroll ----

  renderBatch() {
    const start = this.page * PAGE_SIZE
    const batch = this.filteredClubs.slice(start, start + PAGE_SIZE)
    if (batch.length === 0) return

    const fragment = document.createDocumentFragment()
    batch.forEach(club => fragment.appendChild(this.buildCard(club)))
    this.panelTarget.insertBefore(fragment, this.sentinelTarget)
    this.page++

    if (this.map) batch.forEach(club => { if (!this.markers[club.id]) this.addMarker(club) })
  }

  setupObserver() {
    this.observer = new IntersectionObserver(
      entries => {
        if (!entries[0].isIntersecting) return
        if (this.page * PAGE_SIZE >= this.filteredClubs.length) return
        if (this._loading) return

        this._loading = true
        this.showSkeletons()
        setTimeout(() => {
          this.removeSkeletons()
          this.renderBatch()
          this._loading = false
          if (this.page * PAGE_SIZE >= this.filteredClubs.length) this.showEndMessage()
        }, 800)
      },
      { root: this.panelTarget, threshold: 0.1 }
    )
    this.observer.observe(this.sentinelTarget)
  }

  showSkeletons() {
    const count = Math.min(PAGE_SIZE, this.filteredClubs.length - this.page * PAGE_SIZE)
    for (let i = 0; i < count; i++) {
      const sk = document.createElement("div")
      sk.className = "explore-card-skeleton"
      this.panelTarget.insertBefore(sk, this.sentinelTarget)
    }
  }

  removeSkeletons() {
    this.panelTarget.querySelectorAll(".explore-card-skeleton").forEach(el => el.remove())
  }

  showEndMessage() {
    if (this.panelTarget.querySelector(".explore-end")) return
    const el = document.createElement("div")
    el.className = "explore-end"
    el.textContent = "Você chegou ao fim da lista"
    this.panelTarget.insertBefore(el, this.sentinelTarget)
  }

  hideEndMessage() {
    this.panelTarget.querySelector(".explore-end")?.remove()
  }

  // ---- Modal ----

  openModal(club) {
    this.modalTitleTarget.textContent = club.name

    const courts = club.courts > 0
      ? `<div class="explore-modal-row"><i class="bi bi-grid-3x3-gap-fill"></i><span>${club.courts} ${club.courts === 1 ? "quadra disponível" : "quadras disponíveis"}</span></div>`
      : ""

    const wazeIcon = `<svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16" style="flex-shrink:0">
      <path d="M12 2C6.48 2 2 6.48 2 12c0 2.85 1.15 5.44 3.01 7.34L4 22l3.2-1.07C8.65 21.63 10.28 22 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z"/>
      <circle cx="9" cy="11" r="1.2" fill="white"/>
      <circle cx="15" cy="11" r="1.2" fill="white"/>
      <path d="M9 14q3 2.5 6 0" stroke="white" stroke-width="1.2" fill="none" stroke-linecap="round"/>
    </svg>`

    this.modalBodyTarget.innerHTML = `
      <div class="explore-modal-hero">
        <img src="https://picsum.photos/seed/${club.id}_0/600/320" alt="${club.name}">
      </div>
      <div class="explore-modal-details">
        <div class="explore-modal-row"><i class="bi bi-geo-alt-fill"></i><span>${club.address}</span></div>
        ${club.phone ? `<div class="explore-modal-row"><i class="bi bi-telephone-fill"></i><span>${club.phone}</span></div>` : ""}
        ${courts}
      </div>
      <a href="https://waze.com/ul?ll=${club.lat},${club.lng}&navigate=yes"
         class="explore-modal-waze-btn" target="_blank" rel="noopener noreferrer">
        ${wazeIcon} Abrir no Waze
      </a>
    `

    this.modalOverlayTarget.style.display = "flex"
    document.body.style.overflow = "hidden"
  }

  closeModal() {
    this.modalOverlayTarget.style.display = "none"
    document.body.style.overflow = ""
  }

  handleOverlayClick(e) {
    if (e.target === this.modalOverlayTarget) this.closeModal()
  }

  buildCard(club) {
    const el = document.createElement("div")
    el.className     = "explore-card"
    el.style.display = "flex"
    el.dataset.clubMapTarget = "card"
    el.dataset.id   = club.id
    el.dataset.name = club.name.toLowerCase()
    el.dataset.action = "mouseenter->club-map#highlightMarker mouseleave->club-map#resetMarker click->club-map#focusClub"

    const courts = club.courts > 0
      ? `<span class="explore-card-courts"><i class="bi bi-grid-3x3-gap-fill"></i> ${club.courts} ${club.courts === 1 ? "quadra" : "quadras"}</span>`
      : ""

    let slides = "", dots = ""
    for (let i = 0; i < 5; i++) {
      slides += `<img src="https://picsum.photos/seed/${club.id}_${i}/400/200" class="explore-slide${i === 0 ? " active" : ""}" loading="lazy" alt="">`
      dots   += `<span class="${i === 0 ? "active" : ""}"></span>`
    }

    el.innerHTML = `
      <div class="explore-card-main">
        <div class="explore-card-slider">
          ${slides}
          <div class="explore-slide-dots">${dots}</div>
          <button class="explore-slide-nav explore-slide-nav--prev" aria-label="Anterior">
            <i class="bi bi-chevron-left"></i>
          </button>
          <button class="explore-slide-nav explore-slide-nav--next" aria-label="Próximo">
            <i class="bi bi-chevron-right"></i>
          </button>
        </div>
        <div class="explore-card-body">
          <div class="explore-card-top">
            <h3 class="explore-card-name">${club.name}</h3>
            ${courts}
          </div>
          <p class="explore-card-addr"><i class="bi bi-geo-alt"></i> ${club.address}</p>
          ${club.phone ? `<p class="explore-card-phone"><i class="bi bi-telephone"></i> ${club.phone}</p>` : ""}
        </div>
      </div>
      <div class="explore-card-footer">
        <button class="explore-card-btn explore-card-btn--detail">
          <i class="bi bi-info-circle"></i> Detalhes
        </button>
        <a href="https://waze.com/ul?ll=${club.lat},${club.lng}&navigate=yes"
           class="explore-card-btn explore-card-btn--waze"
           target="_blank" rel="noopener noreferrer">
          <svg viewBox="0 0 24 24" fill="currentColor" width="15" height="15" style="flex-shrink:0">
            <path d="M12 2C6.48 2 2 6.48 2 12c0 2.85 1.15 5.44 3.01 7.34L4 22l3.2-1.07C8.65 21.63 10.28 22 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z"/>
            <circle cx="9" cy="11" r="1.2" fill="white"/>
            <circle cx="15" cy="11" r="1.2" fill="white"/>
            <path d="M9 14q3 2.5 6 0" stroke="white" stroke-width="1.2" fill="none" stroke-linecap="round"/>
          </svg>
          Waze
        </a>
      </div>
    `

    el.querySelector(".explore-card-footer").addEventListener("click", e => e.stopPropagation())
    el.querySelector(".explore-card-btn--detail").addEventListener("click", () => this.openModal(club))

    let current = 0
    const slideEls = el.querySelectorAll(".explore-slide")
    const dotEls   = el.querySelectorAll(".explore-slide-dots span")

    const goTo = (idx) => {
      slideEls[current].classList.remove("active")
      dotEls[current].classList.remove("active")
      current = (idx + slideEls.length) % slideEls.length
      slideEls[current].classList.add("active")
      dotEls[current].classList.add("active")
    }

    const resetTimer = () => {
      clearInterval(el._slideInterval)
      el._slideInterval = setInterval(() => goTo(current + 1), 3000)
    }

    el.querySelector(".explore-slide-nav--prev").addEventListener("click", e => {
      e.stopPropagation(); goTo(current - 1); resetTimer()
    })
    el.querySelector(".explore-slide-nav--next").addEventListener("click", e => {
      e.stopPropagation(); goTo(current + 1); resetTimer()
    })

    el._slideInterval = setInterval(() => goTo(current + 1), 3000)

    return el
  }

  // ---- Search ----

  search(event) {
    const q = event.target.value.toLowerCase().trim()

    if (this.hasLoaderTarget) this.loaderTarget.classList.add("active")

    clearTimeout(this._searchTimer)
    this._searchTimer = setTimeout(() => {
      this.filteredClubs = q
        ? this.allClubs.filter(c =>
            c.name.toLowerCase().includes(q) || c.address?.toLowerCase().includes(q)
          )
        : [...this.allClubs]

      this.panelTarget.querySelectorAll(".explore-card").forEach(el => {
        clearInterval(el._slideInterval)
        el.remove()
      })
      this.hideEndMessage()
      this.page = 0

      if (this.filteredClubs.length > 0) {
        this.renderBatch()
        if (this.hasEmptyTarget) this.emptyTarget.style.display = "none"
      } else {
        if (this.hasEmptyTarget) this.emptyTarget.style.display = "flex"
      }

      this.countTarget.textContent = this.filteredClubs.length
      if (this.hasLoaderTarget) this.loaderTarget.classList.remove("active")
    }, 220)
  }

  // ---- Map ----

  loadGoogleMaps() {
    if (window.google?.maps) { this.initMap(); return }
    const script = document.createElement("script")
    script.src = `https://maps.googleapis.com/maps/api/js?key=${window.__GMAPS_KEY__}&callback=__initExploreMap`
    script.async = true
    window.__initExploreMap = () => this.initMap()
    document.head.appendChild(script)
  }

  initMap() {
    this.map = new google.maps.Map(this.mapTarget, {
      center:            { lat: -15.7801, lng: -47.9292 },
      zoom:              5,
      styles:            this.mapStyles(),
      mapTypeControl:    false,
      streetViewControl: false,
      fullscreenControl: false,
    })

    this.infoWindow = new google.maps.InfoWindow()
    this.allClubs.forEach(club => this.addMarker(club))

    this._themeObserver = new MutationObserver(() => {
      this.map.setOptions({ styles: this.mapStyles() })
    })
    this._themeObserver.observe(document.documentElement, {
      attributes: true, attributeFilter: ["data-theme"]
    })
  }

  mapStyles() {
    return document.documentElement.getAttribute("data-theme") !== "light" ? DARK_STYLES : []
  }

  markerIcon(active = false) {
    return {
      path:         google.maps.SymbolPath.CIRCLE,
      fillColor:    active ? "#4ade80" : "#ffffff",
      fillOpacity:  1,
      strokeColor:  active ? "#07080f" : "#1a1a2e",
      strokeWeight: active ? 2 : 1.5,
      scale:        active ? 11 : 8,
    }
  }

  addMarker(club) {
    const marker = new google.maps.Marker({
      position: { lat: club.lat, lng: club.lng },
      map:      this.map,
      title:    club.name,
      icon:     this.markerIcon(false),
    })
    marker.addListener("click", () => {
      this.setActive(club.id)
      this.openInfoWindow(club, marker)
      this.scrollToCard(club.id)
    })
    this.markers[club.id] = marker
  }

  openInfoWindow(club, marker) {
    const courts = club.courts > 0
      ? `<span class="eiw-courts"><i class="bi bi-grid-3x3-gap-fill"></i> ${club.courts} ${club.courts === 1 ? "quadra" : "quadras"}</span>`
      : ""
    this.infoWindow.setContent(`
      <div class="explore-info-window">
        <p class="eiw-name">${club.name}</p>
        <p class="eiw-addr"><i class="bi bi-geo-alt-fill"></i> ${club.address}</p>
        ${club.phone ? `<p class="eiw-phone"><i class="bi bi-telephone-fill"></i> ${club.phone}</p>` : ""}
        ${courts}
      </div>
    `)
    this.infoWindow.open(this.map, marker)
  }

  highlightMarker(event) {
    const id = parseInt(event.currentTarget.dataset.id)
    const marker = this.markers[id]
    if (marker && id !== this.activeId) marker.setIcon(this.markerIcon(true))
  }

  resetMarker(event) {
    const id = parseInt(event.currentTarget.dataset.id)
    const marker = this.markers[id]
    if (marker && id !== this.activeId) marker.setIcon(this.markerIcon(false))
  }

  focusClub(event) {
    const id   = parseInt(event.currentTarget.dataset.id)
    const club = this.allClubs.find(c => c.id === id)
    if (!club) return

    this.setActive(id)
    this.map.panTo({ lat: club.lat, lng: club.lng })
    this.map.setZoom(14)
    this.openInfoWindow(club, this.markers[id])
  }

  setActive(id) {
    if (this.activeId && this.markers[this.activeId]) {
      this.markers[this.activeId].setIcon(this.markerIcon(false))
    }
    this.cardTargets.forEach(el => {
      el.classList.toggle("explore-card--active", parseInt(el.dataset.id) === id)
    })
    this.activeId = id
    if (this.markers[id]) this.markers[id].setIcon(this.markerIcon(true))
  }

  scrollToCard(id) {
    const card = this.cardTargets.find(el => parseInt(el.dataset.id) === id)
    if (card) card.scrollIntoView({ behavior: "smooth", block: "nearest" })
  }
}
