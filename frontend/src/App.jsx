import { useContext } from "react";
import Home from "./apps/home/home";
import { AuthProvider, AuthContext } from "./apps/authorisation/AuthContext";
import Profile from "./apps/profile/profile";
import Organizations from "./apps/organizations/organizations";
import Projects from "./apps/projects/projects";
import TimeReport from "./apps/timeReport/timeReport";
import NoPageFound from "./components/noPageFound";
import Login from "./apps/authorisation/login";
import Register from "./apps/authorisation/register";

import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";

function App() {
  return (
    <AuthProvider>
      <Router>
        <AppRoutes />
      </Router>
    </AuthProvider>
  );
}

function AppRoutes() {
  const { user } = useContext(AuthContext);
  return (
    <Routes>
      {user ? (
        <>
          <Route path="/" element={<Navigate to="/timeReport" />} />
          <Route path="/login" element={<Navigate to="/timeReport" />} />
          <Route
            path="/organizations"
            element={<Home Page={Organizations} />}
          />
          <Route path="/projects" element={<Home Page={Projects} />} />
          <Route path="/timeReport" element={<Home Page={TimeReport} />} />
          <Route path="/profile" element={<Home Page={Profile} />} />
          <Route path="/*" element={<Home Page={NoPageFound} />} />
        </>
      ) : (
        <>
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/*" element={<Navigate to="/login" />} />
        </>
      )}
    </Routes>
  );
}

export default App;
