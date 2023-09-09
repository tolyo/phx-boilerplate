import { Controller } from '@hotwired/stimulus'

export class ExampleController extends Controller {
  static targets = ['name', 'output']
  greet () {
    console.log('Hello, Stimulus!', this.element)
    // @ts-ignore
    this.outputTarget.textContent = this.nameTarget.value
  }
}
