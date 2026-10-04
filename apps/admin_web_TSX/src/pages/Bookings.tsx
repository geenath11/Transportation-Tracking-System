import React, { useState } from "react";
import {
  Search,
  Plus,
  Edit,
  Trash2,
  ArrowUpDown,
  Filter,
  Ticket,
} from "lucide-react";

import { Booking } from "../types";

interface BookingsProps {
  bookings: Booking[];
  onCreate: (data: Booking) => Promise<void>;
  onUpdate: (id: string, data: Partial<Booking>) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
}

export default function Bookings({
  bookings,
  onCreate,
  onUpdate,
  onDelete,
}: BookingsProps) {
  const [search, setSearch] = useState("");

  const [statusFilter, setStatusFilter] = useState<string>("All");

  const [sortField, setSortField] = useState<keyof Booking>("ticketId");

  const [sortAsc, setSortAsc] = useState(true);

  // ============================================================
  // FORM / MODAL
  // ============================================================

  const [isModalOpen, setIsModalOpen] = useState(false);

  const [editingBooking, setEditingBooking] = useState<Booking | null>(null);

  const [formData, setFormData] = useState<Booking>({
    ticketId: "",
    passengerName: "",
    passengerPhone: "",
    userId: "",
    from: "",
    to: "",
    bus: "",
    date: "",
    departureTime: "",
    arrivalTime: "",
    selectedSeats: [],
    totalPrice: 0,
    paymentStatus: "pending",
    ticketStatus: "valid",
  });

  const [seatInput, setSeatInput] = useState("");

  const [errorMsg, setErrorMsg] = useState("");

  // ============================================================
  // PAGINATION
  // ============================================================

  const [currentPage, setCurrentPage] = useState(1);

  const itemsPerPage = 8;

  // ============================================================
  // SORT
  // ============================================================

  const handleSort = (field: keyof Booking) => {
    if (sortField === field) {
      setSortAsc((prev) => !prev);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  // ============================================================
  // OPEN ADD
  // ============================================================

  const handleOpenAdd = () => {
    setEditingBooking(null);

    const generatedTicketId = `CEYGO-${Date.now()}`;

    setFormData({
      ticketId: generatedTicketId,
      passengerName: "",
      passengerPhone: "",
      userId: "",
      from: "",
      to: "",
      bus: "",
      date: "",
      departureTime: "",
      arrivalTime: "",
      selectedSeats: [],
      totalPrice: 0,
      paymentStatus: "pending",
      ticketStatus: "valid",
    });

    setSeatInput("");
    setErrorMsg("");
    setIsModalOpen(true);
  };

  // ============================================================
  // OPEN EDIT
  // ============================================================

  const handleOpenEdit = (booking: Booking) => {
    setEditingBooking(booking);

    setFormData({
      ticketId: booking.ticketId || "",
      passengerName: booking.passengerName || "",
      passengerPhone: booking.passengerPhone || "",
      userId: booking.userId || "",
      from: booking.from || "",
      to: booking.to || "",
      bus: booking.bus || "",
      date: booking.date || "",
      departureTime: booking.departureTime || "",
      arrivalTime: booking.arrivalTime || "",
      selectedSeats: booking.selectedSeats || [],
      totalPrice: booking.totalPrice || 0,
      paymentStatus: booking.paymentStatus || "pending",
      ticketStatus: booking.ticketStatus || "valid",
    });

    setSeatInput((booking.selectedSeats || []).join(", "));

    setErrorMsg("");
    setIsModalOpen(true);
  };

  // ============================================================
  // INPUT HANDLER
  // ============================================================

  const handleInputChange = (field: keyof Booking, value: string | number) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  // ============================================================
  // SEAT INPUT
  // ============================================================

  const handleSeatsChange = (value: string) => {
    setSeatInput(value);

    const seats = value
      .split(",")
      .map((seat) => seat.trim())
      .filter(Boolean);

    setFormData((prev) => ({
      ...prev,
      selectedSeats: seats,
    }));
  };

  // ============================================================
  // SUBMIT
  // ============================================================

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    setErrorMsg("");

    // ----------------------------------------------------------
    // Validation
    // ----------------------------------------------------------

    if (!formData.ticketId.trim()) {
      setErrorMsg("Ticket ID is required.");
      return;
    }

    if (!formData.passengerName.trim()) {
      setErrorMsg("Passenger name is required.");
      return;
    }

    if (!formData.passengerPhone.trim()) {
      setErrorMsg("Passenger phone number is required.");
      return;
    }

    if (!formData.from.trim()) {
      setErrorMsg("Departure location is required.");
      return;
    }

    if (!formData.to.trim()) {
      setErrorMsg("Destination is required.");
      return;
    }

    if (!formData.bus.trim()) {
      setErrorMsg("Bus type is required.");
      return;
    }

    if (!formData.date.trim()) {
      setErrorMsg("Travel date is required.");
      return;
    }

    if (formData.selectedSeats.length === 0) {
      setErrorMsg("At least one seat is required.");
      return;
    }

    if (formData.totalPrice < 0) {
      setErrorMsg("Total price cannot be negative.");
      return;
    }

    try {
      // --------------------------------------------------------
      // UPDATE
      // --------------------------------------------------------

      if (editingBooking?.id) {
        await onUpdate(editingBooking.id, formData);
      }

      // --------------------------------------------------------
      // CREATE
      // --------------------------------------------------------
      else {
        await onCreate(formData);
      }

      setIsModalOpen(false);
      setEditingBooking(null);
    } catch (error) {
      console.error("Booking save error:", error);

      setErrorMsg("Failed to save booking. Please try again.");
    }
  };

  // ============================================================
  // FILTER
  // ============================================================

  const filteredBookings = bookings
    .filter((booking) => {
      const searchValue = search.toLowerCase();

      const matchesSearch =
        booking.ticketId?.toLowerCase().includes(searchValue) ||
        booking.passengerName?.toLowerCase().includes(searchValue) ||
        booking.passengerPhone?.toLowerCase().includes(searchValue) ||
        booking.from?.toLowerCase().includes(searchValue) ||
        booking.to?.toLowerCase().includes(searchValue);

      const matchesStatus =
        statusFilter === "All" ||
        booking.ticketStatus?.toLowerCase() === statusFilter.toLowerCase();

      return matchesSearch && matchesStatus;
    })

    // ==========================================================
    // SORT
    // ==========================================================

    .sort((a, b) => {
      const valueA =
        sortField === "selectedSeats"
          ? (a.selectedSeats || []).join(", ")
          : String(a[sortField] ?? "");

      const valueB =
        sortField === "selectedSeats"
          ? (b.selectedSeats || []).join(", ")
          : String(b[sortField] ?? "");

      if (valueA < valueB) {
        return sortAsc ? -1 : 1;
      }

      if (valueA > valueB) {
        return sortAsc ? 1 : -1;
      }

      return 0;
    });

  // ============================================================
  // PAGINATION
  // ============================================================

  const totalPages = Math.ceil(filteredBookings.length / itemsPerPage) || 1;

  const paginatedBookings = filteredBookings.slice(
    (currentPage - 1) * itemsPerPage,

    currentPage * itemsPerPage
  );

  // ============================================================
  // FORMAT STATUS
  // ============================================================

  const formatStatus = (value: string) => {
    if (!value) return "Unknown";

    return value.charAt(0).toUpperCase() + value.slice(1).toLowerCase();
  };

  // ============================================================
  // STATUS STYLE
  // ============================================================

  const getTicketStatusClass = (status: string) => {
    switch (status?.toLowerCase()) {
      case "valid":
        return "bg-emerald-50 text-emerald-700 border-emerald-100";

      case "cancelled":
        return "bg-rose-50 text-rose-700 border-rose-100";

      case "expired":
        return "bg-slate-100 text-slate-600 border-slate-200";

      default:
        return "bg-amber-50 text-amber-700 border-amber-100";
    }
  };

  // ============================================================
  // PAYMENT STYLE
  // ============================================================

  const getPaymentStatusClass = (status: string) => {
    switch (status?.toLowerCase()) {
      case "paid":
        return "bg-emerald-50 text-emerald-700 border-emerald-100";

      case "failed":
        return "bg-rose-50 text-rose-700 border-rose-100";

      case "refunded":
        return "bg-purple-50 text-purple-700 border-purple-100";

      default:
        return "bg-amber-50 text-amber-700 border-amber-100";
    }
  };

  // ============================================================
  // RENDER
  // ============================================================

  return (
    <div className="space-y-6">
      {/* ======================================================
          SEARCH + ACTION BAR
      ====================================================== */}

      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
        <div className="flex flex-1 items-center gap-3 max-w-2xl">
          {/* SEARCH */}

          <div className="relative flex-1">
            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />

            <input
              type="text"
              placeholder="Search ticket, passenger, phone, route..."
              value={search}
              onChange={(e) => {
                setSearch(e.target.value);
                setCurrentPage(1);
              }}
              className="w-full pl-9 pr-4 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 text-slate-700"
            />
          </div>

          {/* STATUS FILTER */}

          <div className="flex items-center gap-2">
            <Filter className="h-3.5 w-3.5 text-slate-400" />

            <select
              value={statusFilter}
              onChange={(e) => {
                setStatusFilter(e.target.value);
                setCurrentPage(1);
              }}
              className="text-xs bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-slate-600 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="All">All Tickets</option>

              <option value="valid">Valid</option>

              <option value="cancelled">Cancelled</option>

              <option value="expired">Expired</option>
            </select>
          </div>
        </div>

        {/* ADD */}

        <button
          onClick={handleOpenAdd}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all self-start sm:self-auto"
        >
          <Plus className="h-4 w-4" />

          <span>New Manual Booking</span>
        </button>
      </div>

      {/* ======================================================
          TABLE
      ====================================================== */}

      <div className="bg-white rounded-2xl border border-slate-150 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            {/* HEADER */}

            <thead>
              <tr className="bg-slate-50 text-slate-500 text-xs font-semibold border-b border-slate-150">
                {/* TICKET */}

                <th
                  className="py-3.5 px-6 cursor-pointer select-none"
                  onClick={() => handleSort("ticketId")}
                >
                  <div className="flex items-center gap-1.5">
                    <span>Ticket ID</span>

                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>

                {/* PASSENGER */}

                <th
                  className="py-3.5 px-6 cursor-pointer select-none"
                  onClick={() => handleSort("passengerName")}
                >
                  <div className="flex items-center gap-1.5">
                    <span>Passenger</span>

                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>

                {/* ROUTE */}

                <th className="py-3.5 px-6">Route</th>

                {/* TRAVEL */}

                <th className="py-3.5 px-6">Travel</th>

                {/* SEATS */}

                <th
                  className="py-3.5 px-6 cursor-pointer select-none"
                  onClick={() => handleSort("selectedSeats")}
                >
                  <div className="flex items-center gap-1.5">
                    <span>Seats</span>

                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>

                {/* PRICE */}

                <th
                  className="py-3.5 px-6 cursor-pointer select-none"
                  onClick={() => handleSort("totalPrice")}
                >
                  <div className="flex items-center gap-1.5">
                    <span>Total</span>

                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>

                {/* PAYMENT */}

                <th className="py-3.5 px-6">Payment</th>

                {/* STATUS */}

                <th className="py-3.5 px-6">Status</th>

                {/* ACTION */}

                <th className="py-3.5 px-6 text-right">Actions</th>
              </tr>
            </thead>

            {/* BODY */}

            <tbody className="divide-y divide-slate-100 text-xs text-slate-600">
              {paginatedBookings.map((booking) => (
                <tr
                  key={booking.id || booking.ticketId}
                  className="hover:bg-slate-50/40 transition-all"
                >
                  {/* TICKET */}

                  <td className="py-3.5 px-6">
                    <div className="font-mono font-bold text-slate-900">
                      {booking.ticketId}
                    </div>
                  </td>

                  {/* PASSENGER */}

                  <td className="py-3.5 px-6">
                    <div className="font-semibold text-slate-800">
                      {booking.passengerName}
                    </div>

                    <div className="text-[10px] text-slate-400 mt-0.5">
                      {booking.passengerPhone}
                    </div>
                  </td>

                  {/* ROUTE */}

                  <td className="py-3.5 px-6">
                    <div className="font-medium text-slate-700">
                      {booking.from}
                    </div>

                    <div className="text-[10px] text-slate-400">
                      ↓ {booking.to}
                    </div>
                  </td>

                  {/* TRAVEL */}

                  <td className="py-3.5 px-6">
                    <div className="font-medium text-slate-700">
                      {booking.date}
                    </div>

                    <div className="text-[10px] text-slate-400">
                      {booking.departureTime}
                      {" → "}
                      {booking.arrivalTime}
                    </div>

                    <div className="text-[10px] text-indigo-500 mt-0.5">
                      {booking.bus}
                    </div>
                  </td>

                  {/* SEATS */}

                  <td className="py-3.5 px-6">
                    {(() => {
                      const seatsList = Array.isArray(booking.selectedSeats)
                        ? booking.selectedSeats
                        : [];

                      const count = seatsList.length;

                      return (
                        <div className="flex flex-wrap items-center gap-1.5">
                          {count > 0 ? (
                            seatsList.map((seat, idx) => (
                              <span
                                key={`${seat}-${idx}`}
                                className="inline-flex items-center px-2 py-0.5 rounded-md font-mono text-[11px] font-semibold bg-indigo-50 text-indigo-700 border border-indigo-200"
                              >
                                {seat}
                              </span>
                            ))
                          ) : (
                            <span className="font-mono text-slate-400">—</span>
                          )}

                          {count > 1 && (
                            <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
                              <Ticket className="h-3 w-3" />
                              {count} Tickets
                            </span>
                          )}
                        </div>
                      );
                    })()}
                  </td>

                  {/* TOTAL */}

                  <td className="py-3.5 px-6">
                    <span className="font-semibold text-slate-900">
                      Rs. {Number(booking.totalPrice || 0).toLocaleString()}
                    </span>
                  </td>

                  {/* PAYMENT */}

                  <td className="py-3.5 px-6">
                    <span
                      className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-semibold border ${getPaymentStatusClass(
                        booking.paymentStatus
                      )}`}
                    >
                      {formatStatus(booking.paymentStatus)}
                    </span>
                  </td>

                  {/* TICKET STATUS */}

                  <td className="py-3.5 px-6">
                    <span
                      className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-semibold border ${getTicketStatusClass(
                        booking.ticketStatus
                      )}`}
                    >
                      {formatStatus(booking.ticketStatus)}
                    </span>
                  </td>

                  {/* ACTIONS */}

                  <td className="py-3.5 px-6 text-right whitespace-nowrap">
                    {/* EDIT */}

                    <button
                      onClick={() => handleOpenEdit(booking)}
                      className="p-1.5 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                      title="Edit booking"
                    >
                      <Edit className="h-4 w-4" />
                    </button>

                    {/* DELETE */}

                    <button
                      onClick={() => {
                        if (booking.id) {
                          onDelete(booking.id);
                        }
                      }}
                      className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                      title="Delete booking"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </td>
                </tr>
              ))}

              {/* EMPTY */}

              {paginatedBookings.length === 0 && (
                <tr>
                  <td
                    colSpan={9}
                    className="py-12 text-center text-slate-400 font-mono"
                  >
                    No travel bookings recorded.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* ====================================================
            PAGINATION
        ==================================================== */}

        <div className="px-6 py-4 border-t border-slate-100 flex items-center justify-between">
          <p className="text-slate-500 text-xs font-medium">
            {filteredBookings.length > 0
              ? `Showing ${(currentPage - 1) * itemsPerPage + 1} to ${Math.min(
                  currentPage * itemsPerPage,
                  filteredBookings.length
                )} of ${filteredBookings.length} bookings`
              : "No bookings"}
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
      </div>

      {/* ======================================================
          ADD / EDIT MODAL
      ====================================================== */}

      {isModalOpen && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs z-50 flex items-center justify-center p-4 overflow-y-auto">
          <form
            onSubmit={handleSubmit}
            className="w-full max-w-2xl bg-white rounded-2xl shadow-xl border border-slate-100 overflow-hidden my-8"
          >
            {/* HEADER */}

            <div className="px-6 py-4 border-b border-slate-100 flex items-center justify-between">
              <h3 className="font-display font-semibold text-slate-900 text-sm">
                {editingBooking ? "Edit Booking" : "Create Manual Booking"}
              </h3>

              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="text-slate-400 hover:text-slate-600 font-bold"
              >
                ✕
              </button>
            </div>

            {/* FORM */}

            <div className="p-6 space-y-4">
              {/* ERROR */}

              {errorMsg && (
                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">
                  {errorMsg}
                </div>
              )}

              {/* TICKET ID + USER ID */}

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    Ticket ID
                  </label>

                  <input
                    type="text"
                    readOnly
                    value={formData.ticketId}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-slate-50 font-mono text-slate-500"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    User ID
                  </label>

                  <input
                    type="text"
                    placeholder="Firebase user UID"
                    value={formData.userId}
                    onChange={(e) =>
                      handleInputChange("userId", e.target.value)
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
              </div>

              {/* PASSENGER */}

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    Passenger Name
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. Geenath Indira"
                    value={formData.passengerName}
                    onChange={(e) =>
                      handleInputChange("passengerName", e.target.value)
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    Passenger Phone
                  </label>

                  <input
                    type="tel"
                    required
                    placeholder="+947XXXXXXXX"
                    value={formData.passengerPhone}
                    onChange={(e) =>
                      handleInputChange("passengerPhone", e.target.value)
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                  />
                </div>
              </div>

              {/* FROM / TO */}

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    From
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. Badulla"
                    value={formData.from}
                    onChange={(e) => handleInputChange("from", e.target.value)}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    To
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. Kandy"
                    value={formData.to}
                    onChange={(e) => handleInputChange("to", e.target.value)}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>
              </div>

              {/* BUS + DATE */}

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    Bus
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. Semi Luxury"
                    value={formData.bus}
                    onChange={(e) => handleInputChange("bus", e.target.value)}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    Travel Date
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. Wednesday, 23 September"
                    value={formData.date}
                    onChange={(e) => handleInputChange("date", e.target.value)}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>
              </div>

              {/* DEPARTURE + ARRIVAL */}

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    Departure Time
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. 07:00 PM"
                    value={formData.departureTime}
                    onChange={(e) =>
                      handleInputChange("departureTime", e.target.value)
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    Arrival Time
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. 11:30 PM"
                    value={formData.arrivalTime}
                    onChange={(e) =>
                      handleInputChange("arrivalTime", e.target.value)
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />
                </div>
              </div>

              {/* SEATS */}

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700">
                  Selected Seats
                </label>

                <input
                  type="text"
                  required
                  placeholder="e.g. 34, 29, 30"
                  value={seatInput}
                  onChange={(e) => handleSeatsChange(e.target.value)}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                />

                <p className="text-[10px] text-slate-400">
                  Separate multiple seats with commas.
                </p>
              </div>

              {/* PRICE */}

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700">
                  Total Price
                </label>

                <input
                  type="number"
                  min="0"
                  required
                  placeholder="e.g. 1220"
                  value={formData.totalPrice}
                  onChange={(e) =>
                    setFormData((prev) => ({
                      ...prev,
                      totalPrice: Number(e.target.value),
                    }))
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>

              {/* PAYMENT + TICKET STATUS */}

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    Payment Status
                  </label>

                  <select
                    value={formData.paymentStatus}
                    onChange={(e) =>
                      handleInputChange("paymentStatus", e.target.value)
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  >
                    <option value="pending">Pending</option>

                    <option value="paid">Paid</option>

                    <option value="failed">Failed</option>

                    <option value="refunded">Refunded</option>
                  </select>
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700">
                    Ticket Status
                  </label>

                  <select
                    value={formData.ticketStatus}
                    onChange={(e) =>
                      handleInputChange("ticketStatus", e.target.value)
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  >
                    <option value="valid">Valid</option>

                    <option value="cancelled">Cancelled</option>

                    <option value="expired">Expired</option>
                  </select>
                </div>
              </div>
            </div>

            {/* FOOTER */}

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
                {editingBooking ? "Save Changes" : "Create Booking"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
