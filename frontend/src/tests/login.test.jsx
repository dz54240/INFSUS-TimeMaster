import React from "react";
import { render, screen } from "@testing-library/react";
import Login from "../apps/authorisation/login";

test("renders login form", () => {
  render(<Login />);

  expect(screen.getByLabelText(/Email/i)).toBeInTheDocument();
  expect(screen.getByLabelText(/Password/i)).toBeInTheDocument();
  expect(screen.getByRole("button", { name: /Log in/i })).toBeInTheDocument();
  expect(screen.getByText(/Don't have an account?/i)).toBeInTheDocument();
  expect(screen.getByText(/Register/i)).toBeInTheDocument();
});
