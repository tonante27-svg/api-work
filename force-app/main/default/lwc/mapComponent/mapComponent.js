import { LightningElement } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import OPENLAYERS from "@salesforce/resourceUrl/openlayers";

export default class MapComponent extends LightningElement {
  mapInitialized = false;

  renderedCallback() {
    if (this.mapInitialized) {
      return;
    }

    this.mapInitialized = true;

    console.log("OPENLAYERS resource URL:", OPENLAYERS);
    console.log("OpenLayers JS URL:", OPENLAYERS + "/openlayers.js");

    loadScript(this, OPENLAYERS + "/openlayers.js")
      .then(() => {
        console.log("OpenLayers loaded");

        this.map = window.initializeOpenLayers(this.refs.map);

        console.log("Map initialized:", this.map);
      })
      .catch((error) => {
        console.error("OpenLayers load error:", error);
      });
  }

  handleCoordinates(event) {
    const { latitude, longitude } = event.detail;
    console.log("Coordinates received:", latitude, longitude);

    window.setOpenLayersLocation(this.map, longitude, latitude);
  }
}
