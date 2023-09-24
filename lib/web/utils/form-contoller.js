/**
 * Default controller for working with forms. Initiated by default for all forms on document load.
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
    this.form.onsubmit = (ev) => {
      ev.preventDefault();
      this.submit();
    };

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
    this.form.querySelectorAll("span.error").forEach((x) => x.remove());
    Array.from(document.getElementsByClassName("error")).forEach((x) =>
      x.classList.remove("error"),
    );
  }

  /**
   * Submit the form data
   */
  submit() {
    this.clearAllMessages();
    fetch(this.form.action, this.maybeAttachBody()).then((res) => {
      if (res.status === 200 || res.status === 201) {
        this.onSuccess();
      } else {
        this.onError(res);
      }
    });
  }

  /**
   * Success callback
   */
  onSuccess() {
    // Execute the JavaScript code specified in the "on-success" attribute
    // eslint-disable-next-line no-eval
    eval(`${this.form.getAttribute("on-success")}`);
  }

  /**
   * Error callback
   * TODO: switch to Validation API!
   * @param {Response} res - The response object.
   */
  onError(res) {
    res.json().then((err) => {
      Object.keys(err).forEach((x) => {
        const input = this.form.elements[x];
        input.classList.add("error");
        const helper = document.createElement("span");
        helper.classList.add("error");
        helper.innerHTML = err[x];
        input.after(helper);

        // Apply the "error" class to corresponding labels
        this.form.querySelectorAll("label").forEach((label) => {
          if (label.children[parseInt(x, 10)] !== undefined) {
            label.classList.add("error");
          }
        });
      });
    });
  }

  /**
   * Determine whether to attach a request body and headers
   * based on the form's method.
   */
  maybeAttachBody() {
    if (this.form.method === "get") {
      return {};
    }
    return {
      method: this.form.method,
      body: JSON.stringify(this.dataModel),
      headers: {
        "Content-Type": "application/json",
        "x-csrf-token": this.csrf,
      },
    };
  }
}
