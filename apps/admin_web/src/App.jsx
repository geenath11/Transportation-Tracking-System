import { BrowserRouter, Routes, Route } from "react-router-dom";

import Dashboard from "./pages/Dashboard/Dashboard";
import Users from "./pages/Users/Users";
import Drivers from "./pages/Drivers/Drivers";
import Conductors from "./pages/Conductors/Conductors";
import Vehicles from "./pages/Vehicles/Vehicles";
import RoutesPage from "./pages/Routes/Routes";
import Timetables from "./pages/Timetables/Timetables";
import Bookings from "./pages/Bookings/Bookings";
import Complaints from "./pages/Complaints/Complaints";
import Notifications from "./pages/Notifications/Notifications";
import Analytics from "./pages/Analytics/Analytics";
import Settings from "./pages/Settings/Settings";
import Login from "./pages/Login/Login";
function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/users" element={<Users />} />
        <Route path="/drivers" element={<Drivers />} />
        <Route path="/conductors" element={<Conductors />} />
        <Route path="/vehicles" element={<Vehicles />} />
        <Route path="/routes" element={<RoutesPage />} />
        <Route path="/timetables" element={<Timetables />} />
        <Route path="/bookings" element={<Bookings />} />
        <Route path="/complaints" element={<Complaints />} />
        <Route path="/notifications" element={<Notifications />} />
        <Route path="/analytics" element={<Analytics />} />
        <Route path="/settings" element={<Settings />} />
        <Route path="/login" element={<Login />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
