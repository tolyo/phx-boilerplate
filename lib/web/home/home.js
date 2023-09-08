import {ServerPage} from '../shared/server-page';
export class HomePage extends ServerPage {
  constructor() {
    super('_home');
  }
}

customElements.define('home-page', HomePage);
