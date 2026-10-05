import React, { useState } from "react";
import { Search, Plus, Edit, Trash2, ArrowUpDown, Filter, Calendar } from "lucide-react";
import { Timetable, Route as TransitRoute, Vehicle, Driver } from "../types";

interface TimetablesProps {
  timetables: Timetable[];
  routes: TransitRoute[];
  vehicles: Vehicle[];
  drivers: Driver[];
  onCreate: (data: Timetable) => any;
  onUpdate: (id: string, data: Timetable) => any;
  onDelete: (id: string) => any;
}

export default function Timetables({
  timetables,
  routes,
  vehicles,
  drivers,
  onCreate,
  onUpdate,
  onDelete
}: TimetablesProps) {
  const [search, setSearch] = useState("");
  const [routeFilter, setRouteFilter] = useState<string>("All");
  const [sortField, setSortField] = useState<keyof Timetable>("departureTime");
  const [sortAsc, setSortAsc] = useState(true);

  // Form State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingTimetable, setEditingTimetable] = useState<Timetable | null>(null);
  const [formData, setFormData] = useState<Timetable>({
    routeId: "",
    routeNumber: "",
    vehicleId: "",
    vehicleNumber: "",
    driverId: "",
    driverName: "",
    departureTime: "",
    arrivalTime: ""
  });
  const [errorMsg, setErrorMsg] = useState("");

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  const handleSort = (field: keyof Timetable) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  const handleOpenAdd = () => {
    setEditingTimetable(null);
    setFormData({
      routeId: routes[0]?.id || "",
      routeNumber: routes[0]?.routeNumber || "",
      vehicleId: vehicles[0]?.id || "",
      vehicleNumber: vehicles[0]?.vehicleNumber || "",
      driverId: drivers[0]?.id || "",
      driverName: drivers[0]?.name || "",
      departureTime: "08:00 AM",
      arrivalTime: "11:00 AM"
    });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleOpenEdit = (t: Timetable) => {
    setEditingTimetable(t);
    setFormData({
      routeId: t.routeId,
      routeNumber: t.routeNumber,
      vehicleId: t.vehicleId,
      vehicleNumber: t.vehicleNumber,
      driverId: t.driverId,
      driverName: t.driverName,
      departureTime: t.departureTime,
      arrivalTime: t.arrivalTime
    });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleRouteChange = (routeId: string) => {
    const selectedRoute = routes.find(r => r.id === routeId);
    if (selectedRoute) {
      setFormData({
        ...formData,
        routeId,
        routeNumber: selectedRoute.routeNumber
      });
    }
  };

  const handleVehicleChange = (vehicleId: string) => {
    const selectedVehicle = vehicles.find(v => v.id === vehicleId);
    if (selectedVehicle) {
      setFormData({
        ...formData,
        vehicleId,
        vehicleNumber: selectedVehicle.vehicleNumber
      });
    }
  };

  const handleDriverChange = (driverId: string) => {
    const selectedDriver = drivers.find(d => d.id === driverId);
    if (selectedDriver) {
      setFormData({
        ...formData,
        driverId,
        driverName: selectedDriver.name
      });
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg("");

    if (!formData.routeNumber || !formData.vehicleNumber || !formData.driverName || !formData.departureTime || !formData.arrivalTime) {
      setErrorMsg("All dropdown allocations and timings must be selected.");
      return;
    }

    try {
      if (editingTimetable?.id) {
        await onUpdate(editingTimetable.id, formData);
      } else {
        await onCreate(formData);
      }
      setIsModalOpen(false);
    } catch (err) {
      setErrorMsg("Failed to assign schedule.");
    }
  };

  const filteredTimetables = timetables
    .filter(t => {
      const matchSearch = t.routeNumber.toLowerCase().includes(search.toLowerCase()) || 
                          t.vehicleNumber.toLowerCase().includes(search.toLowerCase()) ||
                          t.driverName.toLowerCase().includes(search.toLowerCase());
      const matchRoute = routeFilter === "All" || t.routeNumber === routeFilter;
      return matchSearch && matchRoute;
    })
    .sort((a, b) => {
      const valA = (a[sortField] || "").toString().toLowerCase();
      const valB = (b[sortField] || "").toString().toLowerCase();
      if (valA < valB) return sortAsc ? -1 : 1;
      if (valA > valB) return sortAsc ? 1 : -1;
      return 0;
    });

  const totalPages = Math.ceil(filteredTimetables.length / itemsPerPage) || 1;
  const paginatedTimetables = filteredTimetables.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  return (
    <div className="space-y-6">
      {/* Search and filter bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
        <div className="flex flex-1 items-center gap-3 max-w-lg">
          <div className="relative flex-1">
            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search timetable by driver, bus, or route..."
              value={search}
              onChange={(e) => { setSearch(e.target.value); setCurrentPage(1); }}
              className="w-full pl-9 pr-4 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 text-slate-700"
            />
          </div>
          <div className="flex items-center gap-2">
            <Filter className="h-3.5 w-3.5 text-slate-400" />
            <select
              value={routeFilter}
              onChange={(e) => { setRouteFilter(e.target.value); setCurrentPage(1); }}
              className="text-xs bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-slate-600 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="All">All Routes</option>
              {routes.map(r => (
                <option key={r.id} value={r.routeNumber}>Route {r.routeNumber}</option>
              ))}
            </select>
          </div>
        </div>

        <button
          onClick={handleOpenAdd}
          disabled={routes.length === 0 || vehicles.length === 0 || drivers.length === 0}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all self-start sm:self-auto disabled:opacity-50 disabled:pointer-events-none"
          title={routes.length === 0 || vehicles.length === 0 || drivers.length === 0 ? "You must have at least one route, vehicle, and driver registered first" : ""}
        >
          <Plus className="h-4 w-4" />
          <span>Allocate Schedule</span>
        </button>
      </div>

      {/* Roster list / Table */}
      <div className="bg-white rounded-2xl border border-slate-150 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-50 text-slate-500 text-xs font-semibold border-b border-slate-150">
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("routeNumber")}>
                  <div className="flex items-center gap-1.5">
                    <span>Active Route</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("vehicleNumber")}>
                  <div className="flex items-center gap-1.5">
                    <span>Vehicle</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("driverName")}>
                  <div className="flex items-center gap-1.5">
                    <span>Driver allocated</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("departureTime")}>
                  <div className="flex items-center gap-1.5">
                    <span>Departure Time</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("arrivalTime")}>
                  <div className="flex items-center gap-1.5">
                    <span>Arrival Est.</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 text-xs text-slate-600">
              {paginatedTimetables.map((t) => (
                <tr key={t.id} className="hover:bg-slate-50/40 transition-all">
                  <td className="py-3.5 px-6">
                    <span className="px-2 py-0.5 bg-slate-900 text-white font-mono font-bold rounded-md text-[10px]">
                      Route {t.routeNumber}
                    </span>
                  </td>
                  <td className="py-3.5 px-6 font-semibold text-slate-700 font-mono">{t.vehicleNumber}</td>
                  <td className="py-3.5 px-6 font-semibold text-slate-800">{t.driverName}</td>
                  <td className="py-3.5 px-6 text-indigo-600 font-medium font-mono">{t.departureTime}</td>
                  <td className="py-3.5 px-6 text-slate-500 font-medium font-mono">{t.arrivalTime}</td>
                  <td className="py-3.5 px-6 text-right space-x-2">
                    <button
                      onClick={() => handleOpenEdit(t)}
                      className="p-1.5 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                    >
                      <Edit className="h-4 w-4" />
                    </button>
                    <button
                      onClick={() => t.id && onDelete(t.id)}
                      className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </td>
                </tr>
              ))}
              {paginatedTimetables.length === 0 && (
                <tr>
                  <td colSpan={6} className="py-12 text-center text-slate-400 font-mono">
                    No allocated bus schedules found.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="px-6 py-4 border-t border-slate-100 flex items-center justify-between">
          <p className="text-slate-500 text-xs font-medium">
            Showing {(currentPage - 1) * itemsPerPage + 1} to {Math.min(currentPage * itemsPerPage, filteredTimetables.length)} of {filteredTimetables.length} schedules
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
                {editingTimetable ? "Edit Scheduled Allocation" : "Allocate Transit Schedule"}
              </h3>
              <button type="button" onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-600">✕</button>
            </div>
            <div className="p-6 space-y-4">
              {errorMsg && (
                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">{errorMsg}</div>
              )}

              {/* Route Selector */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Select Active Route</label>
                <select
                  value={formData.routeId}
                  onChange={(e) => handleRouteChange(e.target.value)}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  {routes.map(r => (
                    <option key={r.id} value={r.id}>Route {r.routeNumber} ({r.start} - {r.destination})</option>
                  ))}
                </select>
              </div>

              {/* Vehicle Selector */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Assign Fleet Vehicle</label>
                <select
                  value={formData.vehicleId}
                  onChange={(e) => handleVehicleChange(e.target.value)}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  {vehicles.map(v => (
                    <option key={v.id} value={v.id}>{v.vehicleNumber} ({v.vehicleType})</option>
                  ))}
                </select>
              </div>

              {/* Driver Selector */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Assign Active Driver</label>
                <select
                  value={formData.driverId}
                  onChange={(e) => handleDriverChange(e.target.value)}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  {drivers.map(d => (
                    <option key={d.id} value={d.id}>{d.name} ({d.phoneNumber})</option>
                  ))}
                </select>
              </div>

              {/* Timings */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Departure Time</label>
                  <input
                    type="text"
                    required
                    placeholder="e.g. 08:30 AM"
                    value={formData.departureTime}
                    onChange={(e) => setFormData({ ...formData, departureTime: e.target.value })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Arrival Time Est.</label>
                  <input
                    type="text"
                    required
                    placeholder="e.g. 11:30 AM"
                    value={formData.arrivalTime}
                    onChange={(e) => setFormData({ ...formData, arrivalTime: e.target.value })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
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
                {editingTimetable ? "Save Changes" : "Assign"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
