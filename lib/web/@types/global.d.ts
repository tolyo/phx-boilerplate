import { StateService, UIRouter } from "@uirouter/core";
import { Alpine } from "alpinejs";
import FormController from "../utils/form-controller";

declare global {
  interface Window {
    Alpine: Alpine;
    router: UIRouter;
    stateService: StateService;
    EventBus: EventTarget;
    FormControllers: Array<FormController>;
  }
}

export {};
