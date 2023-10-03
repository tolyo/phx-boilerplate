class PartialComponent extends HTMLElement {
  static observedAttributes = ["data-url"];

  connectedCallback() {
    this.getContent();
  }

  attributeChangedCallback() {
    this.getContent();
  }

  async getContent() {
    const { url } = this.dataset;
    if (!url) {
      throw new Error(`
        "url" data-attribute not supplied to partial component.
        Example: <partial data-url="/_foo"></partial>
      `);
    }
    this.innerHTML = await (await fetch(url)).text();
  }
}

customElements.define("partial-component", PartialComponent);
