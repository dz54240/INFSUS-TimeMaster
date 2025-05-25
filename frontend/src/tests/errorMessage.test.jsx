import { render, screen } from "@testing-library/react";
import ErrorMessage from "../components/errorMessage";
import "@testing-library/jest-dom";

describe("ErrorMessage", () => {
  test("does not render when error is falsy", () => {
    const { container } = render(<ErrorMessage error={null} />);
    expect(container).toBeEmptyDOMElement();
  });

  test("renders single string error", () => {
    render(<ErrorMessage error="Something went wrong" />);
    expect(screen.getByText("Something went wrong")).toBeInTheDocument();
  });

  test("renders array of errors joined by &", () => {
    render(<ErrorMessage error={["Error1", "Error2"]} />);
    expect(screen.getByText("Error1 & Error2")).toBeInTheDocument();
  });

  test("renders object error as JSON string", () => {
    const errorObj = { message: "Failed", code: 500 };
    render(<ErrorMessage error={errorObj} />);
    expect(screen.getByText(JSON.stringify(errorObj))).toBeInTheDocument();
  });
});
