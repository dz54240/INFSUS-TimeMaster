import React, { useState, useEffect } from "react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  CartesianGrid,
  ResponsiveContainer,
} from "recharts";
import { Select } from "antd";
import apiRequest from "../authorisation/api";

const { Option } = Select;

const ProjectsBarChart = ({ projects }) => {
  const [organizations, setOrganizations] = useState([]);
  const [organizationId, setOrganizationId] = useState("");

  const fetchOrgs = async () => {
    try {
      const resp = await apiRequest("/organizations", "GET");
      setOrganizations(resp.data);
    } catch (err) {
      console.log(err);
      setOrganizations([]);
    }
  };

  useEffect(() => {
    fetchOrgs();
  }, []);

  const chartData = projects
    .filter(
      (proj) =>
        proj.attributes.total_hours_spent > 0 &&
        (organizationId === "" ||
          proj.attributes.organization_id === Number(organizationId))
    )
    .map((proj) => ({
      name: proj.attributes.name,
      hours: proj.attributes.total_hours_spent,
    }));

  const handleChange = (value) => {
    setOrganizationId(value);
  };

  const finalChartData =
    chartData.length > 0 ? chartData : [{ name: "No Data", hours: 0 }];
  return (
    <div
      className="graph-wrapper"
      style={{ width: "100%", height: 350, paddingRight: "5%" }}
    >
      <div
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
        }}
      >
        <h2>Total Hours per Project</h2>
        <Select
          placeholder="Select organization"
          value={organizationId}
          onChange={handleChange}
          style={{ width: 220 }}
        >
          <Option value="">All organizations</Option>
          {organizations.map((org) => (
            <Option key={org.id} value={org.id}>
              {org.attributes.name}
            </Option>
          ))}
        </Select>
      </div>
      <ResponsiveContainer width="100%" height="100%">
        <BarChart
          data={finalChartData}
          margin={{ top: 20, bottom: 20, left: 10 }}
        >
          <CartesianGrid />
          <XAxis dataKey="name" />
          <YAxis
            label={{ value: "Hours", angle: -90, position: "insideLeft" }}
          />
          <Tooltip />
          <Bar dataKey="hours" fill="#1890ff" />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
};

export default ProjectsBarChart;
