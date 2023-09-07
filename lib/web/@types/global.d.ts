import {Application} from '@hotwired/stimulus/dist/types/';

declare global {
  interface Window {
    Stimulus: Application;
  }
}

export {};
