import React, { useContext } from "react";
import { Link } from "react-router-dom";
import { UserOutlined, LogoutOutlined } from "@ant-design/icons";
import { Layout, Button, Avatar, Typography } from "antd";
const { Title } = Typography;
import { AuthContext } from "../apps/authorisation/AuthContext";
const { Header } = Layout;

const MyHeader = () => {
  const { logout, user } = useContext(AuthContext);

  return (
    <Header
      style={{
        display: "flex",
        justifyContent: "space-between",
        alignItems: "center",
        background: "#002b44",
        padding: "0 24px",
      }}
    >
      <Link to="/dashboard">
        <Title level={3} style={{ color: "#fff", margin: 0 }}>
          TimeMaster
        </Title>
      </Link>
      <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
        <Link to="/profile">
          {(user.attributes.role === "owner" ? "Owner: " : "Employee: ") +
            " " +
            user.attributes.first_name}
          <Avatar icon={<UserOutlined />} style={{ cursor: "pointer" }} />
        </Link>
        <Button icon={<LogoutOutlined />} onClick={logout}>
          Logout
        </Button>
      </div>
    </Header>
  );
};
export default MyHeader;
