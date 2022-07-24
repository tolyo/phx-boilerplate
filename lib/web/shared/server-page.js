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
    fetch(this.url)
      .then((res) => res.text())
      .then((body) => (this.content = unsafeHTML(body)));
  }

  createRenderRoot() {
    return this;
  }

  render() {
    return html`${this.content}`;
  }
}
