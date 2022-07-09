import { Controller } from '@hotwired/stimulus';

/*
 * Usage
 * =====
 *
 * add data-controller="flash" to flash container
 *
 * Action (for close cross):
 * data-action="click->flash#dismiss"
 *
 */
export default class extends Controller {
  connect() {
    console.log('connected');
    setTimeout(() => {
      this.hideAlert();
    }, 3000);
  }

  dismiss(event) {
    event.preventDefault();
    event.stopPropagation();

    this.hideAlert();
  }

  hideAlert() {
    this.element.style.display = 'none';
  }
}
