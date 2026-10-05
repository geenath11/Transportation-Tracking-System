import React, { useState } from "react";
import { Search, Plus, Edit, Trash2, ArrowUpDown, Filter } from "lucide-react";
import { Driver, DriverStatus } from "../types";

interface DriversProps {
  drivers: Driver[];
  onCreate: (data: Driver) => any;
  onUpdate: (id: string, data: Driver) => any;
  onDelete: (id: string) => any;
}

export default function Drivers({ drivers, onCreate, onUpdate, onDelete }: DriversProps) {
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<string>("All");
  const [sortField, setSortField] = useState<keyof Driver>("name");
  const [sortAsc, setSortAsc] = useState(true);

  // Modal / Form States
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingDriver, setEditingDriver] = useState<Driver | null>(null);
  const [formData, setFormData] = useState<Driver>({
    name: "",
    email: "",
    licenseNumber: "",
    phoneNumber: "",
    status: "Active"
  });
  const [errorMsg, setErrorMsg] = useState("");

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  const handleSort = (field: keyof Driver) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  const handleOpenAdd = () => {
    setEditingDriver(null);
    setFormData({ name: "", email: "", licenseNumber: "", phoneNumber: "", status: "Active" });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleOpenEdit = (driver: Driver) => {
    setEditingDriver(driver);
    setFormData({
      name: driver.name,
      email: driver.email,
      licenseNumber: driver.licenseNumber,
      phoneNumber: driver.phoneNumber,
      status: driver.status
    });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg("");

    if (!formData.name.trim() || !formData.email.trim() || !formData.licenseNumber.trim() || !formData.phoneNumber.trim()) {
      setErrorMsg("All fields are required.");
      return;
    }

    try {
      if (editingDriver?.id) {
        await onUpdate(editingDriver.id, formData);
      } else {
        await onCreate(formData);
      }
      setIsModalOpen(false);
    } catch (err) {
      setErrorMsg("Could not save driver. Try again.");
    }
  };

  // Filter & Sort
  const filteredDrivers = drivers
    .filter(d => {
      const matchSearch = d.name.toLowerCase().includes(search.toLowerCase()) || 
                          d.email.toLowerCase().includes(search.toLowerCase()) ||
                          d.licenseNumber.toLowerCase().includes(search.toLowerCase());
      const matchStatus = statusFilter === "All" || d.status === statusFilter;
      return matchSearch && matchStatus;
    })
    .sort((a, b) => {
      const valA = (a[sortField] || "").toString().toLowerCase();
      const valB = (b[sortField] || "").toString().toLowerCase();
      if (valA < valB) return sortAsc ? -1 : 1;
      if (valA > valB) return sortAsc ? 1 : -1;
      return 0;
    });

  const totalPages = Math.ceil(filteredDrivers.length / itemsPerPage) || 1;
  const paginatedDrivers = filteredDrivers.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  return (
    <div className="space-y-6">
      {/* Search & Actions */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
        <div className="flex flex-1 items-center gap-3 max-w-lg">
          <div className="relative flex-1">
            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search driver name, license, email..."
              value={search}
              onChange={(e) => { setSearch(e.target.value); setCurrentPage(1); }}
              className="w-full pl-9 pr-4 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 text-slate-700"
            />
          </div>
          <div className="flex items-center gap-2">
            <Filter className="h-3.5 w-3.5 text-slate-400" />
            <select
              value={statusFilter}
              onChange={(e) => { setStatusFilter(e.target.value); setCurrentPage(1); }}
              className="text-xs bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-slate-600 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="All">All Statuses</option>
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>
            </select>
          </div>
        </div>

        <button
          onClick={handleOpenAdd}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all self-start sm:self-auto"
        >
          <Plus className="h-4 w-4" />
          <span>Register Driver</span>
        </button>
      </div>

      {/* Table */}
      <div className="bg-white rounded-2xl border border-slate-150 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-50 text-slate-500 text-xs font-semibold border-b border-slate-150">
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("name")}>
                  <div className="flex items-center gap-1.5">
                    <span>Driver Name</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("licenseNumber")}>
                  <div className="flex items-center gap-1.5">
                    <span>License No.</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("phoneNumber")}>
                  <div className="flex items-center gap-1.5">
                    <span>Phone Number</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("status")}>
                  <div className="flex items-center gap-1.5">
                    <span>Status</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 text-xs text-slate-600">
              {paginatedDrivers.map((driver) => (
                <tr key={driver.id} className="hover:bg-slate-50/40 transition-all">
                  <td className="py-3.5 px-6">
                    <p className="font-semibold text-slate-900">{driver.name}</p>
                    <p className="text-[10px] text-slate-400 font-mono mt-0.5">{driver.email}</p>
                  </td>
                  <td className="py-3.5 px-6 font-mono font-medium text-slate-700">{driver.licenseNumber}</td>
                  <td className="py-3.5 px-6 text-slate-500 font-mono">{driver.phoneNumber}</td>
                  <td className="py-3.5 px-6">
                    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-semibold ${
                      driver.status === "Active" 
                        ? "bg-emerald-50 text-emerald-700 border border-emerald-100" 
                        : "bg-slate-100 text-slate-600 border border-slate-200"
                    }`}>
                      {driver.status}
                    </span>
                  </td>
                  <td className="py-3.5 px-6 text-right space-x-2">
                    <button
                      onClick={() => handleOpenEdit(driver)}
                      className="p-1.5 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                    >
                      <Edit className="h-4 w-4" />
                    </button>
                    <button
                      onClick={() => driver.id && onDelete(driver.id)}
                      className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </td>
                </tr>
              ))}
              {paginatedDrivers.length === 0 && (
                <tr>
                  <td colSpan={5} className="py-12 text-center text-slate-400 font-mono">
                    No drivers registered.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="px-6 py-4 border-t border-slate-100 flex items-center justify-between">
          <p className="text-slate-500 text-xs font-medium">
            Showing {(currentPage - 1) * itemsPerPage + 1} to {Math.min(currentPage * itemsPerPage, filteredDrivers.length)} of {filteredDrivers.length} drivers
          </p>
          <div className="flex items-center gap-2">
            <button
              onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
              disabled={currentPage === 1}
              className="px-3 py-1.5 text-xs font-semibold border border-slate-200 rounded-xl hover:bg-slate-50 disabled:opacity-50 disabled:pointer-events-none transition-all"
            >
              Previous
            </button>
            <span className="text-xs font-semibold text-slate-700 px-2 font-mono">
              {currentPage} / {totalPages}
            </span>
            <button
              onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
              disabled={currentPage === totalPages}
              className="px-3 py-1.5 text-xs font-semibold border border-slate-200 rounded-xl hover:bg-slate-50 disabled:opacity-50 disabled:pointer-events-none transition-all"
            >
              Next
            </button>
          </div>
        </div>
      </div>

      {/* Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <form onSubmit={handleSubmit} className="w-full max-w-md bg-white rounded-2xl shadow-xl border border-slate-100 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="px-6 py-4 border-b border-slate-100 flex items-center justify-between">
              <h3 className="font-display font-semibold text-slate-900 text-sm">
                {editingDriver ? "Edit Driver Record" : "Register Driver"}
              </h3>
              <button type="button" onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-600">✕</button>
            </div>
            <div className="p-6 space-y-4">
              {errorMsg && (
                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">{errorMsg}</div>
              )}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Driver Full Name</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Sunil Perera"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Email Address</label>
                <input
                  type="email"
                  required
                  placeholder="e.g. sunil@driver.com"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">License Number</label>
                  <input
                    type="text"
                    required
                    placeholder="e.g. DL-12345"
                    value={formData.licenseNumber}
                    onChange={(e) => setFormData({ ...formData, licenseNumber: e.target.value })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Phone Number</label>
                  <input
                    type="text"
                    required
                    placeholder="e.g. 071-1234567"
                    value={formData.phoneNumber}
                    onChange={(e) => setFormData({ ...formData, phoneNumber: e.target.value })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Roster Status</label>
                <select
                  value={formData.status}
                  onChange={(e) => setFormData({ ...formData, status: e.target.value as DriverStatus })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  <option value="Active">Active</option>
                  <option value="Inactive">Inactive</option>
                </select>
              </div>
            </div>
            <div className="px-6 py-4 bg-slate-50 border-t border-slate-100 flex justify-end gap-3">
              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="px-4 py-2 text-xs font-semibold text-slate-700 bg-white border border-slate-200 rounded-xl hover:bg-slate-50"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="px-4 py-2 text-xs font-semibold text-white bg-indigo-600 hover:bg-indigo-700 rounded-xl shadow-lg shadow-indigo-600/15"
              >
                {editingDriver ? "Save Changes" : "Register"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
