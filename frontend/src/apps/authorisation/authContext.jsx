import React, { createContext, useState, useEffect } from "react";

export const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);

  useEffect(() => {
    const authTokens = sessionStorage.getItem("authTokens");
    if (authTokens) {
      const parsed = JSON.parse(authTokens);
      setUser(parsed.user);
    }
  }, []);

  const login = (data) => {
    sessionStorage.setItem("authTokens", JSON.stringify(data));
    setUser(data.user);
  };

  const logout = () => {
    sessionStorage.removeItem("authTokens");
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}
