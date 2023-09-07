import {Controller} from '@hotwired/stimulus';

export class ExampleController extends Controller {
  static targets = ['name', 'output'];
  declare readonly outputTarget: HTMLInputElement;
  declare readonly nameTarget: HTMLInputElement;

  greet() {
    console.log('Hello, Stimulus!', this.element);
    this.outputTarget.textContent = this.nameTarget.value;
  }
}
