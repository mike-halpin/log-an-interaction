import { LightningElement } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class LaunchFlow extends NavigationMixin(LightningElement) {
  connectedCallback() {
    this.startFlow();
  }

  startFlow() {
    // Navigate to the flow
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: "/flow/LogInteractionSaga"
      }
    });
  }
}
