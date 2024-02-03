/* eslint-disable import/no-extraneous-dependencies */
// @ts-check
import { test, expect } from "@playwright/test";

test("has greeting", async ({ page }) => {
  await page.goto("http://localhost:4000/");
  expect(page).toBeTruthy();
  const element = await page.$("body");
  const textContent = await element.textContent();

  expect(textContent).toMatch(/APP/);
  expect(textContent).toMatch(/Boilerplate/);
});
