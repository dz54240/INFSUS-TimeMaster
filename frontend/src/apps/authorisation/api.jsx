const BASE_URL = "http://localhost:3000/api";

export const apiRequest = (path, method, body = null) => {
  return new Promise((resolve, reject) => {
    let authTokens = null;
    try {
      const storedTokens = sessionStorage.getItem("authTokens");
      if (storedTokens) {
        authTokens = JSON.parse(storedTokens);
      }
    } catch (e) {
      console.warn("Failed to parse authTokens from sessionStorage: ", e);
    }

    const headers = {
      "Content-Type": "application/json",
    };
    if (authTokens?.token) {
      headers["Authorization"] = "Bearer " + authTokens.token;
    }

    fetch(`${BASE_URL}${path}`, {
      method,
      headers,
      body: body ? JSON.stringify(body) : null,
    })
      .then(async (response) => {
        const isNoContent = response.status === 204;
        const data = isNoContent ? null : await response.json();
        if (response.ok) {
          resolve(data);
        } else {
          reject({
            status: response.status,
            statusText: response.statusText,
            data,
          });
        }
      })
      .catch((error) => {
        reject({ message: error.message });
      });
  });
};

export default apiRequest;
