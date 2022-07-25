import "./shared/shared";
import "./home/home";
import {Router} from '@vaadin/router';

window.onload = () => {
    const mount = document.getElementById('outlet');
    const router = new Router(mount);
    router.setRoutes([
      {path: '/', component: 'home-page'},
      {path: '/login', component: 'server-page'},
      {path: '/register', component: 'server-page'}
    ]);
    
}
