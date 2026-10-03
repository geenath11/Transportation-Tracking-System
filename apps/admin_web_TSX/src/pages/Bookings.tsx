import React, { useState } from "react";
import { Search, Plus, Edit, Trash2, ArrowUpDown, Filter } from "lucide-react";
import { Booking, BookingStatus } from "../types";

interface BookingsProps {
  bookings: Booking[];
  onCreate: (data: Booking) => any;
  onUpdate: (id: string, data: Booking) => any;
  onDelete: (id: string) => any;
}

export default function Bookings({ bookings, onCreate, onUpdate, onDelete }: BookingsProps) {
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<string>("All");
  const [sortField, setSortField] = useState<keyof Booking>("bookingId");
  const [sortAsc, setSortAsc] = useState(true);

  // Form / Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingBooking, setEditingBooking] = useState<Booking | null>(null);
  const [formData, setFormData] = useState<Booking>({
    bookingId: "",
    passengerName: "",
    routeNumber: "",
    seatNumber: "",
    status: "Pending"
  });
  const [errorMsg, setErrorMsg] = useState("");

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  const handleSort = (field: keyof Booking) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  const handleOpenAdd = () => {
    setEditingBooking(null);
    // Auto-generate booking ID
    const generatedId = `B-${Math.floor(1000 + Math.random() * 9000)}`;
    setFormData({ bookingId: generatedId, passengerName: "", routeNumber: "01", seatNumber: "A01", status: "Pending" });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleOpenEdit = (b: Booking) => {
    setEditingBooking(b);
    setFormData({
      bookingId: b.bookingId,
      passengerName: b.passengerName,
      routeNumber: b.routeNumber,
      seatNumber: b.seatNumber,
      status: b.status
    });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg("");

    if (!formData.bookingId.trim() || !formData.passengerName.trim() || !formData.routeNumber.trim() || !formData.seatNumber.trim()) {
      setErrorMsg("All booking parameters are required.");
      return;
    }

    try {
      if (editingBooking?.id) {
        await onUpdate(editingBooking.id, formData);
      } else {
        await onCreate(formData);
      }
      setIsModalOpen(false);
    } catch (err) {
      setErrorMsg("Failed to update booking status.");
    }
  };

  const filteredBookings = bookings
    .filter(b => {
      const matchSearch = b.bookingId.toLowerCase().includes(search.toLowerCase()) || 
                          b.passengerName.toLowerCase().includes(search.toLowerCase()) ||
                          b.routeNumber.toLowerCase().includes(search.toLowerCase());
      const matchStatus = statusFilter === "All" || b.status === statusFilter;
      return matchSearch && matchStatus;
    })
    .sort((a, b) => {
      const valA = (a[sortField] || "").toString().toLowerCase();
      const valB = (b[sortField] || "").toString().toLowerCase();
      if (valA < valB) return sortAsc ? -1 : 1;
      if (valA > valB) return sortAsc ? 1 : -1;
      return 0;
    });

  const totalPages = Math.ceil(filteredBookings.length / itemsPerPage) || 1;
  const paginatedBookings = filteredBookings.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  return (
    <div className="space-y-6">
      {/* Search Actions */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
        <div className="flex flex-1 items-center gap-3 max-w-lg">
          <div className="relative flex-1">
            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search booking ID, passenger name..."
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
              <option value="All">All Bookings</option>
              <option value="Confirmed">Confirmed</option>
              <option value="Pending">Pending</option>
              <option value="Cancelled">Cancelled</option>
            </select>
          </div>
        </div>

        <button
          onClick={handleOpenAdd}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all self-start sm:self-auto"
        >
          <Plus className="h-4 w-4" />
          <span>New Manual Booking</span>
        </button>
      </div>

      {/* Table */}
      <div className="bg-white rounded-2xl border border-slate-150 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-50 text-slate-500 text-xs font-semibold border-b border-slate-150">
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("bookingId")}>
                  <div className="flex items-center gap-1.5">
                    <span>Booking ID</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("passengerName")}>
                  <div className="flex items-center gap-1.5">
                    <span>Passenger Name</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("routeNumber")}>
                  <div className="flex items-center gap-1.5">
                    <span>Assigned Route</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("seatNumber")}>
                  <div className="flex items-center gap-1.5">
                    <span>Seat Assignment</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 cursor-pointer select-none" onClick={() => handleSort("status")}>
                  <div className="flex items-center gap-1.5">
                    <span>Booking Status</span>
                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>
                <th className="py-3.5 px-6 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 text-xs text-slate-600">
              {paginatedBookings.map((b) => (
                <tr key={b.id} className="hover:bg-slate-50/40 transition-all">
                  <td className="py-3.5 px-6 font-mono font-bold text-slate-900">{b.bookingId}</td>
                  <td className="py-3.5 px-6 font-semibold text-slate-800">{b.passengerName}</td>
                  <td className="py-3.5 px-6 text-slate-500">Route {b.routeNumber}</td>
                  <td className="py-3.5 px-6 font-mono font-semibold text-indigo-600 bg-indigo-50/30 px-2 py-0.5 rounded-md inline-block mt-3 ml-6">{b.seatNumber}</td>
                  <td className="py-3.5 px-6">
                    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-semibold border ${
                      b.status === "Confirmed" 
                        ? "bg-emerald-50 text-emerald-700 border-emerald-100" 
                        : b.status === "Pending"
                        ? "bg-amber-50 text-amber-700 border-amber-100"
                        : "bg-rose-50 text-rose-700 border-rose-100"
                    }`}>
                      {b.status}
                    </span>
                  </td>
                  <td className="py-3.5 px-6 text-right space-x-2">
                    <button
                      onClick={() => handleOpenEdit(b)}
                      className="p-1.5 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                    >
                      <Edit className="h-4 w-4" />
                    </button>
                    <button
                      onClick={() => b.id && onDelete(b.id)}
                      className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </td>
                </tr>
              ))}
              {paginatedBookings.length === 0 && (
                <tr>
                  <td colSpan={6} className="py-12 text-center text-slate-400 font-mono">
                    No travel bookings recorded.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="px-6 py-4 border-t border-slate-100 flex items-center justify-between">
          <p className="text-slate-500 text-xs font-medium">
            Showing {(currentPage - 1) * itemsPerPage + 1} to {Math.min(currentPage * itemsPerPage, filteredBookings.length)} of {filteredBookings.length} bookings
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
                {editingBooking ? "Modify Booking status" : "Create Manual Booking"}
              </h3>
              <button type="button" onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-600">✕</button>
            </div>
            <div className="p-6 space-y-4">
              {errorMsg && (
                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">{errorMsg}</div>
              )}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Booking ID</label>
                  <input
                    type="text"
                    required
                    readOnly
                    value={formData.bookingId}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-slate-50 font-mono text-slate-500 focus:outline-none"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Assigned Route</label>
                  <input
                    type="text"
                    required
                    placeholder="e.g. 01, EX-01"
                    value={formData.routeNumber}
                    onChange={(e) => setFormData({ ...formData, routeNumber: e.target.value })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Passenger Name</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. John Doe"
                  value={formData.passengerName}
                  onChange={(e) => setFormData({ ...formData, passengerName: e.target.value })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Seat Number</label>
                  <input
                    type="text"
                    required
                    placeholder="e.g. A12"
                    value={formData.seatNumber}
                    onChange={(e) => setFormData({ ...formData, seatNumber: e.target.value })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Booking Status</label>
                  <select
                    value={formData.status}
                    onChange={(e) => setFormData({ ...formData, status: e.target.value as BookingStatus })}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  >
                    <option value="Pending">Pending</option>
                    <option value="Confirmed">Confirmed</option>
                    <option value="Cancelled">Cancelled</option>
                  </select>
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
                {editingBooking ? "Save Changes" : "Confirm Booking"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
