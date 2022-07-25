import { ServerPage } from "../shared/server-page";
import { html } from 'lit';
class HomePage extends ServerPage {

    render() {
        return html`<server-page url="home"></server-page>`
    }

}

customElements.define("home-page", HomePage)