import {LitElement, html} from 'lit';
import {unsafeHTML} from 'lit/directives/unsafe-html.js';

/**
 * Component for rendering server pages set via url attribute.
 */
export class ServerPage extends LitElement {
  static properties = {
    content: {state: true},
    url: {},
  };

  /**
   * @param {string} url
   */
  constructor(url) {
    super();
    this.url = url;
  }

  connectedCallback() {
    super.connectedCallback();
    return this.getContent(this.url);
  }

  /**
   *
   * @param {string} url
   * @returns
   */
  getContent(url) {
    return fetch(url)
      .then(res => res.text())
      .then(body => (this.content = unsafeHTML(body)))
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

customElements.define('server-page', ServerPage);
