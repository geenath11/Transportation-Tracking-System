import "./Sidebar.css";
import { Link } from "react-router-dom";

function Sidebar() {
  return (
    <div className="sidebar">
      <h2>Smart Transit</h2>

      <Link to="/">Dashboard</Link>

      <Link to="/users">Users</Link>

      <Link to="/drivers">Drivers</Link>

      <Link to="/conductors">Conductors</Link>

      <Link to="/vehicles">Vehicles</Link>

      <Link to="/routes">Routes</Link>

      <Link to="/timetables">Timetables</Link>

      <Link to="/bookings">Bookings</Link>

      <Link to="/complaints">Complaints</Link>

      <Link to="/notifications">Notifications</Link>

      <Link to="/analytics">Analytics</Link>

      <Link to="/settings">Settings</Link>
    </div>
  );
}

export default Sidebar;
