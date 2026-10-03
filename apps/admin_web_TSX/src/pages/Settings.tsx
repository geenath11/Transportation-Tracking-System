import React, { useState } from "react";
import { User, Settings, Info, Shield, Sun, Moon, Lock, RefreshCw } from "lucide-react";

interface SettingsProps {
  adminEmail: string | null;
  adminName: string;
  onUpdateProfile: (name: string) => Promise<void>;
  onLogout: () => void;
}

export default function SettingsPage({
  adminEmail,
  adminName,
  onUpdateProfile,
  onLogout
}: SettingsProps) {
  const [nameInput, setNameInput] = useState(adminName || "System Admin");
  const [isDark, setIsDark] = useState(false);
  const [isUpdating, setIsUpdating] = useState(false);
  const [statusMessage, setStatusMessage] = useState("");

  const handleUpdate = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsUpdating(true);
    setStatusMessage("");

    try {
      await onUpdateProfile(nameInput);
      setStatusMessage("Profile updated successfully!");
    } catch (err) {
      setStatusMessage("Failed to update profile. Try again.");
    } finally {
      setIsUpdating(false);
    }
  };

  const toggleDarkMode = () => {
    setIsDark(!isDark);
    if (!isDark) {
      document.documentElement.classList.add("dark");
    } else {
      document.documentElement.classList.remove("dark");
    }
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Settings Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        {/* Left Side: Category Menu */}
        <div className="md:col-span-1 space-y-4">
          <div className="bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
            <h4 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3">Settings Console</h4>
            <div className="space-y-1 text-xs">
              <button className="w-full text-left px-3 py-2 rounded-lg bg-indigo-50 text-indigo-700 font-semibold flex items-center gap-2">
                <User className="h-4 w-4" />
                <span>Admin Profile</span>
              </button>
              <button 
                onClick={toggleDarkMode}
                className="w-full text-left px-3 py-2 rounded-lg text-slate-600 hover:bg-slate-50 font-medium flex items-center justify-between"
              >
                <div className="flex items-center gap-2">
                  {isDark ? <Moon className="h-4 w-4 text-indigo-500" /> : <Sun className="h-4 w-4 text-amber-500" />}
                  <span>Visual Theme ({isDark ? "Dark" : "Light"})</span>
                </div>
                <span className="text-[10px] bg-indigo-100 text-indigo-700 font-bold px-1.5 py-0.5 rounded-sm">Toggle</span>
              </button>
            </div>
          </div>

          {/* Project Spec Board */}
          <div className="bg-slate-900 text-slate-300 p-4 rounded-2xl border border-slate-800 shadow-xs flex flex-col justify-between">
            <div>
              <h4 className="text-[10px] font-mono font-bold text-slate-500 uppercase tracking-widest mb-3 flex items-center gap-1.5">
                <Info className="h-3.5 w-3.5" />
                SYSTEM COMPILATION
              </h4>
              <div className="space-y-2 font-mono text-[10px]">
                <div className="flex justify-between border-b border-slate-800 pb-1.5">
                  <span className="text-slate-400">PROJECT</span>
                  <span className="font-semibold text-white">TRANSIT-ADM</span>
                </div>
                <div className="flex justify-between border-b border-slate-800 pb-1.5">
                  <span className="text-slate-400">VERSION</span>
                  <span className="font-semibold text-indigo-400">v1.2.0-cloud</span>
                </div>
                <div className="flex justify-between border-b border-slate-800 pb-1.5">
                  <span className="text-slate-400">ENVIRONMENT</span>
                  <span className="font-semibold text-emerald-400">DEVELOPMENT</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">DB SOURCE</span>
                  <span className="font-semibold text-indigo-400 truncate max-w-[120px]">FIRESTORE</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right Side: Details Screen */}
        <div className="md:col-span-2 space-y-6">
          {/* Admin Profile Details */}
          <div className="bg-white p-6 rounded-2xl border border-slate-150 shadow-xs">
            <h3 className="font-display font-semibold text-slate-900 text-sm mb-4">Administrator Information</h3>
            <form onSubmit={handleUpdate} className="space-y-4">
              {statusMessage && (
                <div className={`p-3 rounded-xl text-xs font-semibold border ${
                  statusMessage.includes("success") 
                    ? "bg-emerald-50 text-emerald-700 border-emerald-100" 
                    : "bg-rose-50 text-rose-700 border-rose-100"
                }`}>
                  {statusMessage}
                </div>
              )}

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Sign-in Email (ReadOnly)</label>
                <input
                  type="email"
                  readOnly
                  value={adminEmail || "admin@transport.com"}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-slate-50 font-mono text-slate-400 focus:outline-none"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Display Name</label>
                <input
                  type="text"
                  required
                  placeholder="Administrator Display Name"
                  value={nameInput}
                  onChange={(e) => setNameInput(e.target.value)}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-display"
                />
              </div>

              <div className="pt-2">
                <button
                  type="submit"
                  disabled={isUpdating}
                  className="flex items-center justify-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all disabled:opacity-50"
                >
                  {isUpdating ? <RefreshCw className="h-3.5 w-3.5 animate-spin" /> : null}
                  <span>Save Profile Details</span>
                </button>
              </div>
            </form>
          </div>

          {/* Change Password Placeholder Security */}
          <div className="bg-white p-6 rounded-2xl border border-slate-150 shadow-xs">
            <div className="flex gap-4">
              <div className="p-3 bg-indigo-50 text-indigo-600 rounded-xl shrink-0 h-fit">
                <Shield className="h-5 w-5" />
              </div>
              <div>
                <h4 className="text-slate-900 font-semibold text-sm font-display">Credential Integrity</h4>
                <p className="text-slate-500 text-xs mt-1 leading-relaxed">
                  Authentication is managed directly via Google Firebase Authentication. To perform password resets, please consult your cloud console or submit a request to the server administrator.
                </p>
                <button
                  disabled
                  className="mt-4 px-4 py-2 bg-slate-100 text-slate-400 rounded-xl text-xs font-semibold border border-slate-200 cursor-not-allowed"
                >
                  Submit Password Reset Flow
                </button>
              </div>
            </div>
          </div>

        </div>

      </div>
    </div>
  );
}
