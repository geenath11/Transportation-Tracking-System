import MainLayout from "../../layouts/MainLayout";

import DashboardCards from "../../components/Dashboard/DashboardCards";
import PassengerChart from "../../components/Charts/PassengerChart";
import LiveBusStatus from "../../components/BusStatus/LiveBusStatus";
import RecentActivity from "../../components/Activity/RecentActivity";

function Dashboard() {
  return (
    <MainLayout>
      <h1>Dashboard</h1>

      <p>Welcome back, Administrator.</p>

      <DashboardCards />

      <PassengerChart />

      <LiveBusStatus />

      <RecentActivity />
    </MainLayout>
  );
}

export default Dashboard;
