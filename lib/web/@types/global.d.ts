import { StateService, UIRouter } from "@uirouter/core";
import { Alpine } from "alpinejs";

declare global {
  interface Window {
    Alpine: Alpine;
    router: UIRouter;
    stateService: StateService;
    EventBus: EventTarget;
  }
}

export {};
