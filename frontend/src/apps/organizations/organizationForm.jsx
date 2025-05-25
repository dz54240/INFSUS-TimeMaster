import React, { useEffect, useState, useContext } from "react";
import { Form, Input, DatePicker, Button } from "antd";
import dayjs from "dayjs";
import ErrorMessage from "../../components/errorMessage";
import apiRequest from "../authorisation/api";

const OrganizationForm = ({
  isOwner,
  form,
  setModalCreateVisible,
  fetchOrgs,
}) => {
  const [error, setError] = useState("");

  const onFinish = async (values) => {
    try {
      if (isOwner) {
        const response = await apiRequest("/organizations", "POST", {
          data: values,
        });
      } else {
        const response = await apiRequest("/employments", "POST", {
          data: values,
        });
      }
      setModalCreateVisible(false);
      form.resetFields();
      fetchOrgs();
    } catch (err) {
      setError(err?.data?.errors || "Error connecting to backend.");
    }
  };

  return (
    <Form form={form} layout="vertical" onFinish={onFinish}>
      {isOwner ? (
        <>
          <Form.Item
            name="name"
            label="Organization Name"
            rules={[{ required: true, message: "Please enter a name" }]}
          >
            <Input />
          </Form.Item>
          <Form.Item name="description" label="Description">
            <Input.TextArea rows={3} />
          </Form.Item>
          <Form.Item name="established_at" label="Established at:">
            <DatePicker
              format="YYYY-MM-DD"
              disabledDate={(current) =>
                current && current > dayjs().endOf("day")
              }
              style={{ width: "100%" }}
            />
          </Form.Item>
        </>
      ) : (
        <Form.Item
          name="organization_token"
          label="Organization token"
          rules={[{ required: true, message: "Please enter the token" }]}
        >
          <Input />
        </Form.Item>
      )}
      <Form.Item>
        <Button type="primary" htmlType="submit" block>
          {isOwner ? "Create" : "Join"}
        </Button>
      </Form.Item>
      <ErrorMessage error={error} />
    </Form>
  );
};

export default OrganizationForm;
