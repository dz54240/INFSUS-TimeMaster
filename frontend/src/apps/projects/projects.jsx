import React, { useEffect, useState, useContext } from "react";
import { Button, Card, Space, Modal, Select, Spin, message } from "antd";
import apiRequest from "../authorisation/api";
import { AuthContext } from "../authorisation/AuthContext";
import CreateProjectModal from "./createProjectModal";
import ProjectCard from "./projectCard";

const { Option } = Select;
const Projects = () => {
  const { user } = useContext(AuthContext);
  const [organizations, setOrganizations] = useState([]);
  const isOwner = user.attributes.role === "owner";
  const [selectedOrgId, setSelectedOrgId] = useState("-1");
  const [isModalVisible, setModalVisible] = useState(false);
  const [loading, setLoading] = useState(true);
  const [projects, setProjects] = useState([]);

  const filteredProjects =
    selectedOrgId === "-1"
      ? projects
      : projects.filter(
          (p) => p.attributes.organization_id === parseInt(selectedOrgId, 10)
        );

  const fetchOrgs = async () => {
    setLoading(true);
    try {
      const resp = await apiRequest("/organizations", "GET");
      setOrganizations(resp.data);
    } catch (err) {
      setOrganizations([]);
    } finally {
      setLoading(false);
    }
  };

  const handleCreate = async (payload) => {
    try {
      const resp = await apiRequest("/projects", "POST", {
        data: payload,
      });
      fetchProjects();
      setModalVisible(false);
    } catch (err) {
      console.log(err);
    }
  };

  const fetchProjects = async () => {
    setLoading(true);
    try {
      const resp = await apiRequest("/projects", "GET");
      setProjects(resp.data);
    } catch (err) {
      setProjects([]);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (projectId) => {
    try {
      await apiRequest(`/projects/${projectId}`, "DELETE");
      message.success("Project deleted");
      fetchProjects();
    } catch (error) {
      message.error("Failed to delete project");
    }
  };

  useEffect(() => {
    fetchProjects();
    fetchOrgs();
  }, []);

  return (
    <div>
      <div className="page-header">
        <h2>Your projects</h2>
        {isOwner && (
          <Button type="primary" onClick={() => setModalVisible(true)}>
            Create project
          </Button>
        )}
      </div>
      <Spin spinning={loading}>
        <Select
          value={selectedOrgId}
          onChange={(value) => setSelectedOrgId(value)}
          style={{ width: 200 }}
        >
          <Option value="-1">All Organizations</Option>
          {organizations.map((org) => (
            <Option key={org.id} value={org.id}>
              {org.attributes.name}
            </Option>
          ))}
        </Select>
        {filteredProjects.length === 0 ? (
          <p>No projects to display.</p>
        ) : (
          filteredProjects.map((p) => {
            const orgName =
              organizations.find(
                (org) => parseInt(org.id) === p.attributes.organization_id
              )?.attributes.name || "-";
            return (
              <ProjectCard
                key={p.id}
                project={p}
                orgName={orgName}
                handleDelete={handleDelete}
                isOwner={isOwner}
              />
            );
          })
        )}
      </Spin>
      <CreateProjectModal
        open={isModalVisible}
        onCancel={() => setModalVisible(false)}
        onCreate={handleCreate}
        organizations={organizations}
      />
    </div>
  );
};

export default Projects;
