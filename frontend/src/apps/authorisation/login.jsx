import React, { useState, useContext } from "react";
import { Form, Input, Button, Card, Typography } from "antd";
const { Title } = Typography;
import { Link } from "react-router-dom";
import { UserOutlined, LockOutlined } from "@ant-design/icons";
import { apiRequest } from "./api";
import { AuthContext } from "../authorisation/AuthContext";
import ErrorMessage from "../../components/errorMessage";

const Login = () => {
  const [error, setError] = useState("");
  const { login } = useContext(AuthContext);

  const onFinish = async (values) => {
    try {
      const response = await apiRequest("/sessions", "POST", { data: values });
      login(response.data);
    } catch (err) {
      setError(err?.data?.errors || "Error connecting to backend.");
    }
  };

  return (
    <div className="autorisation">
      <Card className="auth-card">
        <Title level={2} style={{ textAlign: "center" }}>
          Login
        </Title>
        <Form
          name="login_form"
          initialValues={{ remember: true }}
          onFinish={onFinish}
          layout="vertical"
        >
          <Form.Item
            name="email"
            label="Email"
            rules={[
              { required: true, message: "Please enter your email!" },
              { type: "email", message: "Invalid email format!" },
            ]}
          >
            <Input prefix={<UserOutlined />} placeholder="Email" />
          </Form.Item>

          <Form.Item
            name="password"
            label="Password"
            rules={[{ required: true, message: "Please enter your password!" }]}
          >
            <Input.Password prefix={<LockOutlined />} placeholder="Password" />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              Login
            </Button>
          </Form.Item>
        </Form>
        <ErrorMessage error={error} />
        <div style={{ textAlign: "center" }}>
          <span>Don't have an account? </span>
          <Link to="/register">Register</Link>
        </div>
      </Card>
    </div>
  );
};

export default Login;
