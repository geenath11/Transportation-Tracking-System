import "./DashboardCards.css";

import StatCard from "../Cards/StatCard";

import { FaUsers, FaUserTie, FaBus, FaTicketAlt } from "react-icons/fa";

function DashboardCards() {
  return (
    <div className="cards">
      <StatCard title="Passengers" value="1245" icon={<FaUsers />} />

      <StatCard title="Drivers" value="42" icon={<FaUserTie />} />

      <StatCard title="Vehicles" value="30" icon={<FaBus />} />

      <StatCard title="Bookings" value="183" icon={<FaTicketAlt />} />
    </div>
  );
}

export default DashboardCards;
