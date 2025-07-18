import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
// import mapboxgl from 'mapbox-gl'
// import window.mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }


  connect() {
    window.mapboxgl.accessToken = this.apiKeyValue

    this.map = new window.window.mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()

    this.map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
                                        mapboxgl: mapboxgl }))
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
    new window.window.mapboxgl.Marker()
      .setLngLat([ marker.lng, marker.lat ])
      .addTo(this.map)
  })
  }

  #fitMapToMarkers() {
  const bounds = new window.mapboxgl.LngLatBounds()
  this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
  this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
}

}
