import './shared/shared'
import './home/home'
import './auth/auth'
import { Router } from '@vaadin/router'

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

  console.log('Stimulus started')
}
