import { test, expect, request } from "@playwright/test";
var invCode = "";
var user = { email: "userr1@owner.com", pass: "useruser" };
var owner = { email: "ownerr1@owner.com", pass: "ownerowner" };
var org = "Firmaa1";

test.beforeAll(async ({ browser }) => {
  const page = await browser.newPage();
  const reqContext = await request.newContext();
  await reqContext.post("http://localhost:3000/api/test/reset");
  await reqContext.dispose();

  // create users
  // owner
  await page.goto("http://localhost:5173");
  await page.getByRole("link", { name: "Register" }).click();
  await page.waitForTimeout(3000);
  await page.getByRole("textbox", { name: "* Email" }).click();
  await page.getByRole("textbox", { name: "* Email" }).fill(owner["email"]);
  await page.getByRole("textbox", { name: "* Password" }).click();
  await page.getByRole("textbox", { name: "* Password" }).fill(owner["pass"]);
  await page.getByRole("textbox", { name: "First name" }).click();
  await page.getByRole("textbox", { name: "First name" }).fill("Owner");
  await page.getByRole("textbox", { name: "Last name" }).click();
  await page.getByRole("textbox", { name: "Last name" }).fill("Vlasnik");
  await page.getByRole("combobox", { name: "* Role" }).click();
  await page.getByText("Owner", { exact: true }).click();
  await page.getByRole("button", { name: "Register" }).click();
  await expect(page.getByRole("heading")).toContainText("Login");

  // user
  await page.getByRole("link", { name: "Register" }).click();
  await page.waitForTimeout(3000);
  await page.getByRole("textbox", { name: "* Email" }).click();
  await page.getByRole("textbox", { name: "* Email" }).fill(user["email"]);
  await page.getByRole("textbox", { name: "* Password" }).click();
  await page.getByRole("textbox", { name: "* Password" }).fill(user["pass"]);
  await page.getByRole("textbox", { name: "First name" }).click();
  await page.getByRole("textbox", { name: "First name" }).fill("User");
  await page.getByRole("textbox", { name: "Last name" }).click();
  await page.getByRole("textbox", { name: "Last name" }).fill("korisnik");
  await page.getByRole("combobox", { name: "* Role" }).click();
  await page.getByText("Employee", { exact: true }).click();
  await page.getByRole("button", { name: "Register" }).click();
  await expect(page.getByRole("heading")).toContainText("Login");

  await page.close();
});

test.describe("Owner Flow", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("http://localhost:5173/login");
    await page.getByRole("textbox", { name: "* Email" }).fill(owner["email"]);
    await page.getByRole("textbox", { name: "* Password" }).fill(owner["pass"]);
    await page.getByRole("button", { name: "Login" }).click();
    await expect(page.getByRole("main")).toContainText("Time report");
  });

  test("Owner can create organization", async ({ page }) => {
    await page.getByRole("link", { name: "Organizations" }).click();
    await page.getByRole("button", { name: "Create Organization" }).click();
    await page.getByRole("textbox", { name: "* Organization Name" }).click();
    await page.getByRole("textbox", { name: "* Organization Name" }).fill(org);
    await page.getByRole("textbox", { name: "Description" }).click();
    await page.getByRole("textbox", { name: "Description" }).fill("desc");
    await page.getByRole("textbox", { name: "Established at:" }).click();
    await page
      .getByRole("textbox", { name: "Established at:" })
      .fill("2025-05-20");
    await page.getByRole("button", { name: "Create", exact: true }).click();
    await expect(page.getByRole("main")).toContainText(org);
    await expect(page.getByRole("paragraph")).toContainText("desc");
  });

  test("Owner can create project", async ({ page }) => {
    await page.getByRole("link", { name: "Projects" }).click();
    await expect(page.getByRole("paragraph")).toContainText(
      "No projects to display."
    );
    await page.getByRole("button", { name: "Create project" }).click();
    await page.getByRole("textbox", { name: "* Name" }).click();
    await page.getByRole("textbox", { name: "* Name" }).fill("projekt");
    await page.getByRole("textbox", { name: "Description" }).click();
    await page
      .getByRole("textbox", { name: "Description" })
      .fill("desc projekt");
    await page.getByRole("textbox", { name: "Start & End Date" }).click();
    await page
      .getByRole("textbox", { name: "Start & End Date" })
      .fill("2025-05-20");
    await page.getByRole("textbox", { name: "End date", exact: true }).click();
    await page
      .getByRole("textbox", { name: "End date", exact: true })
      .fill("2026-05-20");
    await page.getByRole("spinbutton", { name: "Budget Amount" }).click();
    await page.getByRole("spinbutton", { name: "Budget Amount" }).fill("1000");
    await page
      .locator(
        ".ant-form-item-control-input-content > .ant-select > .ant-select-selector > .ant-select-selection-wrap > .ant-select-selection-search"
      )
      .click();
    await page.getByText(org).click();
    await page.getByRole("button", { name: "Create", exact: true }).click();
    await expect(page.getByRole("main")).toContainText("projekt");
    await expect(page.getByRole("main")).toContainText("Organisation: " + org);
  });

  test("Owner can create invitation", async ({ page }) => {
    await page.getByRole("link", { name: "Organizations" }).click();
    await page.getByRole("button", { name: "Invitations" }).click();
    await page.getByRole("button", { name: "Create invitations" }).click();
    await page.waitForTimeout(3000);

    const visibleTd = await page
      .locator("tbody tr td")
      .filter({ hasText: /.*/ })
      .first();
    const invitationCode = await visibleTd.textContent();
    if (!invitationCode || invitationCode.trim() === "") {
      throw new Error(
        "Invitation code could not be found in the first visible <td> of <tbody>."
      );
    }
    console.log(invCode);
    invCode = invitationCode.trim();
    await page.getByRole("button", { name: "Close" }).click();
  });

  test("Owner can logout", async ({ page }) => {
    await page.getByRole("button", { name: "logout Logout" }).click();
    await expect(page.getByRole("heading")).toContainText("Login");
  });
});

test.describe("User Flow", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("http://localhost:5173/login");
    await page.getByRole("textbox", { name: "* Email" }).fill(user["email"]);
    await page.getByRole("textbox", { name: "* Password" }).fill(user["pass"]);
    await page.getByRole("button", { name: "Login" }).click();
    await expect(page.getByRole("main")).toContainText("Time report");
  });

  test("User can join organization", async ({ page }) => {
    await page.getByRole("link", { name: "Organizations" }).click();
    await page.getByRole("button", { name: "Join Organization" }).click();
    await page.getByRole("textbox", { name: "* Organization token" }).click();
    await page
      .getByRole("textbox", { name: "* Organization token" })
      .fill(invCode);
    await page.getByRole("button", { name: "Join", exact: true }).click();
    await expect(page.getByRole("main")).toContainText(org);
    await expect(page.getByRole("paragraph")).toContainText("desc");
  });

  test("User can insert time log", async ({ page }) => {
    await page.getByRole("button", { name: "Insert time" }).click();
    await page.getByRole("textbox", { name: "* Date" }).click();
    await page.locator(".ant-picker-input").first().click();
    await page.getByText("Today").click();
    await page.getByRole("textbox", { name: "* Time Range" }).fill("00:30");
    await page.getByRole("button", { name: "OK" }).click();
    await page.getByRole("textbox", { name: "End time" }).fill("02:30");
    await page.getByRole("button", { name: "OK" }).click();
    await page.getByRole("combobox", { name: "* Activity Type" }).click();
    await page.getByTitle("On site").click();
    await page.getByRole("textbox", { name: "Description" }).click();
    await page.getByRole("textbox", { name: "Description" }).fill("aaa");
    await page.getByRole("combobox", { name: "* Project" }).click();
    await page.getByTitle("projekt").locator("div").click();
    await page.getByRole("button", { name: "Insert", exact: true }).click();
    await expect(page.locator("tbody")).toContainText("aaa");
    await page.getByRole("cell", { name: "on_site" }).first().click();
  });

  test("User can edit time log", async ({ page }) => {
    await page.getByRole("button", { name: "Edit" }).nth(0).click();
    await page
      .getByLabel("Edit Work Log")
      .getByText("aaa", { exact: true })
      .fill("edit");
    await page.getByRole("button", { name: "Save" }).click();
    await page.waitForTimeout(3000);
    await expect(page.locator("tbody")).toContainText("edit");
  });

  test("User can delete time log", async ({ page }) => {
    await page.getByRole("button", { name: "Delete" }).first().click();
    await page.waitForTimeout(3000);
    await expect(page.getByRole("cell")).toContainText("No data");
  });

  test("User can open profile page", async ({ page }) => {
    await page.getByRole("link", { name: "Employee: User user" }).click();
    await expect(page.getByRole("rowgroup")).toContainText(user["email"]);
    await expect(page.getByRole("rowgroup")).toContainText("employee");
  });

  test("User can logout", async ({ page }) => {
    await page.getByRole("button", { name: "logout Logout" }).click();
    await expect(page.getByRole("heading")).toContainText("Login");
  });
});
