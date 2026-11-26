import Map from "ol/Map.js";
import View from "ol/View.js";
import TileLayer from "ol/layer/Tile.js";
import OSM from "ol/source/OSM.js";
import { fromLonLat } from "ol/proj.js";

window.initializeOpenLayers = function (element) {
  const map = new Map({
    target: element,

    layers: [
      new TileLayer({
        source: new OSM()
      })
    ],

    view: new View({
      center: [0, 0],
      zoom: 2
    })
  });

  return map;
};
window.setOpenLayersLocation = function (map, longitude, latitude) {
  map.getView().setCenter(fromLonLat([longitude, latitude]));

  map.getView().setZoom(12);
};
