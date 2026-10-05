import React, { useState, useEffect } from "react";
import { Menu, Search, Clock, RefreshCw, User, Bell } from "lucide-react";

interface NavbarProps {
  activePage: string;
  onMenuToggle: () => void;
  globalSearch: string;
  onGlobalSearchChange: (val: string) => void;
  syncStatus: "synced" | "syncing" | "error";
  onSyncRefresh: () => void;
  userName?: string | null;
}

export default function Navbar({
  activePage,
  onMenuToggle,
  globalSearch,
  onGlobalSearchChange,
  syncStatus,
  onSyncRefresh,
  userName
}: NavbarProps) {
  const [time, setTime] = useState("");

  useEffect(() => {
    const updateTime = () => {
      const now = new Date();
      setTime(now.toLocaleTimeString("en-US", { hour12: false }));
    };
    updateTime();
    const interval = setInterval(updateTime, 1000);
    return () => clearInterval(interval);
  }, []);

  const formatTitle = (str: string) => {
    if (!str) return "Dashboard";
    return str.charAt(0).toUpperCase() + str.slice(1);
  };

  return (
    <header className="h-16 bg-white border-b border-slate-200 px-6 flex items-center justify-between sticky top-0 z-30">
      {/* Left section: Hamburger & Title */}
      <div className="flex items-center gap-4">
        <button
          onClick={onMenuToggle}
          className="lg:hidden p-2 text-slate-500 hover:text-slate-700 hover:bg-slate-100 rounded-lg transition-all"
        >
          <Menu className="h-5 w-5" />
        </button>
        <div className="flex flex-col">
          <h2 className="font-display font-semibold text-slate-800 text-lg leading-tight">
            {formatTitle(activePage)}
          </h2>
          <p className="text-[10px] text-slate-400 font-medium">Smart Transportation System</p>
        </div>
      </div>

      {/* Middle section: Global search (with responsive sizing) */}
      <div className="hidden md:flex items-center flex-1 max-w-md mx-8 relative">
        <Search className="h-4 w-4 text-slate-400 absolute left-3 pointer-events-none" />
        <input
          type="text"
          value={globalSearch}
          onChange={(e) => onGlobalSearchChange(e.target.value)}
          placeholder={`Global search across ${activePage}...`}
          className="w-full pl-9 pr-4 py-1.5 text-xs bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all text-slate-700 placeholder:text-slate-400"
        />
      </div>

      {/* Right section: System status, Time & Profile */}
      <div className="flex items-center gap-4">
        {/* Sync Status Button */}
        <button
          onClick={onSyncRefresh}
          className="flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-slate-50 hover:bg-slate-100 transition-all text-[10px] font-medium text-slate-600 border border-slate-150"
          title="Force synchronization with Firestore"
        >
          <RefreshCw className={`h-3 w-3 text-indigo-500 ${syncStatus === "syncing" ? "animate-spin" : ""}`} />
          <span className="hidden sm:inline">
            {syncStatus === "synced" ? "Database Connected" : syncStatus === "syncing" ? "Syncing..." : "Sync Error"}
          </span>
        </button>

        {/* Live Clock Display */}
        <div className="hidden sm:flex items-center gap-1.5 text-xs text-slate-500 font-mono bg-slate-50 px-2.5 py-1 border border-slate-150 rounded-lg">
          <Clock className="h-3.5 w-3.5 text-slate-400" />
          <span>{time}</span>
        </div>

        {/* Divider */}
        <span className="h-5 w-[1px] bg-slate-200 hidden sm:inline" />

        {/* User Info & Profile Avatar */}
        <div className="flex items-center gap-2.5">
          <div className="text-right hidden md:block">
            <p className="text-xs font-semibold text-slate-700 leading-tight">
              {userName || "Operator"}
            </p>
            <p className="text-[10px] font-medium text-indigo-600 leading-none">System Admin</p>
          </div>
          <div className="h-8 w-8 rounded-xl bg-gradient-to-tr from-indigo-500 to-violet-600 p-[1.5px] flex items-center justify-center text-white text-xs font-bold font-display shadow-sm shadow-indigo-500/10">
            <div className="w-full h-full bg-slate-900 rounded-[10px] flex items-center justify-center">
              <User className="h-4.5 w-4.5 text-slate-200" />
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
