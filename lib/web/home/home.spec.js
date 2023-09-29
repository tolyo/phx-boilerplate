/* eslint-disable import/no-extraneous-dependencies */
// @ts-check
import { test, expect } from "@playwright/test";

test("has greeting", async ({ page }) => {
  await page.goto("http://localhost:4000/");
  await expect(page).toBeTruthy();
  const element = await page.$("body");
  const textContent = await element.textContent();

  await expect(textContent).toMatch(/PHX/);
  await expect(textContent).toMatch(/Boilerplate/);
});
