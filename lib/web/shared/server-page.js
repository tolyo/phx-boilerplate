import { LitElement, html } from "lit";
import { unsafeHTML } from "lit/directives/unsafe-html.js";


/**
 * Component for rendering server pages set via url attribute.
 */
export class ServerPage extends LitElement {
  static properties = {
    content: { state: true },
    url: {},
  };

  connectedCallback() {
    super.connectedCallback();
    if (!this.url) {
      this.url = this.location.getUrl();
    } 
    return this.getContent(this.url);
  }

  getContent(url) {
    return fetch(url)
      .then((res) => res.text())
      .then((body) => (
        this.content = unsafeHTML(body)
      ))
      .then(() => {
        console.log(this.content);
        this.render();
      });
  }

  createRenderRoot() {
    return this;
  }

  render() {
    return html`${this.content}`;
  }
}
