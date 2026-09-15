import { LightningElement } from "lwc";
import getGeocodeInfo from "@salesforce/apex/GetAddressCoordinates.getGeocodeInfo";
import getToastMsg from "lightning/toast";
export default class AddressCoordinatesSearch extends LightningElement {
  street;
  city;
  state;
  postcode;
  country;
  address;

  handleInputChange(event) {
    this[event.target.name] = event.target.value;
  }

  async handleClick() {
    this.address =
      this.street +
      " " +
      this.city +
      " " +
      this.state +
      " " +
      this.postcode +
      " " +
      this.country;
    const results = await getGeocodeInfo({
      address: this.address
    });
    const features = JSON.parse(results).features;
    if (features && features.length > 0) {
      const longitude = features[0].properties.lon;
      const latitude = features[0].properties.lat;
      this.dispatchEvent(
        new CustomEvent("coordinatesfound", {
          detail: {
            longitude: longitude,
            latitude: latitude
          }
        })
      );
      getToastMsg.show(
        {
          label: "Coordinates found!",
          message: "Coordinate Search was Successful",
          variant: "success"
        },
        this
      );
    } else {
      getToastMsg.show(
        {
          label: "No coordinates found",
          message: "Unable to find coordinates for the given address",
          variant: "error"
        },
        this
      );
    }
  }
}
