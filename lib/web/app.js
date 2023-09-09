import './shared/shared'
import './home/home'
import './auth/auth'
import { Router } from '@vaadin/router'
import { Application } from '@hotwired/stimulus'
import { ExampleController } from './stimulus/example-controller'

window.onload = () => {
  const mount = document.getElementById('outlet')
  if (mount) {
    // Web-component example with Lit and Vaadin router
    const router = new Router(mount)
    router.setRoutes([
      { path: '/', component: 'home-page' },
      { path: '/login', component: 'login-page' },
      { path: '/register', component: 'server-page' }
    ])
  }

  // Stimulus example
  window.Stimulus = Application.start()
  window.Stimulus.register('example', ExampleController)
  console.log('Stimulus started')
}
