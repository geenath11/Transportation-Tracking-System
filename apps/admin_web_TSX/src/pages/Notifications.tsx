import React, { useState } from "react";
import { Search, Plus, Edit, Trash2, ArrowUpDown, Filter, Send, Calendar, FileText } from "lucide-react";
import { NotificationItem, NotificationTarget, NotificationStatus } from "../types";

interface NotificationsProps {
  notifications: NotificationItem[];
  onCreate: (data: NotificationItem) => any;
  onUpdate: (id: string, data: NotificationItem) => any;
  onDelete: (id: string) => any;
  onSendInstant: (id: string) => any;
}

export default function Notifications({
  notifications,
  onCreate,
  onUpdate,
  onDelete,
  onSendInstant
}: NotificationsProps) {
  const [search, setSearch] = useState("");
  const [targetFilter, setTargetFilter] = useState<string>("All");
  const [sortField, setSortField] = useState<keyof NotificationItem>("title");
  const [sortAsc, setSortAsc] = useState(true);

  // Form State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingNotification, setEditingNotification] = useState<NotificationItem | null>(null);
  const [formData, setFormData] = useState<NotificationItem>({
    title: "",
    message: "",
    targetUser: "All Users",
    status: "Draft"
  });
  const [errorMsg, setErrorMsg] = useState("");

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  const handleSort = (field: keyof NotificationItem) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  const handleOpenAdd = () => {
    setEditingNotification(null);
    setFormData({ title: "", message: "", targetUser: "All Users", status: "Draft" });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleOpenEdit = (n: NotificationItem) => {
    setEditingNotification(n);
    setFormData({
      title: n.title,
      message: n.message,
      targetUser: n.targetUser,
      status: n.status
    });
    setErrorMsg("");
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg("");

    if (!formData.title.trim() || !formData.message.trim()) {
      setErrorMsg("Title and broadcast message are required.");
      return;
    }

    try {
      if (editingNotification?.id) {
        await onUpdate(editingNotification.id, formData);
      } else {
        await onCreate(formData);
      }
      setIsModalOpen(false);
    } catch (err) {
      setErrorMsg("Failed to draft notification.");
    }
  };

  const filteredNotifications = notifications
    .filter(n => {
      const matchSearch = n.title.toLowerCase().includes(search.toLowerCase()) || 
                          n.message.toLowerCase().includes(search.toLowerCase());
      const matchTarget = targetFilter === "All" || n.targetUser === targetFilter;
      return matchSearch && matchTarget;
    })
    .sort((a, b) => {
      const valA = (a[sortField] || "").toString().toLowerCase();
      const valB = (b[sortField] || "").toString().toLowerCase();
      if (valA < valB) return sortAsc ? -1 : 1;
      if (valA > valB) return sortAsc ? 1 : -1;
      return 0;
    });

  const totalPages = Math.ceil(filteredNotifications.length / itemsPerPage) || 1;
  const paginatedNotifications = filteredNotifications.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  return (
    <div className="space-y-6">
      {/* Search Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">
        <div className="flex flex-1 items-center gap-3 max-w-lg">
          <div className="relative flex-1">
            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search notifications, announcements..."
              value={search}
              onChange={(e) => { setSearch(e.target.value); setCurrentPage(1); }}
              className="w-full pl-9 pr-4 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 text-slate-700"
            />
          </div>
          <div className="flex items-center gap-2">
            <Filter className="h-3.5 w-3.5 text-slate-400" />
            <select
              value={targetFilter}
              onChange={(e) => { setTargetFilter(e.target.value); setCurrentPage(1); }}
              className="text-xs bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-slate-600 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="All">All Targets</option>
              <option value="All Users">All Users</option>
              <option value="Passengers">Passengers</option>
              <option value="Drivers">Drivers</option>
              <option value="Conductors">Conductors</option>
            </select>
          </div>
        </div>

        <button
          onClick={handleOpenAdd}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all self-start sm:self-auto"
        >
          <Plus className="h-4 w-4" />
          <span>New Notification Draft</span>
        </button>
      </div>

      {/* Grid of Announcements */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {paginatedNotifications.map((n) => (
          <div key={n.id} className="bg-white border border-slate-150 rounded-2xl p-5 shadow-xs flex flex-col justify-between hover:border-slate-300 transition-all">
            <div>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <span className="px-2.5 py-0.5 bg-slate-100 text-slate-700 font-semibold rounded-lg text-[10px]">
                    To: {n.targetUser}
                  </span>
                  <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-semibold ${
                    n.status === "Sent" 
                      ? "bg-emerald-50 text-emerald-700 border-emerald-100" 
                      : n.status === "Scheduled"
                      ? "bg-sky-50 text-sky-700 border-sky-100"
                      : "bg-slate-100 text-slate-600 border-slate-200"
                  }`}>
                    {n.status === "Sent" ? <Send className="h-2.5 w-2.5" /> : n.status === "Scheduled" ? <Calendar className="h-2.5 w-2.5" /> : <FileText className="h-2.5 w-2.5" />}
                    {n.status}
                  </span>
                </div>
                <div className="space-x-1">
                  {n.status !== "Sent" && (
                    <button
                      onClick={() => n.id && onSendInstant(n.id)}
                      className="p-1 text-slate-400 hover:text-emerald-600 rounded-lg hover:bg-slate-50 inline-flex"
                      title="Send instant broadcast now"
                    >
                      <Send className="h-4 w-4" />
                    </button>
                  )}
                  <button
                    onClick={() => handleOpenEdit(n)}
                    className="p-1 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-50 inline-flex"
                  >
                    <Edit className="h-4 w-4" />
                  </button>
                  <button
                    onClick={() => n.id && onDelete(n.id)}
                    className="p-1 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-50 inline-flex"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>

              <div className="mt-4">
                <h4 className="text-sm font-semibold text-slate-900 font-display">{n.title}</h4>
                <p className="text-xs text-slate-500 mt-2 leading-relaxed bg-slate-50 p-3 rounded-xl border border-slate-100 font-mono">
                  {n.message}
                </p>
              </div>
            </div>
          </div>
        ))}

        {filteredNotifications.length === 0 && (
          <div className="col-span-1 md:col-span-2 bg-white p-12 text-center text-slate-400 font-mono rounded-2xl border border-slate-150">
            No system notifications created.
          </div>
        )}
      </div>

      {/* Pagination */}
      {filteredNotifications.length > 0 && (
        <div className="bg-white px-6 py-4 border border-slate-150 rounded-2xl flex items-center justify-between shadow-xs">
          <p className="text-slate-500 text-xs font-medium">
            Showing {(currentPage - 1) * itemsPerPage + 1} to {Math.min(currentPage * itemsPerPage, filteredNotifications.length)} of {filteredNotifications.length} announcements
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

      {/* Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <form onSubmit={handleSubmit} className="w-full max-w-md bg-white rounded-2xl shadow-xl border border-slate-100 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="px-6 py-4 border-b border-slate-100 flex items-center justify-between">
              <h3 className="font-display font-semibold text-slate-900 text-sm">
                {editingNotification ? "Edit Broadcast Draft" : "Draft Broadcast Announcement"}
              </h3>
              <button type="button" onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-600">✕</button>
            </div>
            <div className="p-6 space-y-4">
              {errorMsg && (
                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">{errorMsg}</div>
              )}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Announce Title</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Schedule Alterations EX-01"
                  value={formData.title}
                  onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-display"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Recipient Segment Target</label>
                <select
                  value={formData.targetUser}
                  onChange={(e) => setFormData({ ...formData, targetUser: e.target.value as NotificationTarget })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  <option value="All Users">All Users</option>
                  <option value="Passengers">Passengers Only</option>
                  <option value="Drivers">Drivers Only</option>
                  <option value="Conductors">Conductors Only</option>
                </select>
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Draft Broadcast Message</label>
                <textarea
                  required
                  rows={4}
                  placeholder="Draft broadcast copy..."
                  value={formData.message}
                  onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">Announce Status</label>
                <select
                  value={formData.status}
                  onChange={(e) => setFormData({ ...formData, status: e.target.value as NotificationStatus })}
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  <option value="Draft">Draft Save</option>
                  <option value="Scheduled">Scheduled Later</option>
                  <option value="Sent">Sent Immediately</option>
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
                {editingNotification ? "Save Changes" : "Draft Broadcast"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
