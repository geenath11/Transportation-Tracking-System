import React, { useState } from "react";
import { Search, Edit, Trash2, ArrowUpDown, Filter, AlertCircle, CheckCircle2, HelpCircle } from "lucide-react";
import { Complaint, ComplaintStatus } from "../types";

interface ComplaintsProps {
  complaints: Complaint[];
  onCreate: (data: Complaint) => any;
  onUpdate: (id: string, data: Complaint) => any;
  onDelete: (id: string) => any;
}

export default function Complaints({ complaints, onCreate, onUpdate, onDelete }: ComplaintsProps) {
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<string>("All");
  const [sortField, setSortField] = useState<keyof Complaint>("complaintId");
  const [sortAsc, setSortAsc] = useState(true);

  // Form / Resolution Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingComplaint, setEditingComplaint] = useState<Complaint | null>(null);
  const [formData, setFormData] = useState<Complaint>({
    complaintId: "",
    passengerName: "",
    subject: "",
    description: "",
    status: "Pending"
  });
  const [errorMsg, setErrorMsg] = useState("");

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  const handleSort = (field: keyof Complaint) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  const handleOpenEdit = (c: Complaint) => {
    setEditingComplaint(c);
    setFormData({
      complaintId: c.complaintId,
      passengerName: c.passengerName,
      subject: c.subject,
      description: c.description,
      status: c.status
    });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg("");

    try {
      if (editingComplaint?.id) {
        await onUpdate(editingComplaint.id, formData);
      } else {
        // Can manually add a complaint
        await onCreate(formData);
      }
      setIsModalOpen(false);
    } catch (err) {
      setErrorMsg("Failed to update complaint status.");
    }
  };

  const handleOpenAdd = () => {
    setEditingComplaint(null);
    const generatedId = `C-${Math.floor(5000 + Math.random() * 900)}`;
    setFormData({ complaintId: generatedId, passengerName: "", subject: "", description: "", status: "Pending" });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const filteredComplaints = complaints
    .filter(c => {
      const matchSearch = c.complaintId.toLowerCase().includes(search.toLowerCase()) || 
                          c.passengerName.toLowerCase().includes(search.toLowerCase()) ||
                          c.subject.toLowerCase().includes(search.toLowerCase());
      const matchStatus = statusFilter === "All" || c.status === statusFilter;
      return matchSearch && matchStatus;
    })
    .sort((a, b) => {
      const valA = (a[sortField] || "").toString().toLowerCase();
      const valB = (b[sortField] || "").toString().toLowerCase();
      if (valA < valB) return sortAsc ? -1 : 1;
      if (valA > valB) return sortAsc ? 1 : -1;
      return 0;
    });

  const totalPages = Math.ceil(filteredComplaints.length / itemsPerPage) || 1;
  const paginatedComplaints = filteredComplaints.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  return (
    <div className="space-y-6">
      {/* Search Actions */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
        <div className="flex flex-1 items-center gap-3 max-w-lg">
          <div className="relative flex-1">
            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search complaint ID, passenger, subject..."
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
              <option value="All">All Complaints</option>
              <option value="Pending">Pending</option>
              <option value="In Progress">In Progress</option>
              <option value="Resolved">Resolved</option>
            </select>
          </div>
        </div>

        <button
          onClick={handleOpenAdd}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all self-start sm:self-auto"
        >
          <span>File a Passenger Complaint</span>
        </button>
      </div>

      {/* Complaints Grid/List */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {paginatedComplaints.map((c) => (
          <div key={c.id} className="bg-white border border-slate-150 rounded-2xl p-5 shadow-xs flex flex-col justify-between hover:border-slate-300 transition-all">
            <div>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <span className="font-mono font-bold text-xs text-indigo-600 bg-indigo-50 px-2 py-0.5 rounded-lg">
                    {c.complaintId}
                  </span>
                  <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-semibold ${
                    c.status === "Resolved" 
                      ? "bg-emerald-50 text-emerald-700" 
                      : c.status === "In Progress"
                      ? "bg-amber-50 text-amber-700"
                      : "bg-rose-50 text-rose-700"
                  }`}>
                    {c.status === "Resolved" ? <CheckCircle2 className="h-3 w-3" /> : c.status === "In Progress" ? <HelpCircle className="h-3 w-3" /> : <AlertCircle className="h-3 w-3" />}
                    {c.status}
                  </span>
                </div>
                <div className="space-x-1">
                  <button
                    onClick={() => handleOpenEdit(c)}
                    className="p-1 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-50 inline-flex"
                    title="Review complaint & resolve"
                  >
                    <Edit className="h-4 w-4" />
                  </button>
                  <button
                    onClick={() => c.id && onDelete(c.id)}
                    className="p-1 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-50 inline-flex"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>

              <div className="mt-3">
                <p className="text-[10px] font-medium text-slate-400">FILED BY: {c.passengerName || "Anonymous passenger"}</p>
                <h4 className="text-sm font-semibold text-slate-900 font-display mt-0.5">{c.subject}</h4>
                <p className="text-xs text-slate-500 mt-2 leading-relaxed bg-slate-50 p-3 rounded-xl border border-slate-100 font-mono">
                  {c.description}
                </p>
              </div>
            </div>
          </div>
        ))}

        {filteredComplaints.length === 0 && (
          <div className="col-span-1 md:col-span-2 bg-white p-12 text-center text-slate-400 font-mono rounded-2xl border border-slate-150">
            No complaints filed. Clear filters to see all.
          </div>
        )}
      </div>

      {/* Pagination */}
      {filteredComplaints.length > 0 && (
        <div className="bg-white px-6 py-4 border border-slate-150 rounded-2xl flex items-center justify-between shadow-xs">
          <p className="text-slate-500 text-xs font-medium">
            Showing {(currentPage - 1) * itemsPerPage + 1} to {Math.min(currentPage * itemsPerPage, filteredComplaints.length)} of {filteredComplaints.length} complaints
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

      {/* Action Dialog */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <form onSubmit={handleSubmit} className="w-full max-w-md bg-white rounded-2xl shadow-xl border border-slate-100 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="px-6 py-4 border-b border-slate-100 flex items-center justify-between">
              <h3 className="font-display font-semibold text-slate-900 text-sm">
                {editingComplaint ? "Resolve Passenger Complaint" : "File Passenger Complaint"}
              </h3>
              <button type="button" onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-600">✕</button>
            </div>
            <div className="p-6 space-y-4">
              {errorMsg && (
                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">{errorMsg}</div>
              )}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-700 block">Complaint ID</label>
                  <input
                    type="text"
                    required
                    readOnly
                    value={formData.complaintId}
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-slate-50 font-mono text-slate-500 focus:outline-none"
                  />
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
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Subject Topic</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Bus Delay, AC Malfunction"
                  value={formData.subject}
                  onChange={(e) => setFormData({ ...formData, subject: e.target.value })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-display"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Detailed Description</label>
                <textarea
                  required
                  rows={3}
                  placeholder="Provide precise details..."
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Action Resolution Status</label>
                <select
                  value={formData.status}
                  onChange={(e) => setFormData({ ...formData, status: e.target.value as ComplaintStatus })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  <option value="Pending">Pending Review</option>
                  <option value="In Progress">Investigation In Progress</option>
                  <option value="Resolved">Resolved / Closed</option>
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
                {editingComplaint ? "Save Resolution" : "File"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
