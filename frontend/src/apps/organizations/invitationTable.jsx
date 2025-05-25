import React, { useEffect, useState } from "react";
import { Table, Button, Space } from "antd";
import apiRequest from "../authorisation/api";

const InvitationTable = ({ organizationId }) => {
  const [loading, setLoading] = useState(true);
  const [invitations, setInvitations] = useState([]);

  const fetchInvitations = async () => {
    setLoading(true);
    try {
      const resp = await apiRequest(
        "/invitations?organization_id=" + organizationId,
        "GET"
      );
      const parsed = resp.data.map((item) => ({
        id: item.id,
        ...item.attributes,
      }));

      setInvitations(parsed);
    } catch (err) {
      setInvitations([]);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateInv = async () => {
    try {
      console.log(organizationId);
      const resp = await apiRequest("/invitations", "POST", {
        data: { organization_id: organizationId },
      });
      fetchInvitations();
    } catch (err) {
      console.log(err);
    }
  };

  useEffect(() => {
    fetchInvitations();
  }, [organizationId]);

  const columns = [
    {
      title: "Token",
      dataIndex: "token",
      key: "token",
    },
    {
      title: "Created At",
      dataIndex: "created_at",
      key: "created_at",
      render: (date) => new Date(date).toLocaleString(),
    },
  ];

  return (
    <div style={{ paddingTop: 12 }}>
      <Space
        style={{ marginBottom: 12, display: "flex", justifyContent: "end" }}
      >
        <Button onClick={handleCreateInv} loading={loading}>
          Create invitations
        </Button>
      </Space>

      <Table
        rowKey="id"
        columns={columns}
        dataSource={invitations}
        loading={loading}
        size="small"
        pagination={{ pageSize: 8 }}
      />
    </div>
  );
};

export default InvitationTable;
