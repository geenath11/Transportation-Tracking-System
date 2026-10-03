import React, { useState } from "react";
import { Search, Plus, Edit, Trash2, ArrowUpDown, Filter, MapPin, Milestone, Clock } from "lucide-react";
import { Route, RouteStop } from "../types";

interface RoutesProps {
  routes: Route[];
  onCreate: (data: Route) => any;
  onUpdate: (id: string, data: Route) => any;
  onDelete: (id: string) => any;
}

export default function Routes({ routes, onCreate, onUpdate, onDelete }: RoutesProps) {
  const [search, setSearch] = useState("");
  const [sortField, setSortField] = useState<keyof Route>("routeNumber");
  const [sortAsc, setSortAsc] = useState(true);

  // Form / Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingRoute, setEditingRoute] = useState<Route | null>(null);
  const [formData, setFormData] = useState<Route>({
    routeNumber: "",
    start: "",
    destination: "",
    distance: 50,
    stops: []
  });
  
  // Stop sub-form state
  const [newStopName, setNewStopName] = useState("");
  const [newStopEta, setNewStopEta] = useState("");
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
    setFormData({ routeNumber: "", start: "", destination: "", distance: 50, stops: [] });
    setNewStopName("");
    setNewStopEta("");
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleOpenEdit = (r: Route) => {
    setEditingRoute(r);
    setFormData({
      routeNumber: r.routeNumber,
      start: r.start,
      destination: r.destination,
      distance: r.distance,
      stops: r.stops || []
    });
    setNewStopName("");
    setNewStopEta("");
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleAddStop = () => {
    if (!newStopName.trim() || !newStopEta.trim()) {
      return;
    }
    const updatedStops = [...formData.stops, { name: newStopName.trim(), eta: newStopEta.trim() }];
    setFormData({ ...formData, stops: updatedStops });
    setNewStopName("");
    setNewStopEta("");
  };

  const handleRemoveStop = (idx: number) => {
    const updatedStops = formData.stops.filter((_, i) => i !== idx);
    setFormData({ ...formData, stops: updatedStops });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg("");

    if (!formData.routeNumber.trim() || !formData.start.trim() || !formData.destination.trim() || formData.distance <= 0) {
      setErrorMsg("Please complete all basic fields correctly.");
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
      setErrorMsg("Failed to save route. Try again.");
    }
  };

  const filteredRoutes = routes
    .filter(r => {
      const matchSearch = r.routeNumber.toLowerCase().includes(search.toLowerCase()) || 
                          r.start.toLowerCase().includes(search.toLowerCase()) ||
                          r.destination.toLowerCase().includes(search.toLowerCase());
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
  const paginatedRoutes = filteredRoutes.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  return (
    <div className="space-y-6">
      {/* Top Search bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
        <div className="flex flex-1 items-center gap-3 max-w-lg">
          <div className="relative flex-1">
            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search route number, origin, destination..."
              value={search}
              onChange={(e) => { setSearch(e.target.value); setCurrentPage(1); }}
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

      {/* Routes Grid layout for better stop visualisation */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {paginatedRoutes.map((route) => (
          <div key={route.id} className="bg-white border border-slate-150 rounded-2xl p-5 shadow-xs flex flex-col justify-between group hover:border-slate-300 transition-all">
            <div>
              {/* Header */}
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <span className="px-2.5 py-1 bg-slate-900 text-white font-mono font-bold rounded-lg text-xs">
                    Route {route.routeNumber}
                  </span>
                  <div className="flex items-center gap-1 text-[10px] text-slate-500 font-mono">
                    <Milestone className="h-3 w-3 text-slate-400" />
                    <span>{route.distance} km</span>
                  </div>
                </div>
                <div className="space-x-1 opacity-0 group-hover:opacity-100 transition-all">
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

              {/* Journey details */}
              <div className="mt-4 flex items-center justify-between bg-slate-50 p-3 rounded-xl border border-slate-100">
                <div>
                  <p className="text-[10px] text-slate-400 font-medium">ORIGIN</p>
                  <p className="text-xs font-bold text-slate-800">{route.start}</p>
                </div>
                <span className="text-slate-300 font-mono">⟶</span>
                <div className="text-right">
                  <p className="text-[10px] text-slate-400 font-medium">DESTINATION</p>
                  <p className="text-xs font-bold text-slate-800">{route.destination}</p>
                </div>
              </div>

              {/* Transit Stops visual track */}
              <div className="mt-5">
                <p className="text-[11px] font-semibold text-slate-700 font-display mb-2 flex items-center gap-1">
                  <MapPin className="h-3.5 w-3.5 text-indigo-500" />
                  Transit Stops & arrival schedules
                </p>
                <div className="space-y-3 relative border-l border-indigo-100 pl-3.5 ml-2 mt-3 text-xs">
                  {route.stops && route.stops.map((stop, idx) => (
                    <div key={idx} className="relative">
                      {/* Node point */}
                      <span className="absolute -left-[18.5px] top-1 h-2.5 w-2.5 rounded-full bg-indigo-500 border-2 border-white ring-2 ring-indigo-50" />
                      <div className="flex items-center justify-between">
                        <span className="font-semibold text-slate-800">{stop.name}</span>
                        <span className="text-[10px] text-slate-500 font-mono flex items-center gap-0.5">
                          <Clock className="h-3 w-3 text-slate-400" />
                          {stop.eta}
                        </span>
                      </div>
                    </div>
                  ))}
                  {(!route.stops || route.stops.length === 0) && (
                    <p className="text-[10px] text-slate-400 font-mono">No stops declared.</p>
                  )}
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
            Showing {(currentPage - 1) * itemsPerPage + 1} to {Math.min(currentPage * itemsPerPage, filteredRoutes.length)} of {filteredRoutes.length} routes
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
      )}

      {/* Route Creator/Editor Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <form onSubmit={handleSubmit} className="w-full max-w-lg bg-white rounded-2xl shadow-xl border border-slate-100 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="px-6 py-4 border-b border-slate-100 flex items-center justify-between">
              <h3 className="font-display font-semibold text-slate-900 text-sm">
                {editingRoute ? "Modify Route Parameters" : "Create Transport Route"}
              </h3>
              <button type="button" onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-600">✕</button>
            </div>
            <div className="p-6 space-y-4 max-h-[480px] overflow-y-auto">
              {errorMsg && (
                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">{errorMsg}</div>
              )}
              
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Route Number</label>
                  <input
                    type="text"
                    required
                    placeholder="e.g. EX-01"
                    value={formData.routeNumber}
                    onChange={(e) => setFormData({ ...formData, routeNumber: e.target.value })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Distance (km)</label>
                  <input
                    type="number"
                    required
                    min={1}
                    value={formData.distance}
                    onChange={(e) => setFormData({ ...formData, distance: parseInt(e.target.value) || 0 })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Origin Start</label>
                  <input
                    type="text"
                    required
                    placeholder="Colombo"
                    value={formData.start}
                    onChange={(e) => setFormData({ ...formData, start: e.target.value })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Destination Terminal</label>
                  <input
                    type="text"
                    required
                    placeholder="Kandy"
                    value={formData.destination}
                    onChange={(e) => setFormData({ ...formData, destination: e.target.value })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>
              </div>

              {/* Dynamic Stop adding interface */}
              <div className="border-t border-slate-100 pt-4 mt-2">
                <label className="text-xs font-bold text-slate-800 block mb-2">Transit Stops & Arrival Timings</label>
                
                {/* Visual table of entered stops */}
                {formData.stops.length > 0 && (
                  <div className="space-y-2 mb-3 max-h-[140px] overflow-y-auto bg-slate-50 p-2.5 rounded-xl border border-slate-100">
                    {formData.stops.map((stop, idx) => (
                      <div key={idx} className="flex items-center justify-between text-xs bg-white py-1.5 px-3 rounded-lg border border-slate-150">
                        <div className="flex items-center gap-2">
                          <span className="font-mono text-[9px] text-indigo-600 bg-indigo-50 h-5 w-5 rounded-md flex items-center justify-center font-bold">{idx + 1}</span>
                          <span className="font-semibold text-slate-700">{stop.name}</span>
                        </div>
                        <div className="flex items-center gap-3">
                          <span className="text-slate-500 font-mono text-[10px]">{stop.eta}</span>
                          <button
                            type="button"
                            onClick={() => handleRemoveStop(idx)}
                            className="text-rose-500 hover:text-rose-700 font-semibold"
                          >
                            ✕
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                )}

                {/* Adding form */}
                <div className="flex gap-2.5 items-end">
                  <div className="flex-1 space-y-1">
                    <input
                      type="text"
                      placeholder="Stop name (e.g. Kegalle)"
                      value={newStopName}
                      onChange={(e) => setNewStopName(e.target.value)}
                      className="w-full px-3 py-1.5 text-xs border border-slate-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-indigo-500"
                    />
                  </div>
                  <div className="w-1/3 space-y-1">
                    <input
                      type="text"
                      placeholder="ETA (e.g. 1h 20m)"
                      value={newStopEta}
                      onChange={(e) => setNewStopEta(e.target.value)}
                      className="w-full px-3 py-1.5 text-xs border border-slate-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-indigo-500"
                    />
                  </div>
                  <button
                    type="button"
                    onClick={handleAddStop}
                    className="px-3 py-2 bg-indigo-50 hover:bg-indigo-100 text-indigo-600 font-bold text-xs rounded-lg border border-indigo-150"
                  >
                    Add
                  </button>
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
                {editingRoute ? "Save Route" : "Create"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
