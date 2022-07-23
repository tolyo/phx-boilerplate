import { LitElement, html} from "lit";
import { unsafeHTML } from 'lit/directives/unsafe-html.js'

export class ServerPage extends LitElement {
    static properties = {
        content: {state: true},
    };
   
   constructor() {
     super();
     this.content = '';
     fetch("/test")
        .then(res => res.text())
        .then(body => this.content = unsafeHTML(body));
   }


   createRenderRoot() {
     return this;
   }
  
 
   render() {
     return html`${this.content}`; 
   }
}

 