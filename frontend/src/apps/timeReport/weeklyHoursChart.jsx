import React, { useEffect, useState } from "react";
import dayjs from "dayjs";
import isoWeek from "dayjs/plugin/isoWeek";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  CartesianGrid,
  ResponsiveContainer,
} from "recharts";
import apiRequest from "../authorisation/api";

dayjs.extend(isoWeek);

const aggregateHoursByDay = (workLogs) => {
  const days = {};
  const startOfWeek = dayjs().startOf("isoWeek");

  for (let i = 0; i < 7; i++) {
    const day = startOfWeek.add(i, "day");
    days[day.format("YYYY-MM-DD")] = {
      dayLabel: day.format("ddd"),
      totalHours: 0,
    };
  }

  workLogs.forEach((log) => {
    const start = dayjs(log.attributes.start_time);
    const end = dayjs(log.attributes.end_time);
    const durationMinutes = end.diff(start, "minute");
    const durationHours = durationMinutes / 60;

    const dayKey = start.format("YYYY-MM-DD");
    if (days[dayKey]) {
      days[dayKey].totalHours += durationHours;
    }
  });

  return Object.values(days);
};

const WeeklyHoursChart = ({ projects }) => {
  const [workLogs, setWorkLogs] = useState([]);

  const fetchWorkLogs = async () => {
    try {
      const resp = await apiRequest("/work_logs?current_week=true", "GET");
      setWorkLogs(resp.data);
    } catch (error) {
      console.error("Failed to fetch work logs", error);
      setWorkLogs([]);
    }
  };

  useEffect(() => {
    fetchWorkLogs();
  }, [projects]);

  const data = aggregateHoursByDay(workLogs);

  return (
    <div className="graph-wrapper" style={{ width: "100%", height: 350 }}>
      <h2>Hours Spent - Current Week</h2>

      <ResponsiveContainer width="100%" height="100%">
        <BarChart
          data={data}
          margin={{ top: 20, bottom: 20, left: 10, right: 10 }}
        >
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="dayLabel" />
          <YAxis
            label={{ value: "Hours", angle: -90, position: "insideLeft" }}
          />
          <Tooltip formatter={(value) => value.toFixed(2) + " h"} />
          <Bar dataKey="totalHours" fill="#52c41a" />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
};

export default WeeklyHoursChart;
