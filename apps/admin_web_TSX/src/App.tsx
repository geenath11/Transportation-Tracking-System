import { useEffect, useState } from "react";

// Common layout & security components
import Sidebar from "./components/Sidebar";
import Navbar from "./components/Navbar";

// Pages
import Dashboard from "./pages/Dashboard";
import Users from "./pages/Users";
import Drivers from "./pages/Drivers";
import Conductors from "./pages/Conductors";
import Vehicles from "./pages/Vehicles";
import Routes from "./pages/Routes";
import Timetables from "./pages/Timetables";
import Bookings from "./pages/Bookings";
import Complaints from "./pages/Complaints";
import Notifications from "./pages/Notifications";
import Analytics from "./pages/Analytics";
import SettingsPage from "./pages/Settings";

export default function App() {
  // Navigation & UI Layout State
  const [activePage, setActivePage] = useState("dashboard");
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);

  useEffect(() => {
    const handleHashChange = () => {
      const hash = window.location.hash.replace("#/", "");

      const validPages = [
        "dashboard",
        "users",
        "drivers",
        "conductors",
        "vehicles",
        "routes",
        "timetables",
        "bookings",
        "complaints",
        "notifications",
        "analytics",
        "settings",
      ];

      if (hash && validPages.includes(hash)) {
        setActivePage(hash);
      }
    };

    window.addEventListener("hashchange", handleHashChange);

    handleHashChange();

    return () => {
      window.removeEventListener("hashchange", handleHashChange);
    };
  }, []);

  const navigateToPage = (pageName: string) => {
    window.location.hash = `#/${pageName}`;
    setActivePage(pageName);
  };

  // Primary Router Matrix
  const renderPage = () => {
    switch (activePage) {
      case "dashboard":
        return <Dashboard />;

      case "users":
        return <Users />;

      case "drivers":
        return <Drivers />;

      case "conductors":
        return <Conductors />;

      case "vehicles":
        return <Vehicles />;

      case "routes":
        return <Routes />;

      case "timetables":
        return <Timetables />;

      case "bookings":
        return <Bookings />;

      case "complaints":
        return <Complaints />;

      case "notifications":
        return <Notifications />;

      case "analytics":
        return <Analytics />;

      case "settings":
        return <SettingsPage />;

      default:
        return <Dashboard />;
    }
  };
  return (
    <div className="h-screen flex overflow-hidden bg-slate-50">
      {/* Sidebar Navigation Drawer */}
      <Sidebar
        activePage={activePage}
        onPageChange={navigateToPage}
        isOpen={isSidebarOpen}
        onClose={() => setIsSidebarOpen(false)}
      />

      {/* Main Panel Frame */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Navbar Header */}
        <Navbar
          activePage={activePage}
          onMenuToggle={() => setIsSidebarOpen(!isSidebarOpen)}
        />

        {/* Content Container */}
        <main className="flex-1 overflow-y-auto p-6 focus:outline-none bg-slate-50/50">
          <div className="max-w-7xl mx-auto">{renderPage()}</div>
        </main>
      </div>
    </div>
  );
}
