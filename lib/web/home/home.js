import { ServerPage } from "../shared/server-page";
class HomePage extends ServerPage {
  constructor() {
    super("_home");
  }
}

customElements.define("home-page", HomePage);
