import React, { useEffect, useState, useContext } from "react";
import { Table, Button, Space, Tag, InputNumber } from "antd";
import apiRequest from "../authorisation/api";
import {
  EditOutlined,
  DeleteOutlined,
  CheckOutlined,
  CloseOutlined,
} from "@ant-design/icons";
import { AuthContext } from "../authorisation/AuthContext";

const EmployeeTable = ({ organizationId, isOwner }) => {
  const [editingId, setEditingId] = useState(null);
  const [editedRate, setEditedRate] = useState(null);
  const [loading, setLoading] = useState(true);
  const [employees, setEmployees] = useState([]);

  const handleEdit = (id, currentRate) => {
    setEditingId(id);
    setEditedRate(currentRate);
    setEditedRate(currentRate);
  };
  const handleSave = async (userId) => {
    try {
      await apiRequest(`/users/${userId}`, "PATCH", {
        data: { hourly_rate: editedRate },
      });
      setEditingId(null);
      setEditedRate(null);
      fetchEmployees();
    } catch (error) {
      console.error(error);
    }
  };

  const handleDelete = async (id) => {
    try {
      await apiRequest(`/employments/${id}`, "DELETE");
      fetchEmployees();
    } catch (error) {
      console.error(error);
    }
  };

  const fetchEmployees = async () => {
    setLoading(true);

    try {
      if (isOwner) {
        const response = await apiRequest(
          `/employments/?organization_id=` + organizationId,
          "GET"
        );

        const includedUsers = Object.fromEntries(
          response.included.map((user) => [user.id, user.attributes])
        );

        const tableData = response.data.map((employment) => {
          const userId = employment.relationships.user.data.id;
          const user = includedUsers[userId];

          return {
            id: employment.id,
            userId: userId,
            ...user,
            employment_created_at: employment.attributes.created_at,
          };
        });
        setEmployees(tableData);
      } else {
        const resp = await apiRequest(
          `/users/?organization_id=` + organizationId,
          "GET"
        );
        const flattened = resp.data.map((u) => ({
          id: u.id,
          ...u.attributes,
        }));
        setEmployees(flattened);
      }
    } catch (err) {
      setEmployees([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchEmployees();
  }, [organizationId]);

  const baseColumns = [
    {
      title: "First name",
      dataIndex: "first_name",
      key: "first_name",
    },
    {
      title: "Last name",
      dataIndex: "last_name",
      key: "last_name",
    },
    {
      title: "Email",
      dataIndex: "email",
      key: "email",
    },
    {
      title: "Role",
      dataIndex: "role",
      key: "role",
      render: (role) =>
        role === "owner" ? <Tag color="gold">Owner</Tag> : <Tag>Employee</Tag>,
    },
  ];

  const ownerColumns = [
    {
      title: "Hourly rate",
      dataIndex: "hourly_rate",
      key: "hourly_rate",
      render: (rate, record) => {
        if (editingId === record.id) {
          return (
            <InputNumber
              min={0}
              defaultValue={rate}
              onChange={(value) => {
                setEditedRate(value);
              }}
              formatter={(value) => `${value} €/h`}
              parser={(value) => value.replace(" €/h", "")}
              style={{ width: 100 }}
              autoFocus
            />
          );
        }
        return rate ? `${rate} €/h` : "-";
      },
    },
    {
      title: "Employment created",
      dataIndex: "employment_created_at",
      key: "employment_created_at",
      render: (date) => new Date(date).toLocaleString(),
    },
    {
      title: "Actions",
      key: "actions",
      render: (_, record) => (
        <Space size="middle">
          {editingId === record.id ? (
            <>
              <Button
                type="text"
                icon={<CheckOutlined style={{ color: "green" }} />}
                onClick={() => handleSave(record.userId)}
              />
              <Button
                type="text"
                icon={<CloseOutlined style={{ color: "red" }} />}
                onClick={() => setEditingId(null)}
              />
            </>
          ) : (
            <>
              <Button
                type="text"
                icon={<EditOutlined />}
                onClick={() => handleEdit(record.id, record.hourly_rate)}
              />
              <Button
                type="text"
                danger
                icon={<DeleteOutlined />}
                onClick={() => handleDelete(record.id)}
              />
            </>
          )}
        </Space>
      ),
    },
  ];
  const columns = isOwner ? [...baseColumns, ...ownerColumns] : baseColumns;
  return (
    <Table
      rowKey="id"
      columns={columns}
      dataSource={employees}
      loading={loading}
      size="small"
      pagination={{ pageSize: 8 }}
    />
  );
};

export default EmployeeTable;
