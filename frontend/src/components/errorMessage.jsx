import React from "react";
const ErrorMessage = ({ error }) => {
  if (!error) return null;

  const errors = Array.isArray(error)
    ? error
    : typeof error === "string"
    ? [error]
    : [JSON.stringify(error)];

  return (
    <div
      style={{
        color: "red",
        minHeight: "24px",
        textAlign: "center",
        marginTop: "8px",
      }}
    >
      {errors.join(" & ")}
    </div>
  );
};

export default ErrorMessage;
