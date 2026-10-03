import React, { useState } from "react";
import { Search, Plus, Edit, Trash2, ArrowUpDown, Filter, Gauge } from "lucide-react";
import { Vehicle, VehicleStatus } from "../types";

interface VehiclesProps {
  vehicles: Vehicle[];
  onCreate: (data: Vehicle) => any;
  onUpdate: (id: string, data: Vehicle) => any;
  onDelete: (id: string) => any;
}

export default function Vehicles({ vehicles, onCreate, onUpdate, onDelete }: VehiclesProps) {
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<string>("All");
  const [sortField, setSortField] = useState<keyof Vehicle>("vehicleNumber");
  const [sortAsc, setSortAsc] = useState(true);

  // Form State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingVehicle, setEditingVehicle] = useState<Vehicle | null>(null);
  const [formData, setFormData] = useState<Vehicle>({
    vehicleNumber: "",
    vehicleType: "",
    capacity: 40,
    status: "Stopped"
  });
  const [errorMsg, setErrorMsg] = useState("");

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  const handleSort = (field: keyof Vehicle) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  const handleOpenAdd = () => {
    setEditingVehicle(null);
    setFormData({ vehicleNumber: "", vehicleType: "", capacity: 40, status: "Stopped" });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleOpenEdit = (v: Vehicle) => {
    setEditingVehicle(v);
    setFormData({
      vehicleNumber: v.vehicleNumber,
      vehicleType: v.vehicleType,
      capacity: v.capacity,
      status: v.status
    });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg("");

    if (!formData.vehicleNumber.trim() || !formData.vehicleType.trim() || formData.capacity <= 0) {
      setErrorMsg("Please enter valid parameters for all fields.");
      return;
    }

    try {
      if (editingVehicle?.id) {
        await onUpdate(editingVehicle.id, formData);
      } else {
        await onCreate(formData);
      }
      setIsModalOpen(false);
    } catch (err) {
      setErrorMsg("Could not save vehicle info.");
    }
  };

  const filteredVehicles = vehicles
    .filter(v => {
      const matchSearch = v.vehicleNumber.toLowerCase().includes(search.toLowerCase()) || 
                          v.vehicleType.toLowerCase().includes(search.toLowerCase());
      const matchStatus = statusFilter === "All" || v.status === statusFilter;
      return matchSearch && matchStatus;
    })
    .sort((a, b) => {
      let valA = a[sortField] || "";
      let valB = b[sortField] || "";
      if (typeof valA === "string" && typeof valB === "string") {
        valA = valA.toLowerCase();
        valB = valB.toLowerCase();
      }
      if (valA < valB) return sortAsc ? -1 : 1;
      if (valA > valB) return sortAsc ? 1 : -1;
      return 0;
    });

  const totalPages = Math.ceil(filteredVehicles.length / itemsPerPage) || 1;
  const paginatedVehicles = filteredVehicles.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  return (
    <div className="space-y-6">
      {/* Search Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
        <div className="flex flex-1 items-center gap-3 max-w-lg">
          <div className="relative flex-1">
            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search vehicle number, plate, type..."
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
              <option value="Running">Running</option>
              <option value="Stopped">Stopped</option>
              <option value="Maintenance">Maintenance</option>
            </select>
          </div>
        </div>

        <button
          onClick={handleOpenAdd}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all self-start sm:self-auto"
        >
          <Plus className="h-4 w-4" />
          <span>Add Fleet Vehicle</span>
        </button>
      </div>

      {/* Grid view of fleet items or standard Table */}
      <div className="bg-white rounded-2xl border border-slate-150 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-50 text-slate-500 text-xs font-semibold border-b border-slate-150">
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("vehicleNumber")}>
                  <div className="flex items-center gap-1.5">
                    <span>Vehicle Number</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("vehicleType")}>
                  <div className="flex items-center gap-1.5">
                    <span>Classification</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("capacity")}>
                  <div className="flex items-center gap-1.5">
                    <span>Seat Capacity</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("status")}>
                  <div className="flex items-center gap-1.5">
                    <span>Operating Status</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 text-xs text-slate-600">
              {paginatedVehicles.map((v) => (
                <tr key={v.id} className="hover:bg-slate-50/40 transition-all">
                  <td className="py-3.5 px-6 font-mono font-bold text-slate-900 text-sm">
                    {v.vehicleNumber}
                  </td>
                  <td className="py-3.5 px-6 font-medium text-slate-700">{v.vehicleType}</td>
                  <td className="py-3.5 px-6 font-mono text-slate-500">{v.capacity} Seats</td>
                  <td className="py-3.5 px-6">
                    <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-semibold border ${
                      v.status === "Running"
                        ? "bg-emerald-50 text-emerald-700 border-emerald-150"
                        : v.status === "Stopped"
                        ? "bg-rose-50 text-rose-700 border-rose-150"
                        : "bg-amber-50 text-amber-700 border-amber-150"
                    }`}>
                      <span className={`h-1 w-1 rounded-full ${
                        v.status === "Running" ? "bg-emerald-500" : v.status === "Stopped" ? "bg-rose-500" : "bg-amber-500"
                      }`} />
                      {v.status}
                    </span>
                  </td>
                  <td className="py-3.5 px-6 text-right space-x-2">
                    <button
                      onClick={() => handleOpenEdit(v)}
                      className="p-1.5 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                    >
                      <Edit className="h-4 w-4" />
                    </button>
                    <button
                      onClick={() => v.id && onDelete(v.id)}
                      className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </td>
                </tr>
              ))}
              {paginatedVehicles.length === 0 && (
                <tr>
                  <td colSpan={5} className="py-12 text-center text-slate-400 font-mono">
                    No fleet vehicles found.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="px-6 py-4 border-t border-slate-100 flex items-center justify-between">
          <p className="text-slate-500 text-xs font-medium">
            Showing {(currentPage - 1) * itemsPerPage + 1} to {Math.min(currentPage * itemsPerPage, filteredVehicles.length)} of {filteredVehicles.length} vehicles
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
                {editingVehicle ? "Modify Fleet Vehicle" : "Add Fleet Vehicle"}
              </h3>
              <button type="button" onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-600">✕</button>
            </div>
            <div className="p-6 space-y-4">
              {errorMsg && (
                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">{errorMsg}</div>
              )}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Vehicle Number / Plate</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. NB-2548"
                  value={formData.vehicleNumber}
                  onChange={(e) => setFormData({ ...formData, vehicleNumber: e.target.value })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Vehicle Classification / Type</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Luxury AC Coach, Mini Bus"
                  value={formData.vehicleType}
                  onChange={(e) => setFormData({ ...formData, vehicleType: e.target.value })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Passenger Seating Capacity</label>
                <input
                  type="number"
                  required
                  min={1}
                  value={formData.capacity}
                  onChange={(e) => setFormData({ ...formData, capacity: parseInt(e.target.value) || 0 })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Operating Status</label>
                <select
                  value={formData.status}
                  onChange={(e) => setFormData({ ...formData, status: e.target.value as VehicleStatus })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  <option value="Running">Running</option>
                  <option value="Stopped">Stopped</option>
                  <option value="Maintenance">Maintenance</option>
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
                {editingVehicle ? "Save Changes" : "Add Vehicle"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
