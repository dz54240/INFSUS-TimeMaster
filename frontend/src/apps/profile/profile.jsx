import React, { useEffect, useState, useContext } from "react";
import { AuthContext } from "../authorisation/AuthContext";
import apiRequest from "../authorisation/api";
import { Card, Descriptions, Spin } from "antd";

const Profile = () => {
  const { user } = useContext(AuthContext);
  const [loading, setLoading] = useState(true);
  const [userData, setUserData] = useState(null);

  const fetchData = async () => {
    setLoading(true);
    try {
      const resp = await apiRequest("/users/" + user.id, "GET");
      setUserData(resp.data);
    } catch (err) {
      setUserData({});
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <div className="profile">
      <div className="page-header">
        <h2>User Profile</h2>
      </div>
      <Spin spinning={loading}>
        {userData && (
          <Card>
            <Descriptions bordered column={1}>
              <Descriptions.Item label="Email">
                {userData.attributes.email}
              </Descriptions.Item>
              <Descriptions.Item label="First Name">
                {userData.attributes.first_name}
              </Descriptions.Item>
              <Descriptions.Item label="Last Name">
                {userData.attributes.last_name}
              </Descriptions.Item>
              <Descriptions.Item label="Role">
                {userData.attributes.role}
              </Descriptions.Item>
              <Descriptions.Item label="Hourly Rate">
                {userData.attributes.hourly_rate !== null
                  ? `${userData.attributes.hourly_rate} €/h`
                  : "N/A"}
              </Descriptions.Item>
              <Descriptions.Item label="Created At">
                {new Date(userData.attributes.created_at).toLocaleString()}
              </Descriptions.Item>
            </Descriptions>
          </Card>
        )}
      </Spin>
    </div>
  );
};

export default Profile;
