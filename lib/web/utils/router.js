/**
 * Fetches content and renders it into the DOM for a given state definition.
 *
 * @param {import("@uirouter/core").StateDeclaration} stateDef - The state definition object.
 * @returns {Promise<void>} A promise that resolves when the content is fetched and rendered.
 */
export function fetchIntoDom(stateDef) {
  /**
   * @type {import("@uirouter/core").StateObject}
   */
  const state = stateDef.$$state();

  /**
   * The parent element's ID where the content will be rendered.
   * Defaults to "root" if the state has no parent.
   *
   * @type {string}
   */
  const parentId = state.parent.name || "root";

  /**
   * Extracts and constructs a URL path based on state parameters.
   *
   * @type {string}
   */
  const pathSegments = Object.keys(state.params)
    .filter(
      (key) =>
        key !== "server_path" &&
        state.params[key] !== null &&
        state.params[key] !== undefined,
    )
    .map((key) => `/${state.params[key]}`)
    .join("");

  /**
   * The parent element where the content will be rendered.
   *
   * @type {HTMLElement}
   */
  const parent = document.getElementById(parentId);

  /**
   * Fetches content from the server and renders it into the DOM.
   *
   * @type {Promise<Response>}
   */
  return fetch(
    stateDef.params.server_path
      ? stateDef.params.server_path + pathSegments
      : stateDef.url,
  )
    .then((response) => response.text())
    .then((text) => {
      parent.innerHTML = text;
    });
}

/**
 * Clears the rendered content from the DOM for a given state definition.
 *
 * @param {import("@uirouter/core").StateDeclaration} stateDef - The state definition object.
 */
export function clearRenderedDom(stateDef) {
  /**
   * @type {import("@uirouter/core").StateObject}
   */
  const state = stateDef.$$state();

  /**
   * The parent element's ID where the content was rendered.
   * Defaults to "root" if the state has no parent.
   *
   * @type {string}
   */
  const parentId = state.parent.name || "root";

  /**
   * The parent element from which to clear the content.
   *
   * @type {HTMLElement}
   */
  const parent = document.getElementById(parentId);

  // Clear the content by setting innerHTML to an empty string.
  parent.innerHTML = "";
}
