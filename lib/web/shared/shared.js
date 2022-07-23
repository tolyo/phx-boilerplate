
import { ServerPage } from "./server-page";

[
    ['server-page', ServerPage]
].forEach(x => customElements.define(x[0], x[1]))