import { ServerPage } from "../../shared/server-page";
class LoginPage extends ServerPage {
  constructor() {
    super("_login");
  }
}

customElements.define("login-page", LoginPage);
