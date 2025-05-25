import React, { useEffect, useState, useContext } from "react";
import { Button, Card, Space, Modal, Form, Spin, Row, Col } from "antd";
import apiRequest from "../authorisation/api";
import { AuthContext } from "../authorisation/AuthContext";
import WorkLogFormModal from "./insertTimeModal";
import ProjectsBarChart from "./projectsBarChart";
import WeeklyHoursChart from "./weeklyHoursChart";
import WorkLogTable from "./workLogTable";

const timeReport = () => {
  const { user } = useContext(AuthContext);
  const isOwner = user.attributes.role === "owner";
  const [modalCreateVisible, setModalCreateVisible] = useState(false);

  const [loading, setLoading] = useState(true);
  const [projects, setProjects] = useState([]);

  const fetchProjects = async () => {
    try {
      const resp = await apiRequest("/projects", "GET");
      setProjects(resp.data);
    } catch (error) {
      console.log(error);
      setProjects([]);
    }
  };

  const refreshData = async () => {
    setLoading(true);
    try {
      await Promise.all([fetchProjects()]);
    } catch (error) {
      console.log(error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    refreshData();
  }, []);

  const handleCreateTimeEntry = async (payload) => {
    console.log(payload);
    try {
      await apiRequest("/work_logs", "POST", { data: payload });
      setModalCreateVisible(false);
      refreshData();
    } catch (error) {
      message.error("Failed to insert time entry");
    }
  };

  return (
    <>
      <div className="page-header">
        <h2>Time report</h2>
        {!isOwner && (
          <Button type="primary" onClick={() => setModalCreateVisible(true)}>
            Insert time
          </Button>
        )}
      </div>
      <Spin spinning={loading}>
        <Row gutter={[16, 16]}>
          <Col xs={24} lg={12}>
            <ProjectsBarChart projects={projects} />
          </Col>
          <Col xs={24} lg={12}>
            <WeeklyHoursChart projects={projects} />
          </Col>
        </Row>
        <Row style={{ margin: 0 }}>
          <Col span={24}>
            <WorkLogTable projects={projects} onDataChange={refreshData} />
          </Col>
        </Row>
      </Spin>

      <WorkLogFormModal
        visible={modalCreateVisible}
        onCancel={() => setModalCreateVisible(false)}
        onSubmit={handleCreateTimeEntry}
        projects={projects}
        mode="create"
      />
    </>
  );
};

export default timeReport;
