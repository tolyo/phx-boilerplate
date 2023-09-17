// @ts-nocheck
import './shared/shared'
import { pushStateLocationPlugin, servicesPlugin, UIRouter } from '@uirouter/core'
const router = new UIRouter()
router.plugin(pushStateLocationPlugin)
router.plugin(servicesPlugin)

// This transition hook renders each active states' html property
router.transitionService.onSuccess({}, (trans, state) => {
  trans.exiting().forEach(stateDef => naiveClearRenderedDom(stateDef))
  trans.entering().forEach(stateDef => naiveRenderIntoDom(stateDef))
})

window.router = router
router.stateRegistry.register({ name: 'home', url: '/home' })
router.stateRegistry.register({ name: 'state1.nest1', url: '/nest1' })
router.stateRegistry.register({ name: 'products', url: '/products' })

router.urlService.rules.initial({ state: 'home' })
router.urlService.listen()
router.urlService.sync()

function naiveRenderIntoDom (stateDef) {
  const state = stateDef.$$state()
  const parentId = state.parent.name || 'root'
  console.log(`rendering into ${parentId}`)
  console.log(stateDef)
  const parent = document.getElementById(parentId)
  return fetch(stateDef.url)
    .then(response => response.text())
    .then(text => {
      parent.innerHTML = text
    })
}

function naiveClearRenderedDom (stateDef) {
  const state = stateDef.$$state()
  const parentId = state.parent.name || 'root'
  console.log(`clearing ${parentId}`)
  const parent = document.getElementById(parentId)
  parent.innerHTML = ''
}
