import React from "react";
import { Layout } from "antd";
import Navigation from "../../components/navigation";
import MyHeader from "../../components/header";
const { Sider, Content } = Layout;

const Home = ({ Page }) => {
  return (
    <Layout style={{ minHeight: "100vh" }}>
      <MyHeader />
      <Layout>
        <Sider width={200} className="site-layout-background">
          <Navigation />
        </Sider>

        <Layout>
          <Content
            className="content-container"
            style={{ background: "#fff", padding: 24, minHeight: 280 }}
          >
            <Page />
          </Content>
        </Layout>
      </Layout>
    </Layout>
  );
};

export default Home;
