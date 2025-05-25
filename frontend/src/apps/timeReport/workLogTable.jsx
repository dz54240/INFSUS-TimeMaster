import React, { useEffect, useState } from "react";
import { Table, Button, Modal, message } from "antd";
import apiRequest from "../authorisation/api";
import WorkLogFormModal from "./insertTimeModal";

const PAGE_SIZE = 10;

const WorkLogsTable = ({ projects, onDataChange }) => {
  const [workLogs, setWorkLogs] = useState([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(false);
  const [page, setPage] = useState(1);
  const [editModalVisible, setEditModalVisible] = useState(false);
  const [editRecord, setEditRecord] = useState(null);

  const fetchWorkLogInfo = async () => {
    try {
      const resp = await apiRequest("/work_logs/info", "GET");
      setTotalCount(resp.data.total_count);
    } catch (error) {
      message.error("Failed to load work logs info");
    }
  };

  const fetchWorkLogs = async (pageNum = 1) => {
    setLoading(true);
    try {
      const skip = (pageNum - 1) * PAGE_SIZE;
      const resp = await apiRequest(
        `/work_logs?skip=${skip}&limit=${PAGE_SIZE}`,
        "GET"
      );
      setWorkLogs(resp.data);
      setPage(pageNum);
    } catch (error) {
      message.error("Failed to load work logs");
      setWorkLogs([]);
    } finally {
      setLoading(false);
    }
  };

  const enrichedWorkLogs = workLogs.map((log) => {
    const projectId = log.relationships?.project?.data?.id;
    const project = projects.find((p) => p.id === projectId);
    return {
      ...log,
      projectName: project?.attributes?.name || "N/A",
    };
  });

  useEffect(() => {
    fetchWorkLogInfo();
    fetchWorkLogs();
  }, [projects]);

  const handleEditSubmit = async (updatedData) => {
    try {
      await apiRequest(`/work_logs/${editRecord.id}`, "PUT", {
        data: updatedData,
      });
      message.success("Updated successfully");
      setEditModalVisible(false);
      fetchWorkLogs(page);
      fetchWorkLogInfo();
      onDataChange();
    } catch (err) {
      message.error("Update failed");
    }
  };

  const handleDelete = async (id) => {
    try {
      await apiRequest(`/work_logs/${id}`, "DELETE");
      fetchWorkLogs(page);
      fetchWorkLogInfo();
      onDataChange();
    } catch (error) {
      console.log(error);
    }
  };

  const handleEdit = (record) => {
    setEditRecord(record);
    setEditModalVisible(true);
  };

  const handlePageChange = (pageNum) => {
    fetchWorkLogs(pageNum);
  };

  const columns = [
    {
      title: "Activity Type",
      dataIndex: ["attributes", "activity_type"],
      key: "activity_type",
    },
    {
      title: "Hours",
      key: "hours",
      render: (_, record) => {
        const start = new Date(record.attributes.start_time);
        const end = new Date(record.attributes.end_time);
        const diffHours = (end - start) / (1000 * 60 * 60);
        return diffHours.toFixed(2);
      },
    },
    {
      title: "Start Time",
      dataIndex: ["attributes", "start_time"],
      key: "start_time",
      render: (text) => new Date(text).toLocaleString(),
    },
    {
      title: "End Time",
      dataIndex: ["attributes", "end_time"],
      key: "end_time",
      render: (text) => new Date(text).toLocaleString(),
    },

    {
      title: "Description",
      dataIndex: ["attributes", "description"],
      key: "description",
    },
    {
      title: "Project Name",
      dataIndex: "projectName",
      key: "projectName",
    },
    {
      title: "Actions",
      key: "actions",
      render: (_, record) => (
        <span>
          <Button
            type="link"
            onClick={() => handleEdit(record)}
            style={{ marginRight: 8 }}
          >
            Edit
          </Button>
          <Button type="link" danger onClick={() => handleDelete(record.id)}>
            Delete
          </Button>
        </span>
      ),
    },
  ];

  return (
    <div>
      <Table
        dataSource={enrichedWorkLogs}
        columns={columns}
        rowKey="id"
        loading={loading}
        pagination={{
          current: page,
          pageSize: PAGE_SIZE,
          total: totalCount,
          onChange: handlePageChange,
        }}
      />

      <WorkLogFormModal
        visible={editModalVisible}
        onCancel={() => setEditModalVisible(false)}
        onSubmit={handleEditSubmit}
        projects={projects}
        initialValues={editRecord}
        mode="edit"
      />
    </div>
  );
};

export default WorkLogsTable;
