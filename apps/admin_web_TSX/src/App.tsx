import React, { useState, useEffect } from "react";
import { User as FirebaseUser, updateProfile } from "firebase/auth";

// Common layout & security components
import Sidebar from "./components/Sidebar";
import Navbar from "./components/Navbar";
import DeleteConfirmationModal from "./components/DeleteConfirmationModal";

// Pages
import Login from "./pages/Login";
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

// Services & Types
import { auth } from "./services/firebase";
import {
  loginWithFirebase,
  logoutWithFirebase,
  onAuthStateSubscription,
} from "./services/authService";
import {
  seedDatabaseIfEmpty,
  subscribeToCollection,
  createDocument,
  updateDocument,
  deleteDocument,
  logActivity,
} from "./services/dbService";

import {
  User,
  Driver,
  Conductor,
  Vehicle,
  Route,
  Timetable,
  Booking,
  Complaint,
  NotificationItem,
  ActivityLog,
} from "./types";

export default function App() {
  const [user, setUser] = useState<FirebaseUser | null>(null);
  const [authLoading, setAuthLoading] = useState(true);

  // App Core State (Real-time Firestore)
  const [users, setUsers] = useState<User[]>([]);
  const [drivers, setDrivers] = useState<Driver[]>([]);
  const [conductors, setConductors] = useState<Conductor[]>([]);
  const [vehicles, setVehicles] = useState<Vehicle[]>([]);
  const [routes, setRoutes] = useState<Route[]>([]);
  const [timetables, setTimetables] = useState<Timetable[]>([]);
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [complaints, setComplaints] = useState<Complaint[]>([]);
  const [notifications, setNotifications] = useState<NotificationItem[]>([]);
  const [activityLogs, setActivityLogs] = useState<ActivityLog[]>([]);

  // Navigation & UI Layout State
  const [activePage, setActivePage] = useState("dashboard");
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [globalSearch, setGlobalSearch] = useState("");
  const [syncStatus, setSyncStatus] = useState<"synced" | "syncing" | "error">(
    "synced"
  );

  // Deletion guard state
  const [deleteModal, setDeleteModal] = useState<{
    isOpen: boolean;
    collection: string;
    id: string;
    title: string;
    description: string;
  }>({
    isOpen: false,
    collection: "",
    id: "",
    title: "",
    description: "",
  });

  // 1. Initial Seeding and Auth subscription
  useEffect(() => {
    // Check and seed DB with base mock records if empty
    seedDatabaseIfEmpty();

    const unsubAuth = onAuthStateSubscription((firebaseUser) => {
      setUser(firebaseUser);
      setAuthLoading(false);
    });

    return () => {
      unsubAuth();
    };
  }, []);

  // 2. Real-time Firestore Subscriptions (Active only when logged in)
  useEffect(() => {
    if (!user) return;

    setSyncStatus("syncing");

    const unsubscribers = [
      subscribeToCollection<User>("users", (data) => setUsers(data)),
      subscribeToCollection<Driver>("drivers", (data) => setDrivers(data)),
      subscribeToCollection<Conductor>("conductors", (data) =>
        setConductors(data)
      ),
      subscribeToCollection<Vehicle>("vehicles", (data) => setVehicles(data)),
      subscribeToCollection<Route>("routes", (data) => setRoutes(data)),
      subscribeToCollection<Timetable>("timetables", (data) =>
        setTimetables(data)
      ),
      subscribeToCollection<Booking>("bookings", (data) => setBookings(data)),
      subscribeToCollection<Complaint>("complaints", (data) =>
        setComplaints(data)
      ),
      subscribeToCollection<NotificationItem>("notifications", (data) =>
        setNotifications(data)
      ),
      subscribeToCollection<ActivityLog>("activityLogs", (data) => {
        // Sort logs descending by timestamp
        const sorted = [...data].sort(
          (a, b) =>
            new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime()
        );
        setActivityLogs(sorted);
        setSyncStatus("synced");
      }),
    ];

    return () => {
      unsubscribers.forEach((unsub) => unsub());
    };
  }, [user]);

  // 3. Hash routing handler
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
    handleHashChange(); // Sync initial mount

    return () => {
      window.removeEventListener("hashchange", handleHashChange);
    };
  }, []);

  const navigateToPage = (pageName: string) => {
    window.location.hash = `#/${pageName}`;
    setActivePage(pageName);
    setGlobalSearch(""); // Reset global search on tab change
  };

  // Auth Callbacks
  const handleLogin = async (email: string, pass: string) => {
    await loginWithFirebase(email, pass);
  };

  const handleLogout = async () => {
    await logoutWithFirebase();
    setUser(null);
  };

  const handleUpdateProfile = async (newName: string) => {
    if (auth.currentUser) {
      await updateProfile(auth.currentUser, { displayName: newName });
      await logActivity(
        "Profile Updated",
        `Admin name updated to: ${newName}`,
        auth.currentUser.email || "Admin"
      );
    }
  };

  // CRUD DB Wrappers with audit logs
  const handleCreate = async (collectionName: string, data: any) => {
    setSyncStatus("syncing");
    const docId = await createDocument(collectionName, data);
    const operator = user?.email || "Admin";
    await logActivity(
      `${collectionName.slice(0, -1).toUpperCase()} Created`,
      `Added record with ID: ${docId}`,
      operator
    );
    setSyncStatus("synced");
  };

  const handleUpdate = async (
    collectionName: string,
    id: string,
    data: any
  ) => {
    setSyncStatus("syncing");
    await updateDocument(collectionName, id, data);
    const operator = user?.email || "Admin";
    await logActivity(
      `${collectionName.slice(0, -1).toUpperCase()} Updated`,
      `Modified record ID: ${id}`,
      operator
    );
    setSyncStatus("synced");
  };

  const triggerDelete = (
    collectionName: string,
    id: string,
    title: string,
    desc: string
  ) => {
    setDeleteModal({
      isOpen: true,
      collection: collectionName,
      id,
      title,
      description: desc,
    });
  };

  const handleConfirmDelete = async () => {
    const { collection, id } = deleteModal;
    if (!id || !collection) return;

    setSyncStatus("syncing");
    await deleteDocument(collection, id);
    const operator = user?.email || "Admin";
    await logActivity(
      `${collection.slice(0, -1).toUpperCase()} Deleted`,
      `Permanently removed record ID: ${id}`,
      operator
    );
    setSyncStatus("synced");
  };

  const handleSendNotification = async (id: string) => {
    setSyncStatus("syncing");
    await updateDocument("notifications", id, { status: "Sent" });
    const operator = user?.email || "Admin";
    await logActivity(
      `NOTIFICATION Broadcast`,
      `Instantly transmitted announcement ID: ${id}`,
      operator
    );
    setSyncStatus("synced");
  };

  const handleForceSync = () => {
    setSyncStatus("syncing");
    setTimeout(() => {
      setSyncStatus("synced");
    }, 600);
  };

  // Safe Loading Screen
  if (authLoading) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center font-sans">
        <div className="flex flex-col items-center gap-3">
          <div className="h-9 w-9 border-4 border-indigo-600 border-t-transparent rounded-full animate-spin" />
          <p className="text-slate-500 font-mono text-xs font-semibold tracking-wider">
            SECURE AUTHORIZATION BOOTING...
          </p>
        </div>
      </div>
    );
  }

  // Auth Guard Gate
  if (!user) {
    return <Login onLogin={handleLogin} />;
  }

  // Dynamic filter lists for Global search proxy
  const searchLower = globalSearch.toLowerCase();

  const searchedUsers = users.filter(
    (u) =>
      !globalSearch ||
      u.name.toLowerCase().includes(searchLower) ||
      u.email.toLowerCase().includes(searchLower)
  );

  const searchedDrivers = drivers.filter(
    (d) =>
      !globalSearch ||
      d.name.toLowerCase().includes(searchLower) ||
      d.licenseNumber.toLowerCase().includes(searchLower)
  );

  const searchedConductors = conductors.filter(
    (c) =>
      !globalSearch ||
      c.name.toLowerCase().includes(searchLower) ||
      c.phone.toLowerCase().includes(searchLower)
  );

  const searchedVehicles = vehicles.filter(
    (v) =>
      !globalSearch ||
      v.vehicleNumber.toLowerCase().includes(searchLower) ||
      v.vehicleType.toLowerCase().includes(searchLower)
  );

  const searchedRoutes = routes.filter(
    (r) =>
      !globalSearch ||
      r.routeNumber.toLowerCase().includes(searchLower) ||
      r.start.toLowerCase().includes(searchLower) ||
      r.destination.toLowerCase().includes(searchLower)
  );

  const searchedTimetables = timetables.filter(
    (t) =>
      !globalSearch ||
      t.routeNumber.toLowerCase().includes(searchLower) ||
      t.vehicleNumber.toLowerCase().includes(searchLower) ||
      t.driverName.toLowerCase().includes(searchLower)
  );

  const searchedBookings = bookings.filter(
    (b) =>
      !globalSearch ||
      b.bookingId.toLowerCase().includes(searchLower) ||
      b.passengerName.toLowerCase().includes(searchLower)
  );

  const searchedComplaints = complaints.filter(
    (c) =>
      !globalSearch ||
      c.complaintId.toLowerCase().includes(searchLower) ||
      c.subject.toLowerCase().includes(searchLower) ||
      c.passengerName.toLowerCase().includes(searchLower)
  );

  const searchedNotifications = notifications.filter(
    (n) =>
      !globalSearch ||
      n.title.toLowerCase().includes(searchLower) ||
      n.message.toLowerCase().includes(searchLower)
  );

  // Primary Router Matrix
  const renderPage = () => {
    switch (activePage) {
      case "dashboard":
        return (
          <Dashboard
            users={users}
            drivers={drivers}
            conductors={conductors}
            vehicles={vehicles}
            routes={routes}
            timetables={timetables}
            bookings={bookings}
            complaints={complaints}
            activityLogs={activityLogs}
            onPageChange={navigateToPage}
          />
        );
      case "users":
        return (
          <Users
            users={searchedUsers}
            onCreate={(data) => handleCreate("users", data)}
            onUpdate={(id, data) => handleUpdate("users", id, data)}
            onDelete={(id) =>
              triggerDelete(
                "users",
                id,
                "Delete System User?",
                "Are you sure you want to permanently remove this user and terminate their role permissions?"
              )
            }
          />
        );
      case "drivers":
        return (
          <Drivers
            drivers={searchedDrivers}
            onCreate={(data) => handleCreate("drivers", data)}
            onUpdate={(id, data) => handleUpdate("drivers", id, data)}
            onDelete={(id) =>
              triggerDelete(
                "drivers",
                id,
                "Deregister Driver?",
                "Are you sure you want to delete this driver? They will be removed from all future timetable assignments."
              )
            }
          />
        );
      case "conductors":
        return (
          <Conductors
            conductors={searchedConductors}
            onCreate={(data) => handleCreate("conductors", data)}
            onUpdate={(id, data) => handleUpdate("conductors", id, data)}
            onDelete={(id) =>
              triggerDelete(
                "conductors",
                id,
                "Remove Conductor Staff?",
                "This action will permanently purge this conductor from the roster."
              )
            }
          />
        );
      case "vehicles":
        return (
          <Vehicles
            vehicles={searchedVehicles}
            onCreate={(data) => handleCreate("vehicles", data)}
            onUpdate={(id, data) => handleUpdate("vehicles", id, data)}
            onDelete={(id) =>
              triggerDelete(
                "vehicles",
                id,
                "Decommission Fleet Vehicle?",
                "Are you sure you want to decommission this vehicle and clear its seating allocations?"
              )
            }
          />
        );
      case "routes":
        return (
          <Routes
            routes={searchedRoutes}
            onCreate={(data) => handleCreate("routes", data)}
            onUpdate={(id, data) => handleUpdate("routes", id, data)}
            onDelete={(id) =>
              triggerDelete(
                "routes",
                id,
                "Purge Transit Route?",
                "Permanently deleting this route will cascade-delete any scheduled bus timetables bound to it."
              )
            }
          />
        );
      case "timetables":
        return (
          <Timetables
            timetables={searchedTimetables}
            routes={routes}
            vehicles={vehicles}
            drivers={drivers}
            onCreate={(data) => handleCreate("timetables", data)}
            onUpdate={(id, data) => handleUpdate("timetables", id, data)}
            onDelete={(id) =>
              triggerDelete(
                "timetables",
                id,
                "Deallocate Schedule?",
                "Removing this timetable will release the allocated driver and bus for other schedules."
              )
            }
          />
        );
      case "bookings":
        return (
          <Bookings
            bookings={searchedBookings}
            onCreate={(data) => handleCreate("bookings", data)}
            onUpdate={(id, data) => handleUpdate("bookings", id, data)}
            onDelete={(id) =>
              triggerDelete(
                "bookings",
                id,
                "Purge Booking?",
                "Deleting this travel booking cannot be undone. Seats will be re-opened immediately."
              )
            }
          />
        );
      case "complaints":
        return (
          <Complaints
            complaints={searchedComplaints}
            onCreate={(data) => handleCreate("complaints", data)}
            onUpdate={(id, data) => handleUpdate("complaints", id, data)}
            onDelete={(id) =>
              triggerDelete(
                "complaints",
                id,
                "Delete Complaint File?",
                "Purge this passenger complaint file permanently from the database logs."
              )
            }
          />
        );
      case "notifications":
        return (
          <Notifications
            notifications={searchedNotifications}
            onCreate={(data) => handleCreate("notifications", data)}
            onUpdate={(id, data) => handleUpdate("notifications", id, data)}
            onDelete={(id) =>
              triggerDelete(
                "notifications",
                id,
                "Delete Broadcast Draft?",
                "Delete this announcement draft permanently."
              )
            }
            onSendInstant={handleSendNotification}
          />
        );
      case "analytics":
        return (
          <Analytics
            users={users}
            drivers={drivers}
            conductors={conductors}
            vehicles={vehicles}
            routes={routes}
            bookings={bookings}
            complaints={complaints}
          />
        );
      case "settings":
        return (
          <SettingsPage
            adminEmail={user.email}
            adminName={user.displayName || "System Administrator"}
            onUpdateProfile={handleUpdateProfile}
            onLogout={handleLogout}
          />
        );
      default:
        return (
          <Dashboard
            users={users}
            drivers={drivers}
            conductors={conductors}
            vehicles={vehicles}
            routes={routes}
            timetables={timetables}
            bookings={bookings}
            complaints={complaints}
            activityLogs={activityLogs}
            onPageChange={navigateToPage}
          />
        );
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
        onLogout={handleLogout}
        userEmail={user.email}
      />

      {/* Main Panel Frame */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Navbar Header */}
        <Navbar
          activePage={activePage}
          onMenuToggle={() => setIsSidebarOpen(!isSidebarOpen)}
          globalSearch={globalSearch}
          onGlobalSearchChange={setGlobalSearch}
          syncStatus={syncStatus}
          onSyncRefresh={handleForceSync}
          userName={user.displayName}
        />

        {/* Content Container */}
        <main className="flex-1 overflow-y-auto p-6 focus:outline-none bg-slate-50/50">
          <div className="max-w-7xl mx-auto">{renderPage()}</div>
        </main>
      </div>

      {/* Deletion Guard Modal */}
      <DeleteConfirmationModal
        isOpen={deleteModal.isOpen}
        title={deleteModal.title}
        description={deleteModal.description}
        onClose={() => setDeleteModal({ ...deleteModal, isOpen: false })}
        onConfirm={handleConfirmDelete}
      />
    </div>
  );
}
