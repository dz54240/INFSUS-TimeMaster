import React, { useEffect } from "react";
import {
  Modal,
  Form,
  Select,
  Input,
  DatePicker,
  TimePicker,
  message,
} from "antd";
import dayjs from "dayjs";

const { Option } = Select;

const WorkLogFormModal = ({
  visible,
  onCancel,
  onSubmit,
  projects = [],
  initialValues = null,
  mode = "create",
}) => {
  const [form] = Form.useForm();

  useEffect(() => {
    if (initialValues) {
      const start = dayjs(initialValues.attributes.start_time);
      const end = dayjs(initialValues.attributes.end_time);
      form.setFieldsValue({
        date: start,
        timeRange: [start, end],
        activity_type: initialValues.attributes.activity_type,
        description: initialValues.attributes.description,
        project_id: initialValues.relationships?.project?.data?.id,
      });
    } else {
      form.resetFields();
    }
  }, [initialValues, form]);

  const handleOk = () => {
    form.submit();
  };

  const handleFinish = (values) => {
    const { date, timeRange } = values;
    if (!date || !timeRange) {
      message.error("Please select date and time range");
      return;
    }

    const startDateTime = date
      .hour(timeRange[0].hour())
      .minute(timeRange[0].minute())
      .second(0);

    const endDateTime = date
      .hour(timeRange[1].hour())
      .minute(timeRange[1].minute())
      .second(0);

    const payload = {
      start_time: startDateTime.toISOString(),
      end_time: endDateTime.toISOString(),
      activity_type: values.activity_type,
      description: values.description,
      project_id: values.project_id,
    };

    onSubmit(payload);
    form.resetFields();
  };

  return (
    <Modal
      title={mode === "edit" ? "Edit Work Log" : "Insert Time Entry"}
      open={visible}
      onOk={handleOk}
      onCancel={() => {
        form.resetFields();
        onCancel();
      }}
      okText={mode === "edit" ? "Save" : "Insert"}
    >
      <Form
        form={form}
        layout="vertical"
        name="work_log_form"
        onFinish={handleFinish}
      >
        <Form.Item
          name="date"
          label="Date"
          rules={[{ required: true, message: "Please select a date" }]}
        >
          <DatePicker
            style={{ width: "100%" }}
            disabledDate={(current) =>
              current && current > dayjs().endOf("day")
            }
          />
        </Form.Item>

        <Form.Item
          name="timeRange"
          label="Time Range"
          rules={[{ required: true, message: "Please select time range" }]}
        >
          <TimePicker.RangePicker format="HH:mm" style={{ width: "100%" }} />
        </Form.Item>

        <Form.Item
          name="activity_type"
          label="Activity Type"
          rules={[
            { required: true, message: "Please select an activity type" },
          ]}
        >
          <Select placeholder="Select activity type">
            <Option value="on_site">On site</Option>
            <Option value="remote_work">Remote Work</Option>
          </Select>
        </Form.Item>

        <Form.Item name="description" label="Description">
          <Input.TextArea rows={3} />
        </Form.Item>
        {mode === "create" && (
          <Form.Item
            name="project_id"
            label="Project"
            rules={[{ required: true, message: "Please select a project" }]}
          >
            <Select placeholder="Select project">
              {projects.map((proj) => (
                <Option key={proj.id} value={proj.id}>
                  {proj.attributes.name}
                </Option>
              ))}
            </Select>
          </Form.Item>
        )}
      </Form>
    </Modal>
  );
};

export default WorkLogFormModal;
