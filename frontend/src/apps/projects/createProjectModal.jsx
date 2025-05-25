import React from "react";
import { Modal, Form, Input, DatePicker, InputNumber, Select } from "antd";

const CreateProjectModal = ({ open, onCancel, onCreate, organizations }) => {
  const [form] = Form.useForm();

  const handleOk = () => {
    form.submit();
  };

  const onFinish = (values) => {
    console.log("Form data:", values);
    onCreate(values);
    form.resetFields();
  };

  return (
    <Modal
      title="Create Project"
      open={open}
      onOk={handleOk}
      onCancel={() => {
        form.resetFields();
        onCancel();
      }}
      okText="Create"
    >
      <Form form={form} layout="vertical" onFinish={onFinish}>
        <Form.Item name="name" label="Name" rules={[{ required: true }]}>
          <Input />
        </Form.Item>

        <Form.Item name="description" label="Description">
          <Input.TextArea rows={3} />
        </Form.Item>

        <Form.Item name="dates" label="Start & End Date">
          <DatePicker.RangePicker />
        </Form.Item>

        <Form.Item name="budget_amount" label="Budget Amount">
          <InputNumber style={{ width: "100%" }} min={0} addonAfter="€" />
        </Form.Item>

        <Form.Item
          name="organization_id"
          label="Organization"
          rules={[{ required: true, message: "Please select an organization" }]}
        >
          <Select placeholder="Select organization">
            {organizations.map((org) => (
              <Option key={org.id} value={org.id}>
                {org.attributes.name}
              </Option>
            ))}
          </Select>
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default CreateProjectModal;
