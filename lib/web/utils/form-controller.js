// Create an empty input event
const inputEvent = new Event("input", {
  bubbles: true, // Allow the event to bubble up through the DOM tree
  cancelable: true, // Allow the event to be canceled
});

/**
 * Default controller for working with forms. Initiated by default for all forms
 * on document load.
 */
export default class FormController {
  /**
   * @param {HTMLFormElement} form - The HTML form element to be controlled.
   */
  constructor(form) {
    /**
     * @type {HTMLFormElement} - The HTML form element being controlled.
     */
    this.form = form;
    if (!this.form) {
      throw new Error("Form required");
    }

    // Prevent the form from submitting and call the submit() method instead
    this.form.addEventListener("submit", (ev) => {
      ev.preventDefault();
      this.submit();
    });

    /**
     * @type {Object.<string, string>} - Data model to store form field values.
     */
    this.dataModel = {};

    // Loop through form elements to handle input and select fields
    Array.from(this.form.elements).forEach((i) => {
      // Input handler
      if (i instanceof HTMLInputElement) {
        if (i.name === "_csrf_token") {
          this.csrf = i.value;
        }
        i.addEventListener("input", () => {
          this.dataModel[i.name] = i.value;
          // Clear all error messages
          this.clearAllMessages();
        });
      }

      // Select handler
      if (i instanceof HTMLSelectElement) {
        this.dataModel[i.name] = i.value; // Set initial value
        i.addEventListener("change", () => {
          this.dataModel[i.name] = i.value;
          // Clear all error messages
          this.clearAllMessages();
        });
      }
    });
  }

  /**
   * Clear all error messages
   */
  clearAllMessages() {
    // Remove invalid states from inputs
    Array.from(this.form.elements).forEach((e) =>
      e.removeAttribute("aria-invalid"),
    );
    // Remove spans with error messages
    this.form.querySelectorAll("span.error").forEach((x) => x.remove());
    // Remove error class from labels
    Array.from(this.form.getElementsByClassName("error")).forEach((x) =>
      x.classList.remove("error"),
    );
  }

  /**
   * Submit the form data
   */
  submit() {
    this.clearAllMessages();
    const { action } = this.form.dataset;
    Array.from(this.form.elements).forEach((i) => i.dispatchEvent(inputEvent));
    fetch(action, this.maybeAttachBody()).then((res) => {
      if ([200, 201].includes(res.status)) {
        this.onSuccess(res);
      } else {
        this.onError(res);
      }
    });
  }

  /**
   * Success callback
   * @param {Response} res - response data to pass to on-success callback
   */
  async onSuccess(res) {
    // Execute the JavaScript code specified in the "on-success" attribute
    // eslint-disable-next-line no-eval
    this.res = res;
    // eslint-disable-next-line no-eval
    eval(`${this.form.dataset.success}`);
    const { update } = this.form.dataset;
    if (update) {
      const partial = document.querySelector(update);
      if (partial) {
        partial.innerHTML = await res.text();
      } else {
        throw new Error("Partial not found");
      }
    }
  }

  /**
   * Error callback
   * TODO: switch to Validation API!
   * @param {Response} res - The response object.
   */
  onError(res) {
    this.res = res;
    this.clearAllMessages();
    res.json().then((err) => {
      Object.keys(err).forEach((x) => {
        const input = this.form.elements[x];
        input.setAttribute("aria-invalid", "true");
        const helper = document.createElement("span");
        helper.classList.add("error");
        helper.innerHTML = err[x];
        input.after(helper);

        // Apply the "error" class to corresponding labels
        if (input.labels && input.labels[0]) {
          input.labels[0].classList.add("error");
        }
      });
    });
  }

  /**
   * Determine whether to attach a request body and headers
   * based on the form's method.
   */
  maybeAttachBody() {
    // if (this.form.method === "get") {
    //   return {};
    // }
    return {
      method: "POST",
      body: JSON.stringify(this.dataModel),
      headers: {
        "Content-Type": "application/json",
        "x-csrf-token": this.csrf,
      },
    };
  }

  /**
   * Destroy the FormController instance.
   */
  destroy() {
    // Remove the "submit" event listener
    // this.form.removeEventListener("submit", this.handleSubmit);

    // // Remove input and select event listeners
    // Array.from(this.form.elements).forEach((element) => {
    //   if (element instanceof HTMLInputElement) {
    //     element.removeEventListener("input", this.handleInput);
    //   } else if (element instanceof HTMLSelectElement) {
    //     element.removeEventListener("change", this.handleChange);
    //   }
    // });

    this.form = null;
  }
}
