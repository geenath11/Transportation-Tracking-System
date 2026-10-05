import React, { useMemo, useState } from "react";
import {
  Plus,
  Search,
  Edit,
  Trash2,
  X,
  Route as RouteIcon,
  Bus,
  UserCheck,
  Contact,
  Calendar,
  Clock,
} from "lucide-react";

import {
  Route,
  Vehicle,
  Driver,
  Conductor,
  RouteAssignment,
  RouteAssignmentStatus,
} from "../types";

interface RouteAssignProps {
  assignments: RouteAssignment[];
  routes: Route[];
  vehicles: Vehicle[];
  drivers: Driver[];
  conductors: Conductor[];

  onCreate: (data: RouteAssignment) => Promise<void>;
  onUpdate: (id: string, data: Partial<RouteAssignment>) => Promise<void>;
  onDelete: (id: string) => void | Promise<void>;
}

interface FormData {
  routeId: string;
  vehicleId: string;
  driverId: string;
  conductorId: string;
  date: string;
  departureTime: string;
  status: RouteAssignmentStatus;
}

const emptyForm: FormData = {
  routeId: "",
  vehicleId: "",
  driverId: "",
  conductorId: "",
  date: "",
  departureTime: "",
  status: "Assigned",
};

export default function RouteAssign({
  assignments,
  routes,
  vehicles,
  drivers,
  conductors,
  onCreate,
  onUpdate,
  onDelete,
}: RouteAssignProps) {
  const [search, setSearch] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingAssignment, setEditingAssignment] =
    useState<RouteAssignment | null>(null);

  const [formData, setFormData] = useState<FormData>(emptyForm);

  const [errorMsg, setErrorMsg] = useState("");

  /* =====================================================
     ROUTE DISPLAY HELPERS
     Supports both route structures
  ===================================================== */

  const getRouteNumber = (route?: Route) => {
    if (!route) return "";

    return String(route.routeNumber ?? route.route ?? route.serviceName ?? "");
  };

  const getRouteStart = (route?: Route) => {
    if (!route) return "";

    return String(route.start ?? route.departureCity ?? "");
  };

  const getRouteDestination = (route?: Route) => {
    if (!route) return "";

    return String(route.destination ?? route.arrivalCity ?? "");
  };

  const getRouteLabel = (route?: Route) => {
    if (!route) return "Unknown Route";

    const number = getRouteNumber(route);
    const start = getRouteStart(route);
    const destination = getRouteDestination(route);

    if (number && start && destination) {
      return `${number} - ${start} → ${destination}`;
    }

    if (start && destination) {
      return `${start} → ${destination}`;
    }

    return number || "Unknown Route";
  };

  /* =====================================================
     LOOKUP HELPERS
  ===================================================== */

  const getVehicle = (id: string) =>
    vehicles.find((vehicle) => vehicle.id === id);

  const getDriver = (id: string) => drivers.find((driver) => driver.id === id);

  const getConductor = (id: string) =>
    conductors.find((conductor) => conductor.id === id);

  const getRoute = (id: string) => routes.find((route) => route.id === id);

  /* =====================================================
     FILTER / SEARCH
  ===================================================== */

  const filteredAssignments = useMemo(() => {
    const searchLower = search.toLowerCase().trim();

    if (!searchLower) {
      return assignments;
    }

    return assignments.filter((assignment) => {
      const route = getRoute(assignment.routeId);
      const vehicle = getVehicle(assignment.vehicleId);
      const driver = getDriver(assignment.driverId);
      const conductor = getConductor(assignment.conductorId);

      const searchableText = [
        getRouteLabel(route),
        vehicle?.vehicleNumber ?? "",
        vehicle?.vehicleType ?? "",
        driver?.name ?? "",
        driver?.licenseNumber ?? "",
        conductor?.name ?? "",
        conductor?.phone ?? "",
        assignment.date,
        assignment.departureTime,
        assignment.status,
      ]
        .join(" ")
        .toLowerCase();

      return searchableText.includes(searchLower);
    });
  }, [assignments, routes, vehicles, drivers, conductors, search]);

  /* =====================================================
     OPEN CREATE
  ===================================================== */

  const handleOpenCreate = () => {
    setEditingAssignment(null);
    setFormData(emptyForm);
    setErrorMsg("");
    setIsModalOpen(true);
  };

  /* =====================================================
     OPEN EDIT
  ===================================================== */

  const handleOpenEdit = (assignment: RouteAssignment) => {
    setEditingAssignment(assignment);

    setFormData({
      routeId: assignment.routeId ?? "",
      vehicleId: assignment.vehicleId ?? "",
      driverId: assignment.driverId ?? "",
      conductorId: assignment.conductorId ?? "",
      date: assignment.date ?? "",
      departureTime: assignment.departureTime ?? "",
      status: assignment.status ?? "Assigned",
    });

    setErrorMsg("");
    setIsModalOpen(true);
  };

  /* =====================================================
     CLOSE MODAL
  ===================================================== */

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setEditingAssignment(null);
    setFormData(emptyForm);
    setErrorMsg("");
  };

  /* =====================================================
     FORM CHANGE
  ===================================================== */

  const handleChange = (field: keyof FormData, value: string) => {
    setFormData((previous) => ({
      ...previous,
      [field]: value,
    }));
  };

  /* =====================================================
     SUBMIT
  ===================================================== */

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();

    setErrorMsg("");

    if (
      !formData.routeId ||
      !formData.vehicleId ||
      !formData.driverId ||
      !formData.conductorId ||
      !formData.date ||
      !formData.departureTime
    ) {
      setErrorMsg("Please complete all required fields.");
      return;
    }

    /* =================================================
       CHECK DUPLICATE ASSIGNMENT
    ================================================= */

    const duplicate = assignments.find(
      (assignment) =>
        assignment.id !== editingAssignment?.id &&
        assignment.date === formData.date &&
        assignment.departureTime === formData.departureTime &&
        (assignment.vehicleId === formData.vehicleId ||
          assignment.driverId === formData.driverId ||
          assignment.conductorId === formData.conductorId)
    );

    if (duplicate) {
      setErrorMsg(
        "This vehicle, driver, or conductor is already assigned at the selected date and time."
      );
      return;
    }

    try {
      if (editingAssignment?.id) {
        await onUpdate(editingAssignment.id, {
          routeId: formData.routeId,
          vehicleId: formData.vehicleId,
          driverId: formData.driverId,
          conductorId: formData.conductorId,
          date: formData.date,
          departureTime: formData.departureTime,
          status: formData.status,
        });
      } else {
        await onCreate({
          routeId: formData.routeId,
          vehicleId: formData.vehicleId,
          driverId: formData.driverId,
          conductorId: formData.conductorId,
          date: formData.date,
          departureTime: formData.departureTime,
          status: formData.status,
        });
      }

      handleCloseModal();
    } catch (error) {
      console.error("Failed to save route assignment:", error);

      setErrorMsg("Failed to save the route assignment. Please try again.");
    }
  };

  /* =====================================================
     STATUS BADGE
  ===================================================== */

  const getStatusClass = (status: RouteAssignmentStatus) => {
    switch (status) {
      case "Assigned":
        return "bg-indigo-50 text-indigo-700 border-indigo-200";

      case "Completed":
        return "bg-emerald-50 text-emerald-700 border-emerald-200";

      case "Cancelled":
        return "bg-rose-50 text-rose-700 border-rose-200";

      default:
        return "bg-slate-50 text-slate-700 border-slate-200";
    }
  };

  return (
    <div className="space-y-6">
      {/* =================================================
          PAGE HEADER
      ================================================= */}

      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Route Assign</h1>

          <p className="mt-1 text-sm text-slate-500">
            Assign routes to vehicles, drivers, and conductors.
          </p>
        </div>

        <button
          onClick={handleOpenCreate}
          className="inline-flex items-center justify-center gap-2 rounded-xl bg-indigo-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-indigo-700"
        >
          <Plus className="h-4 w-4" />
          Assign Route
        </button>
      </div>

      {/* =================================================
          SEARCH
      ================================================= */}

      <div className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />

          <input
            type="text"
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Search route, vehicle, driver, conductor..."
            className="w-full rounded-xl border border-slate-200 bg-slate-50 py-2.5 pl-10 pr-4 text-sm outline-none transition focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100"
          />
        </div>
      </div>

      {/* =================================================
          ASSIGNMENTS TABLE
      ================================================= */}

      <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full min-w-[1000px] text-left">
            <thead className="border-b border-slate-200 bg-slate-50">
              <tr>
                <th className="px-5 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Route
                </th>

                <th className="px-5 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Vehicle
                </th>

                <th className="px-5 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Driver
                </th>

                <th className="px-5 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Conductor
                </th>

                <th className="px-5 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Date
                </th>

                <th className="px-5 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Departure
                </th>

                <th className="px-5 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Status
                </th>

                <th className="px-5 py-4 text-right text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Actions
                </th>
              </tr>
            </thead>

            <tbody className="divide-y divide-slate-100">
              {filteredAssignments.length === 0 ? (
                <tr>
                  <td colSpan={8} className="px-5 py-12 text-center">
                    <RouteIcon className="mx-auto h-10 w-10 text-slate-300" />

                    <p className="mt-3 text-sm font-semibold text-slate-600">
                      No route assignments found
                    </p>

                    <p className="mt-1 text-xs text-slate-400">
                      Create a route assignment to see it here.
                    </p>
                  </td>
                </tr>
              ) : (
                filteredAssignments.map((assignment) => {
                  const route = getRoute(assignment.routeId);

                  const vehicle = getVehicle(assignment.vehicleId);

                  const driver = getDriver(assignment.driverId);

                  const conductor = getConductor(assignment.conductorId);

                  return (
                    <tr
                      key={assignment.id}
                      className="transition hover:bg-slate-50"
                    >
                      {/* Route */}
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-3">
                          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-indigo-50 text-indigo-600">
                            <RouteIcon className="h-4 w-4" />
                          </div>

                          <div>
                            <p className="text-sm font-semibold text-slate-800">
                              {getRouteLabel(route)}
                            </p>

                            <p className="text-xs text-slate-400">Route</p>
                          </div>
                        </div>
                      </td>

                      {/* Vehicle */}
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-2">
                          <Bus className="h-4 w-4 text-slate-400" />

                          <div>
                            <p className="text-sm font-medium text-slate-700">
                              {vehicle?.vehicleNumber || "Unknown"}
                            </p>

                            <p className="text-xs text-slate-400">
                              {vehicle?.vehicleType || ""}
                            </p>
                          </div>
                        </div>
                      </td>

                      {/* Driver */}
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-2">
                          <UserCheck className="h-4 w-4 text-slate-400" />

                          <span className="text-sm text-slate-700">
                            {driver?.name || "Unknown"}
                          </span>
                        </div>
                      </td>

                      {/* Conductor */}
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-2">
                          <Contact className="h-4 w-4 text-slate-400" />

                          <span className="text-sm text-slate-700">
                            {conductor?.name || "Unknown"}
                          </span>
                        </div>
                      </td>

                      {/* Date */}
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-2">
                          <Calendar className="h-4 w-4 text-slate-400" />

                          <span className="text-sm text-slate-700">
                            {assignment.date}
                          </span>
                        </div>
                      </td>

                      {/* Time */}
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-2">
                          <Clock className="h-4 w-4 text-slate-400" />

                          <span className="text-sm text-slate-700">
                            {assignment.departureTime}
                          </span>
                        </div>
                      </td>

                      {/* Status */}
                      <td className="px-5 py-4">
                        <span
                          className={`inline-flex rounded-full border px-2.5 py-1 text-xs font-semibold ${getStatusClass(
                            assignment.status
                          )}`}
                        >
                          {assignment.status}
                        </span>
                      </td>

                      {/* Actions */}
                      <td className="px-5 py-4">
                        <div className="flex justify-end gap-2">
                          <button
                            onClick={() => handleOpenEdit(assignment)}
                            className="rounded-lg p-2 text-slate-500 transition hover:bg-indigo-50 hover:text-indigo-600"
                            title="Edit"
                          >
                            <Edit className="h-4 w-4" />
                          </button>

                          <button
                            onClick={() => {
                              if (assignment.id) {
                                onDelete(assignment.id);
                              }
                            }}
                            className="rounded-lg p-2 text-slate-500 transition hover:bg-rose-50 hover:text-rose-600"
                            title="Delete"
                          >
                            <Trash2 className="h-4 w-4" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* =================================================
          MODAL
      ================================================= */}

      {isModalOpen && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-slate-950/50 p-4 backdrop-blur-sm">
          <div className="w-full max-w-2xl overflow-hidden rounded-2xl bg-white shadow-2xl">
            {/* Header */}
            <div className="flex items-center justify-between border-b border-slate-200 px-6 py-4">
              <div>
                <h2 className="text-lg font-bold text-slate-900">
                  {editingAssignment ? "Edit Route Assignment" : "Assign Route"}
                </h2>

                <p className="mt-1 text-xs text-slate-500">
                  Connect a route with a vehicle, driver, and conductor.
                </p>
              </div>

              <button
                onClick={handleCloseModal}
                className="rounded-lg p-2 text-slate-400 transition hover:bg-slate-100 hover:text-slate-700"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="space-y-5 p-6">
              {errorMsg && (
                <div className="rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-700">
                  {errorMsg}
                </div>
              )}

              <div className="grid gap-5 md:grid-cols-2">
                {/* Route */}
                <div>
                  <label className="mb-2 block text-sm font-semibold text-slate-700">
                    Route *
                  </label>

                  <select
                    value={formData.routeId}
                    onChange={(event) =>
                      handleChange("routeId", event.target.value)
                    }
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100"
                  >
                    <option value="">Select route</option>

                    {routes.map((route) => (
                      <option key={route.id} value={route.id}>
                        {getRouteLabel(route)}
                      </option>
                    ))}
                  </select>
                </div>

                {/* Vehicle */}
                <div>
                  <label className="mb-2 block text-sm font-semibold text-slate-700">
                    Vehicle *
                  </label>

                  <select
                    value={formData.vehicleId}
                    onChange={(event) =>
                      handleChange("vehicleId", event.target.value)
                    }
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100"
                  >
                    <option value="">Select vehicle</option>

                    {vehicles
                      .filter((vehicle) => vehicle.status !== "Maintenance")
                      .map((vehicle) => (
                        <option key={vehicle.id} value={vehicle.id}>
                          {vehicle.vehicleNumber} - {vehicle.vehicleType}
                        </option>
                      ))}
                  </select>
                </div>

                {/* Driver */}
                <div>
                  <label className="mb-2 block text-sm font-semibold text-slate-700">
                    Driver *
                  </label>

                  <select
                    value={formData.driverId}
                    onChange={(event) =>
                      handleChange("driverId", event.target.value)
                    }
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100"
                  >
                    <option value="">Select driver</option>

                    {drivers
                      .filter((driver) => driver.status === "Active")
                      .map((driver) => (
                        <option key={driver.id} value={driver.id}>
                          {driver.name} - {driver.licenseNumber}
                        </option>
                      ))}
                  </select>
                </div>

                {/* Conductor */}
                <div>
                  <label className="mb-2 block text-sm font-semibold text-slate-700">
                    Conductor *
                  </label>

                  <select
                    value={formData.conductorId}
                    onChange={(event) =>
                      handleChange("conductorId", event.target.value)
                    }
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100"
                  >
                    <option value="">Select conductor</option>

                    {conductors
                      .filter((conductor) => conductor.status === "Active")
                      .map((conductor) => (
                        <option key={conductor.id} value={conductor.id}>
                          {conductor.name} - {conductor.phone}
                        </option>
                      ))}
                  </select>
                </div>

                {/* Date */}
                <div>
                  <label className="mb-2 block text-sm font-semibold text-slate-700">
                    Date *
                  </label>

                  <input
                    type="date"
                    value={formData.date}
                    onChange={(event) =>
                      handleChange("date", event.target.value)
                    }
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100"
                  />
                </div>

                {/* Time */}
                <div>
                  <label className="mb-2 block text-sm font-semibold text-slate-700">
                    Departure Time *
                  </label>

                  <input
                    type="time"
                    value={formData.departureTime}
                    onChange={(event) =>
                      handleChange("departureTime", event.target.value)
                    }
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100"
                  />
                </div>

                {/* Status */}
                <div className="md:col-span-2">
                  <label className="mb-2 block text-sm font-semibold text-slate-700">
                    Status
                  </label>

                  <select
                    value={formData.status}
                    onChange={(event) =>
                      handleChange("status", event.target.value)
                    }
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100"
                  >
                    <option value="Assigned">Assigned</option>

                    <option value="Completed">Completed</option>

                    <option value="Cancelled">Cancelled</option>
                  </select>
                </div>
              </div>

              {/* Buttons */}
              <div className="flex justify-end gap-3 border-t border-slate-100 pt-5">
                <button
                  type="button"
                  onClick={handleCloseModal}
                  className="rounded-xl border border-slate-200 px-4 py-2.5 text-sm font-semibold text-slate-600 transition hover:bg-slate-50"
                >
                  Cancel
                </button>

                <button
                  type="submit"
                  className="rounded-xl bg-indigo-600 px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-indigo-700"
                >
                  {editingAssignment ? "Update Assignment" : "Assign Route"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
