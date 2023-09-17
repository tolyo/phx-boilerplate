// @ts-nocheck
import './shared/shared'
import { pushStateLocationPlugin, servicesPlugin, UIRouter } from '@uirouter/core'
const router = new UIRouter()
router.plugin(pushStateLocationPlugin)
router.plugin(servicesPlugin)

// This transition hook renders each active states' html property
router.transitionService.onSuccess({}, (trans) => {
  trans.exiting().forEach(stateDef => clearRenderedDom(stateDef))
  trans.entering().forEach(stateDef => fetchIntoDom(stateDef))
})

router.transitionService.onError({}, (trans) => {
  console.error(trans)
})

window.router = router
window.stateService = router.stateService
router.stateRegistry.register({ name: 'home', url: '/', server_path: '/_home' })
router.stateRegistry.register({ name: 'state1.nest1', url: '/nest1' })
router.stateRegistry.register({ name: 'products', url: '/products', server_path: '/_products' })
router.stateRegistry.register({ name: 'products:new', url: '/products/new', server_path: '/_products/new' })
router.stateRegistry.register({ name: 'products:get', url: '/products/{id}', server_path: '/_products' })
router.stateRegistry.register({ name: 'products:edit', url: '/products/edit/{id}', server_path: '/_products/edit' })

router.urlService.rules.initial({ state: 'home' })
router.urlService.rules.otherwise({ state: 'home' })
router.urlService.listen()
router.urlService.sync()

/**
 *
 */
function fetchIntoDom (stateDef) {
  const state = stateDef.$$state()
  const parentId = state.parent.name || 'root'
  const stateParams = router.globals.params
  const pathSegments = Object.keys(stateParams)
    .filter(key => stateParams[key] !== null && stateParams[key] !== undefined)
    .map(key => `/${stateParams[key]}`)
    .join('')
  const parent = document.getElementById(parentId)
  return fetch(stateDef.server_path ? stateDef.server_path + pathSegments : stateDef.url)
    .then(response => response.text())
    .then(text => {
      parent.innerHTML = text
    })
}

function clearRenderedDom (stateDef) {
  const state = stateDef.$$state()
  const parentId = state.parent.name || 'root'
  const parent = document.getElementById(parentId)
  parent.innerHTML = ''
}
