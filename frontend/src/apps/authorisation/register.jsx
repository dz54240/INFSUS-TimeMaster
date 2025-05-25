import React, { useState } from "react";
import { Form, Input, Button, Card, Typography, Select, message } from "antd";
import { Link, useNavigate } from "react-router-dom";
import { apiRequest } from "./api";
import ErrorMessage from "../../components/errorMessage";

const { Title } = Typography;
const { Option } = Select;

const Register = () => {
  const [error, setError] = useState("");
  const navigate = useNavigate();
  const onFinish = async (values) => {
    try {
      const response = await apiRequest("/users/", "POST", { data: values });
      navigate("/login");
    } catch (err) {
      setError(err?.data?.errors || "Error connecting to backend.");
    }
  };

  return (
    <div className="autorisation">
      {" "}
      <Card className="auth-card">
        <Title level={2} style={{ textAlign: "center" }}>
          Register
        </Title>
        <Form name="register_form" layout="vertical" onFinish={onFinish}>
          <Form.Item
            name="email"
            label="Email"
            rules={[
              { required: true, message: "Please enter your email!" },
              { type: "email", message: "Invalid email format!" },
            ]}
          >
            <Input placeholder="Email" />
          </Form.Item>

          <Form.Item
            name="password"
            label="Password"
            rules={[{ required: true, message: "Please enter your password!" }]}
          >
            <Input.Password placeholder="Password" />
          </Form.Item>

          <Form.Item name="first_name" label="First name">
            <Input placeholder="First name" />
          </Form.Item>

          <Form.Item name="last_name" label="Last name">
            <Input placeholder="Last name" />
          </Form.Item>

          <Form.Item
            name="role"
            label="Role"
            rules={[{ required: true, message: "Please select your role!" }]}
          >
            <Select placeholder="Select role">
              <Option value="owner">Owner</Option>
              <Option value="employee">Employee</Option>
            </Select>
          </Form.Item>

          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              Register
            </Button>
          </Form.Item>
          <ErrorMessage error={error} />
          <div style={{ textAlign: "center" }}>
            Already have an account? <Link to="/">Login</Link>
          </div>
        </Form>
      </Card>
    </div>
  );
};

export default Register;
