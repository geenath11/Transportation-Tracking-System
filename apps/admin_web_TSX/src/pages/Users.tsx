import React, { useState } from "react";
import { Search, Plus, Edit, Trash2, ArrowUpDown, Filter } from "lucide-react";

import { User, UserRole } from "../types";

interface UsersProps {
  users: User[];
  onCreate: (data: User) => any;
  onUpdate: (id: string, data: Partial<User>) => any;
  onDelete: (id: string) => any;
}

export default function Users({
  users,
  onCreate,
  onUpdate,
  onDelete,
}: UsersProps) {
  // ============================================================
  // SEARCH / FILTER / SORT
  // ============================================================

  const [search, setSearch] = useState("");
  const [roleFilter, setRoleFilter] = useState<string>("All");

  const [sortField, setSortField] = useState<keyof User>("fullName");

  const [sortAsc, setSortAsc] = useState(true);

  // ============================================================
  // FORM STATE
  // ============================================================

  const [isModalOpen, setIsModalOpen] = useState(false);

  const [editingUser, setEditingUser] = useState<User | null>(null);

  const [formData, setFormData] = useState<User>({
    firstName: "",
    lastName: "",
    fullName: "",
    phoneNumber: "",
    role: "passenger",
    uid: "",
  });

  const [errorMsg, setErrorMsg] = useState("");

  // ============================================================
  // PAGINATION
  // ============================================================

  const [currentPage, setCurrentPage] = useState(1);

  const itemsPerPage = 8;

  // ============================================================
  // SORT
  // ============================================================

  const handleSort = (field: keyof User) => {
    if (sortField === field) {
      setSortAsc((prev) => !prev);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  // ============================================================
  // OPEN ADD USER
  // ============================================================

  const handleOpenAdd = () => {
    setEditingUser(null);

    setFormData({
      firstName: "",
      lastName: "",
      fullName: "",
      phoneNumber: "",
      role: "passenger",
      uid: "",
    });

    setErrorMsg("");
    setIsModalOpen(true);
  };

  // ============================================================
  // OPEN EDIT USER
  // ============================================================

  const handleOpenEdit = (user: User) => {
    setEditingUser(user);

    setFormData({
      firstName: user.firstName || "",
      lastName: user.lastName || "",
      fullName:
        user.fullName ||
        `${user.firstName || ""} ${user.lastName || ""}`.trim(),
      phoneNumber: user.phoneNumber || "",
      role: user.role || "passenger",
      uid: user.uid || "",
    });

    setErrorMsg("");
    setIsModalOpen(true);
  };

  // ============================================================
  // HANDLE INPUT
  // ============================================================

  const handleInputChange = (field: keyof User, value: string) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  // ============================================================
  // HANDLE SUBMIT
  // ============================================================

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    setErrorMsg("");

    // ----------------------------------------------------------
    // Validation
    // ----------------------------------------------------------

    if (!formData.firstName.trim()) {
      setErrorMsg("First name is required.");
      return;
    }

    if (!formData.lastName.trim()) {
      setErrorMsg("Last name is required.");
      return;
    }

    if (!formData.phoneNumber.trim()) {
      setErrorMsg("Phone number is required.");
      return;
    }

    // ----------------------------------------------------------
    // Generate full name
    // ----------------------------------------------------------

    const fullName =
      `${formData.firstName.trim()} ${formData.lastName.trim()}`.trim();

    // ----------------------------------------------------------
    // Data that will be sent to Firestore
    // ----------------------------------------------------------

    const userData: User = {
      ...formData,

      firstName: formData.firstName.trim(),

      lastName: formData.lastName.trim(),

      fullName,

      phoneNumber: formData.phoneNumber.trim(),

      role: formData.role,

      // Keep existing UID when editing.
      // For a new user this remains empty unless your
      // authentication service supplies a real Firebase UID.
      uid: formData.uid || "",
    };

    try {
      // --------------------------------------------------------
      // UPDATE EXISTING USER
      // --------------------------------------------------------

      if (editingUser?.id) {
        await onUpdate(editingUser.id, userData);
      }

      // --------------------------------------------------------
      // CREATE NEW USER
      // --------------------------------------------------------
      else {
        await onCreate(userData);
      }

      // Close modal after successful operation
      setIsModalOpen(false);

      setEditingUser(null);
    } catch (error) {
      console.error("User save error:", error);

      setErrorMsg("An error occurred while saving the user. Please try again.");
    }
  };

  // ============================================================
  // FILTER
  // ============================================================

  const filteredUsers = users
    .filter((user) => {
      const searchValue = search.toLowerCase();

      const fullName =
        user.fullName ||
        `${user.firstName || ""} ${user.lastName || ""}`.trim();

      const phoneNumber = user.phoneNumber || "";

      const matchesSearch =
        fullName.toLowerCase().includes(searchValue) ||
        user.firstName?.toLowerCase().includes(searchValue) ||
        user.lastName?.toLowerCase().includes(searchValue) ||
        phoneNumber.toLowerCase().includes(searchValue);

      const matchesRole =
        roleFilter === "All" ||
        user.role?.toLowerCase() === roleFilter.toLowerCase();

      return matchesSearch && matchesRole;
    })

    // ==========================================================
    // SORT
    // ==========================================================

    .sort((a, b) => {
      let valueA = "";
      let valueB = "";

      if (sortField === "fullName") {
        valueA =
          a.fullName || `${a.firstName || ""} ${a.lastName || ""}`.trim();

        valueB =
          b.fullName || `${b.firstName || ""} ${b.lastName || ""}`.trim();
      } else {
        valueA = String(a[sortField] || "");
        valueB = String(b[sortField] || "");
      }

      valueA = valueA.toLowerCase();
      valueB = valueB.toLowerCase();

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

  const totalPages = Math.ceil(filteredUsers.length / itemsPerPage) || 1;

  const paginatedUsers = filteredUsers.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage
  );

  // ============================================================
  // ROLE DISPLAY
  // ============================================================

  const formatRole = (role: string) => {
    if (!role) return "Unknown";

    return role.charAt(0).toUpperCase() + role.slice(1).toLowerCase();
  };

  // ============================================================
  // ROLE STYLE
  // ============================================================

  const getRoleClass = (role: string) => {
    switch (role?.toLowerCase()) {
      case "admin":
        return "bg-rose-50 text-rose-700 border border-rose-100";

      case "operator":
        return "bg-amber-50 text-amber-700 border border-amber-100";

      case "passenger":
      default:
        return "bg-indigo-50 text-indigo-700 border border-indigo-100";
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
              placeholder="Search users by name or phone number..."
              value={search}
              onChange={(e) => {
                setSearch(e.target.value);
                setCurrentPage(1);
              }}
              className="w-full pl-9 pr-4 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 text-slate-700"
            />
          </div>

          {/* ROLE FILTER */}

          <div className="flex items-center gap-2">
            <Filter className="h-3.5 w-3.5 text-slate-400" />

            <select
              value={roleFilter}
              onChange={(e) => {
                setRoleFilter(e.target.value);
                setCurrentPage(1);
              }}
              className="text-xs bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-slate-600 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            >
              <option value="All">All Roles</option>

              <option value="admin">Admin</option>

              <option value="passenger">Passenger</option>

              <option value="operator">Operator</option>
            </select>
          </div>
        </div>

        {/* ADD USER */}

        <button
          onClick={handleOpenAdd}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-semibold shadow-lg shadow-indigo-600/15 transition-all self-start sm:self-auto"
        >
          <Plus className="h-4 w-4" />

          <span>Add System User</span>
        </button>
      </div>

      {/* ======================================================
          USER TABLE
      ====================================================== */}

      <div className="bg-white rounded-2xl border border-slate-150 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            {/* TABLE HEADER */}

            <thead>
              <tr className="bg-slate-50 text-slate-500 text-xs font-semibold border-b border-slate-150">
                {/* USER NAME */}

                <th
                  className="py-3.5 px-6 cursor-pointer select-none"
                  onClick={() => handleSort("fullName")}
                >
                  <div className="flex items-center gap-1.5">
                    <span>User Name</span>

                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>

                {/* PHONE */}

                <th
                  className="py-3.5 px-6 cursor-pointer select-none"
                  onClick={() => handleSort("phoneNumber")}
                >
                  <div className="flex items-center gap-1.5">
                    <span>Phone Number</span>

                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>

                {/* ROLE */}

                <th
                  className="py-3.5 px-6 cursor-pointer select-none"
                  onClick={() => handleSort("role")}
                >
                  <div className="flex items-center gap-1.5">
                    <span>Role</span>

                    <ArrowUpDown className="h-3 w-3 text-slate-400" />
                  </div>
                </th>

                {/* UID */}

                <th className="py-3.5 px-6">User ID</th>

                {/* ACTIONS */}

                <th className="py-3.5 px-6 text-right">Actions</th>
              </tr>
            </thead>

            {/* TABLE BODY */}

            <tbody className="divide-y divide-slate-100 text-xs text-slate-600">
              {paginatedUsers.map((user) => {
                const displayName =
                  user.fullName ||
                  `${user.firstName || ""} ${user.lastName || ""}`.trim() ||
                  "Unnamed User";

                return (
                  <tr
                    key={user.id || user.uid}
                    className="hover:bg-slate-50/40 transition-all"
                  >
                    {/* NAME */}

                    <td className="py-3.5 px-6">
                      <div className="font-semibold text-slate-900">
                        {displayName}
                      </div>

                      {(user.firstName || user.lastName) && (
                        <div className="text-[10px] text-slate-400 mt-0.5">
                          {user.firstName} {user.lastName}
                        </div>
                      )}
                    </td>

                    {/* PHONE */}

                    <td className="py-3.5 px-6 font-mono text-slate-500">
                      {user.phoneNumber || "-"}
                    </td>

                    {/* ROLE */}

                    <td className="py-3.5 px-6">
                      <span
                        className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-semibold ${getRoleClass(
                          user.role
                        )}`}
                      >
                        {formatRole(user.role)}
                      </span>
                    </td>

                    {/* UID */}

                    <td className="py-3.5 px-6">
                      <span
                        className="font-mono text-[10px] text-slate-400 max-w-[180px] inline-block truncate"
                        title={user.uid}
                      >
                        {user.uid || "-"}
                      </span>
                    </td>

                    {/* ACTIONS */}

                    <td className="py-3.5 px-6 text-right space-x-2">
                      {/* EDIT */}

                      <button
                        onClick={() => handleOpenEdit(user)}
                        className="p-1.5 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                        title="Edit user details"
                      >
                        <Edit className="h-4 w-4" />
                      </button>

                      {/* DELETE */}

                      <button
                        onClick={() => {
                          if (user.id) {
                            onDelete(user.id);
                          }
                        }}
                        className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-100 transition-all inline-flex"
                        title="Delete user"
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </td>
                  </tr>
                );
              })}

              {/* NO RESULTS */}

              {paginatedUsers.length === 0 && (
                <tr>
                  <td
                    colSpan={5}
                    className="py-12 text-center text-slate-400 font-mono"
                  >
                    No users matching criteria.
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
            {filteredUsers.length > 0
              ? `Showing ${(currentPage - 1) * itemsPerPage + 1} to ${Math.min(
                  currentPage * itemsPerPage,
                  filteredUsers.length
                )} of ${filteredUsers.length} users`
              : "No users"}
          </p>

          <div className="flex items-center gap-2">
            {/* PREVIOUS */}

            <button
              onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
              disabled={currentPage === 1}
              className="px-3 py-1.5 text-xs font-semibold border border-slate-200 rounded-xl hover:bg-slate-50 disabled:opacity-50 disabled:pointer-events-none transition-all"
            >
              Previous
            </button>

            {/* PAGE */}

            <span className="text-xs font-semibold text-slate-700 px-2 font-mono">
              {currentPage} / {totalPages}
            </span>

            {/* NEXT */}

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
          ADD / EDIT USER MODAL
      ====================================================== */}

      {isModalOpen && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <form
            onSubmit={handleSubmit}
            className="w-full max-w-md bg-white rounded-2xl shadow-xl border border-slate-100 overflow-hidden animate-in fade-in zoom-in-95 duration-200"
          >
            {/* MODAL HEADER */}

            <div className="px-6 py-4 border-b border-slate-100 flex items-center justify-between">
              <h3 className="font-display font-semibold text-slate-900 text-sm">
                {editingUser ? "Edit User Record" : "Add System User"}
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

              {/* FIRST NAME */}

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">
                  First Name
                </label>

                <input
                  type="text"
                  required
                  placeholder="Enter first name"
                  value={formData.firstName}
                  onChange={(e) =>
                    handleInputChange("firstName", e.target.value)
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>

              {/* LAST NAME */}

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">
                  Last Name
                </label>

                <input
                  type="text"
                  required
                  placeholder="Enter last name"
                  value={formData.lastName}
                  onChange={(e) =>
                    handleInputChange("lastName", e.target.value)
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
              </div>

              {/* FULL NAME - READ ONLY */}

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">
                  Full Name
                </label>

                <input
                  type="text"
                  value={`${formData.firstName} ${formData.lastName}`.trim()}
                  readOnly
                  placeholder="Full name will be generated automatically"
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-slate-50 text-slate-500 cursor-not-allowed"
                />
              </div>

              {/* PHONE */}

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">
                  Phone Number
                </label>

                <input
                  type="tel"
                  required
                  placeholder="+947XXXXXXXX"
                  value={formData.phoneNumber}
                  onChange={(e) =>
                    handleInputChange("phoneNumber", e.target.value)
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                />
              </div>

              {/* ROLE */}

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-700 block">
                  System Role
                </label>

                <select
                  value={formData.role}
                  onChange={(e) =>
                    handleInputChange("role", e.target.value as UserRole)
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                >
                  <option value="passenger">Passenger</option>

                  <option value="admin">Admin</option>

                  <option value="operator">Operator</option>
                </select>
              </div>
            </div>

            {/* MODAL FOOTER */}

            <div className="px-6 py-4 bg-slate-50 border-t border-slate-100 flex justify-end gap-3">
              {/* CANCEL */}

              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="px-4 py-2 text-xs font-semibold text-slate-700 bg-white border border-slate-200 rounded-xl hover:bg-slate-50"
              >
                Cancel
              </button>

              {/* SAVE */}

              <button
                type="submit"
                className="px-4 py-2 text-xs font-semibold text-white bg-indigo-600 hover:bg-indigo-700 rounded-xl shadow-lg shadow-indigo-600/15"
              >
                {editingUser ? "Save Changes" : "Create User"}
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
