import {LitElement, html} from 'lit';
import {DirectiveResult} from 'lit-html/directive';
import {unsafeHTML, UnsafeHTMLDirective} from 'lit/directives/unsafe-html.js';

/**
 * Component for rendering server pages set via url attribute.
 */
export class ServerPage extends LitElement {
  static properties = {
    content: {state: true},
    url: {},
  };

  url: string;
  content?: DirectiveResult<typeof UnsafeHTMLDirective>;

  constructor(url: string) {
    super();
    this.url = url;
  }

  connectedCallback() {
    super.connectedCallback();
    return this.getContent(this.url);
  }

  getContent(url: string) {
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
