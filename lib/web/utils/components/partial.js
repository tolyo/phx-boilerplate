class PartialComponent extends HTMLElement {
  connectedCallback() {
    const url = this.getAttribute("url");
    if (!url)
      throw new Error("`url` parameter not supplied to partial component");
    return fetch(url)
      .then((res) => res.text())
      .then((body) => {
        this.innerHTML = body;
      });
  }
}

customElements.define("partial-component", PartialComponent);
