import React from "react";
import { NavLink } from "react-router-dom";
import "./navigation.css";

const Navigation = () => {
  return (
    <div className="navigation">
      <NavLink
        exact="true"
        to="/timeReport"
        className={({ isActive }) =>
          `nav-link ${isActive ? "active-link" : ""}`
        }
      >
        Time report
      </NavLink>

      <NavLink
        exact="true"
        to="/organizations"
        className={({ isActive }) =>
          `nav-link ${isActive ? "active-link" : ""}`
        }
      >
        Organizations
      </NavLink>
      <NavLink
        exact="true"
        to="/projects"
        className={({ isActive }) =>
          `nav-link ${isActive ? "active-link" : ""}`
        }
      >
        Projects
      </NavLink>
      <NavLink
        exact="true"
        to="/profile"
        className={({ isActive }) =>
          `nav-link ${isActive ? "active-link" : ""}`
        }
      >
        Profile
      </NavLink>
    </div>
  );
};

export default Navigation;
