import React, { useState } from "react";
import {
  Search,
  Plus,
  Edit,
  Trash2,
  Milestone,
  Clock,
  Bus,
  MapPin,
} from "lucide-react";
import { Route } from "../types";

interface RoutesProps {
  routes: Route[];
  onCreate: (data: Route) => Promise<void>;
  onUpdate: (id: string, data: Route) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
}

export default function Routes({
  routes,
  onCreate,
  onUpdate,
  onDelete,
}: RoutesProps) {
  const [search, setSearch] = useState("");
  const [sortField, setSortField] = useState<keyof Route>("route");
  const [sortAsc, setSortAsc] = useState(true);

  // Form / Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingRoute, setEditingRoute] = useState<Route | null>(null);

  const [formData, setFormData] = useState<Route>({
    route: "",
    departureCity: "",
    arrivalCity: "",
    departureTime: "",
    arrivalTime: "",
    busType: "",
    serviceName: "",
    distanceKm: 0,
    duration: "",
  });

  const [errorMsg, setErrorMsg] = useState("");

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 6;

  const handleSort = (field: keyof Route) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  const handleOpenAdd = () => {
    setEditingRoute(null);

    setFormData({
      route: "",
      departureCity: "",
      arrivalCity: "",
      departureTime: "",
      arrivalTime: "",
      busType: "",
      serviceName: "",
      distanceKm: 0,
      duration: "",
    });

    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleOpenEdit = (route: Route) => {
    setEditingRoute(route);

    setFormData({
      route: route.route,
      departureCity: route.departureCity,
      arrivalCity: route.arrivalCity,
      departureTime: route.departureTime,
      arrivalTime: route.arrivalTime,
      busType: route.busType,
      serviceName: route.serviceName,
      distanceKm: route.distanceKm,
      duration: route.duration,
    });

    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg("");

    if (
      !formData.route.trim() ||
      !formData.departureCity.trim() ||
      !formData.arrivalCity.trim() ||
      !formData.departureTime.trim() ||
      !formData.arrivalTime.trim() ||
      !formData.busType.trim() ||
      !formData.serviceName.trim() ||
      formData.distanceKm <= 0 ||
      !formData.duration.trim()
    ) {
      setErrorMsg("Please complete all fields correctly.");
      return;
    }

    try {
      if (editingRoute?.id) {
        await onUpdate(editingRoute.id, formData);
      } else {
        await onCreate(formData);
      }

      setIsModalOpen(false);
    } catch (err) {
      console.error(err);
      setErrorMsg("Failed to save route. Try again.");
    }
  };

  const filteredRoutes = routes
    .filter((route) => {
      const searchValue = search.toLowerCase();

      const matchSearch =
        route.route.toLowerCase().includes(searchValue) ||
        route.departureCity.toLowerCase().includes(searchValue) ||
        route.arrivalCity.toLowerCase().includes(searchValue) ||
        route.busType.toLowerCase().includes(searchValue) ||
        route.serviceName.toLowerCase().includes(searchValue);

      return matchSearch;
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

  const totalPages = Math.ceil(filteredRoutes.length / itemsPerPage) || 1;

  const paginatedRoutes = filteredRoutes.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage
  );

  return (
    <div className="space-y-6">
      {/* Top Search Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
        <div className="flex flex-1 items-center gap-3 max-w-lg">
          <div className="relative flex-1">
            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />

            <input
              type="text"
              placeholder="Search route, city, bus type, service..."
              value={search}
              onChange={(e) => {
                setSearch(e.target.value);
                setCurrentPage(1);
              }}
              className="w-full pl-9 pr-4 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 text-slate-700"
            />
          </div>
        </div>

        <button
          onClick={handleOpenAdd}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all self-start sm:self-auto"
        >
          <Plus className="h-4 w-4" />
          <span>Create Route</span>
        </button>
      </div>

      {/* Routes Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {paginatedRoutes.map((route) => (
          <div
            key={route.id}
            className="bg-white border border-slate-150 rounded-2xl p-5 shadow-xs flex flex-col justify-between group hover:border-slate-300 transition-all"
          >
            <div>
              {/* Header */}
              <div className="flex items-start justify-between gap-3">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    <span className="px-2.5 py-1 bg-slate-900 text-white font-mono font-bold rounded-lg text-xs">
                      Route
                    </span>

                    <div className="flex items-center gap-1 text-[10px] text-slate-500 font-mono">
                      <Milestone className="h-3 w-3 text-slate-400" />
                      <span>{route.distanceKm} km</span>
                    </div>

                    <div className="flex items-center gap-1 text-[10px] text-slate-500 font-mono">
                      <Clock className="h-3 w-3 text-slate-400" />
                      <span>{route.duration}</span>
                    </div>
                  </div>

                  <h3 className="mt-2 text-sm font-bold text-slate-900 truncate">
                    {route.serviceName}
                  </h3>

                  <p className="text-[10px] text-slate-500 font-mono mt-1 truncate">
                    {route.route}
                  </p>
                </div>

                <div className="space-x-1 opacity-0 group-hover:opacity-100 transition-all shrink-0">
                  <button
                    onClick={() => handleOpenEdit(route)}
                    className="p-1.5 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-50 inline-flex"
                  >
                    <Edit className="h-4 w-4" />
                  </button>

                  <button
                    onClick={() => route.id && onDelete(route.id)}
                    className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-50 inline-flex"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>

              {/* Journey Details */}
              <div className="mt-4 bg-slate-50 p-3 rounded-xl border border-slate-100">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-[10px] text-slate-400 font-medium">
                      DEPARTURE
                    </p>

                    <div className="flex items-center gap-1.5 mt-1">
                      <MapPin className="h-3.5 w-3.5 text-indigo-500" />

                      <p className="text-xs font-bold text-slate-800">
                        {route.departureCity}
                      </p>
                    </div>

                    <p className="text-[10px] text-slate-500 font-mono mt-1">
                      {route.departureTime}
                    </p>
                  </div>

                  <span className="text-slate-300 font-mono text-lg">⟶</span>

                  <div className="text-right">
                    <p className="text-[10px] text-slate-400 font-medium">
                      ARRIVAL
                    </p>

                    <div className="flex items-center justify-end gap-1.5 mt-1">
                      <p className="text-xs font-bold text-slate-800">
                        {route.arrivalCity}
                      </p>

                      <MapPin className="h-3.5 w-3.5 text-indigo-500" />
                    </div>

                    <p className="text-[10px] text-slate-500 font-mono mt-1">
                      {route.arrivalTime}
                    </p>
                  </div>
                </div>
              </div>

              {/* Service Details */}
              <div className="mt-4 grid grid-cols-2 gap-3">
                <div className="bg-white border border-slate-100 rounded-xl p-3">
                  <div className="flex items-center gap-1.5">
                    <Bus className="h-3.5 w-3.5 text-indigo-500" />

                    <p className="text-[10px] text-slate-400 font-medium">
                      BUS TYPE
                    </p>
                  </div>

                  <p className="text-xs font-semibold text-slate-800 mt-1">
                    {route.busType}
                  </p>
                </div>

                <div className="bg-white border border-slate-100 rounded-xl p-3">
                  <div className="flex items-center gap-1.5">
                    <Clock className="h-3.5 w-3.5 text-indigo-500" />

                    <p className="text-[10px] text-slate-400 font-medium">
                      DURATION
                    </p>
                  </div>

                  <p className="text-xs font-semibold text-slate-800 mt-1">
                    {route.duration}
                  </p>
                </div>
              </div>
            </div>
          </div>
        ))}

        {filteredRoutes.length === 0 && (
          <div className="col-span-1 md:col-span-2 bg-white p-12 text-center text-slate-400 font-mono rounded-2xl border border-slate-150">
            No transit routes created.
          </div>
        )}
      </div>

      {/* Pagination Footer */}
      {filteredRoutes.length > 0 && (
        <div className="bg-white px-6 py-4 border border-slate-150 rounded-2xl flex items-center justify-between shadow-xs">
          <p className="text-slate-500 text-xs font-medium">
            Showing {(currentPage - 1) * itemsPerPage + 1} to{" "}
            {Math.min(currentPage * itemsPerPage, filteredRoutes.length)} of{" "}
            {filteredRoutes.length} routes
          </p>

          <div className="flex items-center gap-2">
            <button
              onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
              disabled={currentPage === 1}
              className="px-3 py-1.5 text-xs font-semibold border border-slate-200 rounded-xl hover:bg-slate-50 disabled:opacity-50 disabled:pointer-events-none transition-all"
            >
              Previous
            </button>

            <span className="text-xs font-semibold text-slate-700 px-2 font-mono">
              {currentPage} / {totalPages}
            </span>

            <button
              onClick={() =>
                setCurrentPage((prev) => Math.min(prev + 1, totalPages))
              }
              disabled={currentPage === totalPages}
              className="px-3 py-1.5 text-xs font-semibold border border-slate-200 rounded-xl hover:bg-slate-50 disabled:opacity-50 disabled:pointer-events-none transition-all"
            >
              Next
            </button>
          </div>
        </div>
      )}

      {/* Route Creator / Editor Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <form
            onSubmit={handleSubmit}
            className="w-full max-w-lg bg-white rounded-2xl shadow-xl border border-slate-100 overflow-hidden animate-in fade-in zoom-in-95 duration-200"
          >
            {/* Modal Header */}
            <div className="px-6 py-4 border-b border-slate-100 flex items-center justify-between">
              <h3 className="font-display font-semibold text-slate-900 text-sm">
                {editingRoute
                  ? "Modify Route Parameters"
                  : "Create Transport Route"}
              </h3>

              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="text-slate-400 hover:text-slate-600"
              >
                ✕
              </button>
            </div>

            {/* Modal Body */}
            <div className="p-6 space-y-4 max-h-[520px] overflow-y-auto">
              {errorMsg && (
                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">
                  {errorMsg}
                </div>
              )}

              {/* Service Name */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">
                  Service Name
                </label>

                <input
                  type="text"
                  required
                  placeholder="e.g. Private Semi Luxury B3"
                  value={formData.serviceName}
                  onChange={(e) =>
                    setFormData({
                      ...formData,
                      serviceName: e.target.value,
                    })
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>

              {/* Route */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">
                  Route
                </label>

                <input
                  type="text"
                  required
                  placeholder="e.g. Badulla - Bandarawela - Beragala - Ratnapura - Colombo"
                  value={formData.route}
                  onChange={(e) =>
                    setFormData({
                      ...formData,
                      route: e.target.value,
                    })
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>

              {/* Departure / Arrival Cities */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">
                    Departure City
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="Badulla"
                    value={formData.departureCity}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        departureCity: e.target.value,
                      })
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">
                    Arrival City
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="Colombo"
                    value={formData.arrivalCity}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        arrivalCity: e.target.value,
                      })
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>
              </div>

              {/* Departure / Arrival Time */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">
                    Departure Time
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. 01:45 AM"
                    value={formData.departureTime}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        departureTime: e.target.value,
                      })
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">
                    Arrival Time
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. 09:15 AM"
                    value={formData.arrivalTime}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        arrivalTime: e.target.value,
                      })
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
              </div>

              {/* Bus Type / Distance */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">
                    Bus Type
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. Semi Luxury"
                    value={formData.busType}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        busType: e.target.value,
                      })
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">
                    Distance (km)
                  </label>

                  <input
                    type="number"
                    required
                    min={1}
                    value={formData.distanceKm}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        distanceKm: parseInt(e.target.value) || 0,
                      })
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
              </div>

              {/* Duration */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">
                  Duration
                </label>

                <input
                  type="text"
                  required
                  placeholder="e.g. 7h 30m"
                  value={formData.duration}
                  onChange={(e) =>
                    setFormData({
                      ...formData,
                      duration: e.target.value,
                    })
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                />
              </div>
            </div>

            {/* Modal Footer */}
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
                {editingRoute ? "Save Route" : "Create"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
