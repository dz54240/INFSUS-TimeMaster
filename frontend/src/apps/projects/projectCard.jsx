import React from "react";
import { Card, Row, Col, Button } from "antd";

const ProjectCard = ({ project, isOwner, handleDelete, orgName }) => {
  const {
    name,
    start_date,
    end_date,
    budget_amount,
    current_cost,
    total_hours_spent,
    description,
  } = project.attributes;

  const budget = budget_amount ?? 0;
  const cost = parseFloat(current_cost ?? 0);
  const hours = total_hours_spent ?? 0;
  const budgetLeft = budget - cost;
  const formattedStartDate = start_date
    ? new Date(start_date).toLocaleDateString()
    : "-";

  const formattedEndDate = end_date
    ? new Date(end_date).toLocaleDateString()
    : "-";
  return (
    <Card
      size="small"
      title={name}
      style={{ marginTop: "20px" }}
      extra={
        isOwner && (
          <Button
            type="primary"
            danger
            size="small"
            onClick={() => handleDelete(project.id)}
          >
            Delete
          </Button>
        )
      }
    >
      <Row>
        <strong>Organisation: {orgName}</strong>
      </Row>
      <Row>
        <strong>Description: {description}</strong>
      </Row>
      <Row>
        <Col>
          <strong>Start Date:</strong> {formattedStartDate}
        </Col>
        <Col>
          <strong>End Date:</strong> {formattedEndDate}
        </Col>
      </Row>
      {isOwner && (
        <>
          <Row>
            <Col>
              <strong>Budget:</strong> {budget}€
            </Col>
            <Col>
              <strong>Current Cost:</strong> {cost}€
            </Col>
          </Row>
          <Row>
            <Col>
              <strong>Total Hours:</strong> {hours}
            </Col>
            <Col>
              <strong>Budget left:</strong> {budgetLeft}€
            </Col>
          </Row>
        </>
      )}
    </Card>
  );
};

export default ProjectCard;
