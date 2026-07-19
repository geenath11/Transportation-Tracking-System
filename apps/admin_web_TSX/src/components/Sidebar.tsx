import React from "react";
import {
  LayoutDashboard,
  Users,
  UserCheck,
  Contact,
  Bus,
  Route,
  Calendar,
  Ticket,
  AlertTriangle,
  Bell,
  BarChart3,
  Settings,
  X,
  Shield,
} from "lucide-react";

interface SidebarProps {
  activePage: string;
  onPageChange: (page: string) => void;
  isOpen: boolean;
  onClose: () => void;
}

export default function Sidebar({
  activePage,
  onPageChange,
  isOpen,
  onClose,
}: SidebarProps) {
  const menuItems = [
    { id: "dashboard", label: "Dashboard", icon: LayoutDashboard },
    { id: "users", label: "Users", icon: Users },
    { id: "drivers", label: "Drivers", icon: UserCheck },
    { id: "conductors", label: "Conductors", icon: Contact },
    { id: "vehicles", label: "Vehicles", icon: Bus },
    { id: "routes", label: "Routes", icon: Route },
    { id: "timetables", label: "Timetables", icon: Calendar },
    { id: "bookings", label: "Bookings", icon: Ticket },
    { id: "complaints", label: "Complaints", icon: AlertTriangle },
    { id: "notifications", label: "Notifications", icon: Bell },
    { id: "analytics", label: "Analytics", icon: BarChart3 },
    { id: "settings", label: "Settings", icon: Settings },
  ];

  return (
    <>
      {/* Mobile Sidebar Overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs z-40 lg:hidden"
          onClick={onClose}
        />
      )}

      {/* Sidebar Container */}
      <aside 
        className={`fixed inset-y-0 left-0 w-64 bg-slate-950 text-slate-100 z-50 flex flex-col transform transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:h-screen ${
          isOpen ? "translate-x-0" : "-translate-x-full"
        }`}
      >
        {/* Header / Brand */}
        <div className="h-16 flex items-center justify-between px-6 border-b border-slate-800">
          <div className="flex items-center gap-2.5">
            <div className="p-2 bg-indigo-600 rounded-lg">
              <Bus className="h-5 w-5 text-white" />
            </div>
            <div>
              <h1 className="font-display font-bold text-sm tracking-wide bg-gradient-to-r from-white via-slate-100 to-indigo-200 bg-clip-text text-transparent">
                TRANSIT ADMIN
              </h1>
              <p className="text-[10px] text-slate-500 font-mono tracking-wider">SMART TRACKING</p>
            </div>
          </div>
          <button 
            onClick={onClose} 
            className="lg:hidden text-slate-400 hover:text-white p-1 rounded-md hover:bg-slate-900"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        {/* User context card */}
        <div className="px-4 py-3 border-b border-slate-900 bg-slate-900/20">
          <div className="flex items-center gap-3 p-2 bg-slate-900/50 rounded-xl">
            <div className="h-9 w-9 rounded-lg bg-indigo-500/10 flex items-center justify-center text-indigo-400">
              <Shield className="h-5 w-5" />
            </div>
            <div className="overflow-hidden">
              <p className="text-xs font-semibold text-slate-200 truncate">Administrator</p>
              <p className="text-[10px] font-mono text-slate-400 truncate">admin@transport.com</p>
            </div>
          </div>
        </div>

        {/* Navigation items */}
        <nav className="flex-1 overflow-y-auto px-3 py-4 space-y-1">
          {menuItems.map((item) => {
            const IconComponent = item.icon;
            const isActive = activePage === item.id;
            return (
              <button
                key={item.id}
                onClick={() => {
                  onPageChange(item.id);
                  onClose();
                }}
                className={`w-full flex items-center gap-3 px-4 py-2.5 rounded-xl text-sm font-medium transition-all duration-200 ${
                  isActive 
                    ? "bg-indigo-600 text-white shadow-lg shadow-indigo-600/15" 
                    : "text-slate-400 hover:text-slate-100 hover:bg-slate-900"
                }`}
              >
                <IconComponent className={`h-4.5 w-4.5 ${isActive ? "text-white" : "text-slate-400"}`} />
                <span>{item.label}</span>
                {isActive && (
                  <span className="ml-auto h-1.5 w-1.5 rounded-full bg-white" />
                )}
              </button>
            );
          })}
        </nav>

       
      </aside>
    </>
  );
}
