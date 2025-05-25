import React from "react";
import { Link } from "react-router-dom";

const NoPageFound = () => {
  return (
    <div
      style={{
        height: "82vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        textAlign: "center",
        padding: "20px",
      }}
    >
      <h1 style={{ fontSize: "72px", marginBottom: "16px" }}>404</h1>
      <p style={{ fontSize: "18px", marginBottom: "24px" }}>
        Sorry, the page you’re looking for doesn’t exist.
      </p>
      <Link
        to="/dashboard"
        style={{
          textDecoration: "none",
          color: "#1890ff",
          fontWeight: "500",
        }}
      >
        Back to Dashboard
      </Link>
    </div>
  );
};

export default NoPageFound;
