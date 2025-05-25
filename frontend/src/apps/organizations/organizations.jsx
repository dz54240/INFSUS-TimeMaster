import React, { useEffect, useState, useContext } from "react";
import { Button, Card, Space, Modal, Form, Spin } from "antd";
import apiRequest from "../authorisation/api";
import { AuthContext } from "../authorisation/AuthContext";
import OrganizationForm from "./organizationForm";
import InvitationTable from "./invitationTable";
import EmployeeTable from "./employerTable";

const Organizations = () => {
  const { user } = useContext(AuthContext);
  const [organizations, setOrganizations] = useState([]);
  const [modalCreateVisible, setModalCreateVisible] = useState(false);
  const [isEmployerModalOpen, setIsEmployerModalOpen] = useState(false);
  const [loading, setLoading] = useState(true);

  const [isInvitationsModalVisible, setIsInvitationsModalVisible] =
    useState(false);
  const [selectedOrgId, setSelectedOrgId] = useState(null);

  const [form] = Form.useForm();

  const isOwner = user.attributes.role === "owner";

  const openInvitationsModal = (orgId) => {
    setSelectedOrgId(orgId);
    setIsInvitationsModalVisible(true);
  };

  const openEmployerModal = (orgId) => {
    setSelectedOrgId(orgId);
    setIsEmployerModalOpen(true);
  };

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

  useEffect(() => {
    fetchOrgs();
  }, []);

  const handleDelete = async (orgId) => {
    try {
      const response = await apiRequest("/organizations/" + orgId, "DELETE");
      fetchOrgs();
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <div>
      <div className="page-header">
        <h2>Your Organizations</h2>
        <Button type="primary" onClick={() => setModalCreateVisible(true)}>
          {isOwner ? "Create Organization" : "Join Organization"}
        </Button>
      </div>
      <Spin spinning={loading}>
        <Space direction="vertical" size="middle" style={{ width: "100%" }}>
          {organizations.length === 0 ? (
            <p>You are not part of any organizations.</p>
          ) : (
            organizations.map((org) => (
              <Card
                key={org.id}
                title={org.attributes.name}
                extra={<span>ID: {org.id}</span>}
              >
                <p>{org.attributes.description}</p>
                <Space>
                  <Button
                    type="primary"
                    style={{ backgroundColor: "green", borderColor: "green" }}
                    onClick={() => openEmployerModal(org.id)}
                  >
                    Employees
                  </Button>
                  {isOwner && (
                    <>
                      <Button
                        type="primary"
                        danger
                        onClick={() => handleDelete(org.id)}
                      >
                        Delete
                      </Button>
                      <Button
                        type="primary"
                        onClick={() => openInvitationsModal(org.id)}
                      >
                        Invitations
                      </Button>
                    </>
                  )}
                </Space>
              </Card>
            ))
          )}
        </Space>
      </Spin>
      <Modal
        title="Employees"
        open={isEmployerModalOpen}
        onCancel={() => setIsEmployerModalOpen(false)}
        footer={null}
        width={800}
      >
        <EmployeeTable organizationId={selectedOrgId} isOwner={isOwner} />
      </Modal>

      <Modal
        title={isOwner ? "Create Organization" : "Join Organization"}
        open={modalCreateVisible}
        onCancel={() => setModalCreateVisible(false)}
        footer={null}
        destroyOnHidden
      >
        <OrganizationForm
          isOwner={isOwner}
          form={form}
          setModalCreateVisible={setModalCreateVisible}
          fetchOrgs={fetchOrgs}
        />
      </Modal>

      <Modal
        title={"Invitations"}
        open={isInvitationsModalVisible}
        onCancel={() => setIsInvitationsModalVisible(false)}
        footer={null}
        destroyOnHidden
      >
        <InvitationTable organizationId={selectedOrgId} />
      </Modal>
    </div>
  );
};

export default Organizations;
