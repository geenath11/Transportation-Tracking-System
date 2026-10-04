import React, { useState } from "react";
import {
  Search,
  Plus,
  Edit,
  Trash2,
  Milestone,
  Clock,
  MapPin,
  X,
} from "lucide-react";

import { Route, RouteStop } from "../types";

interface RoutesProps {
  routes: Route[];
  onCreate: (data: Route) => Promise<void>;
  onUpdate: (id: string, data: Route) => Promise<void>;
  onDelete: (id: string) => void | Promise<void>;
}

interface RouteFormData {
  routeNumber: string;
  start: string;
  destination: string;
  distance: number;
  stops: RouteStop[];
}

const createEmptyForm = (): RouteFormData => ({
  routeNumber: "",
  start: "",
  destination: "",
  distance: 0,
  stops: [
    {
      name: "",
      eta: "",
    },
  ],
});

export default function Routes({
  routes,
  onCreate,
  onUpdate,
  onDelete,
}: RoutesProps) {
  const [search, setSearch] = useState("");

  const [sortField, setSortField] = useState<
    "routeNumber" | "start" | "destination" | "distance"
  >("routeNumber");

  const [sortAsc, setSortAsc] = useState(true);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingRoute, setEditingRoute] = useState<Route | null>(null);

  const [formData, setFormData] =
    useState<RouteFormData>(createEmptyForm());

  const [errorMsg, setErrorMsg] = useState("");

  const [currentPage, setCurrentPage] = useState(1);

  const itemsPerPage = 6;

  /* =====================================================
     SORTING
  ===================================================== */

  const handleSort = (
    field: "routeNumber" | "start" | "destination" | "distance"
  ) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(true);
    }
  };

  /* =====================================================
     ADD ROUTE
  ===================================================== */

  const handleOpenAdd = () => {
    setEditingRoute(null);
    setFormData(createEmptyForm());
    setErrorMsg("");
    setIsModalOpen(true);
  };

  /* =====================================================
     EDIT ROUTE
  ===================================================== */

  const handleOpenEdit = (route: Route) => {
  setEditingRoute(route);

  setFormData({
    routeNumber: String(
      route.routeNumber ??
        route.route ??
        route.serviceName ??
        ""
    ),

    start: String(
      route.start ??
        route.departureCity ??
        ""
    ),

    destination: String(
      route.destination ??
        route.arrivalCity ??
        ""
    ),

    distance: Number(
      route.distance ??
        route.distanceKm ??
        0
    ),

    stops:
      Array.isArray(route.stops) &&
      route.stops.length > 0
        ? route.stops.map((stop) => ({
            name: String(stop?.name ?? ""),
            eta: String(stop?.eta ?? ""),
          }))
        : [
            {
              name: "",
              eta: "",
            },
          ],
  });

  setErrorMsg("");
  setIsModalOpen(true);
};

  /* =====================================================
     STOP MANAGEMENT
  ===================================================== */

  const handleStopChange = (
    index: number,
    field: keyof RouteStop,
    value: string
  ) => {
    setFormData((prev) => {
      const updatedStops = [...prev.stops];

      updatedStops[index] = {
        ...updatedStops[index],
        [field]: value,
      };

      return {
        ...prev,
        stops: updatedStops,
      };
    });
  };

  const handleAddStop = () => {
    setFormData((prev) => ({
      ...prev,
      stops: [
        ...prev.stops,
        {
          name: "",
          eta: "",
        },
      ],
    }));
  };

  const handleRemoveStop = (index: number) => {
    setFormData((prev) => {
      if (prev.stops.length === 1) {
        return prev;
      }

      return {
        ...prev,
        stops: prev.stops.filter(
          (_, stopIndex) => stopIndex !== index
        ),
      };
    });
  };

  /* =====================================================
     SUBMIT
  ===================================================== */

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    setErrorMsg("");

    const validStops = formData.stops.filter(
      (stop) =>
        stop.name.trim() !== "" &&
        stop.eta.trim() !== ""
    );

    if (
      !formData.routeNumber.trim() ||
      !formData.start.trim() ||
      !formData.destination.trim() ||
      formData.distance <= 0
    ) {
      setErrorMsg(
        "Please complete all route fields correctly."
      );
      return;
    }

    if (validStops.length === 0) {
      setErrorMsg(
        "Please add at least one valid stop with a name and ETA."
      );
      return;
    }

    const routeData: Route = {
      routeNumber: formData.routeNumber.trim(),
      start: formData.start.trim(),
      destination: formData.destination.trim(),
      distance: formData.distance,

      stops: validStops.map((stop) => ({
        name: stop.name.trim(),
        eta: stop.eta.trim(),
      })),
    };

    try {
      if (editingRoute?.id) {
        await onUpdate(
          editingRoute.id,
          routeData
        );
      } else {
        await onCreate(routeData);
      }

      setIsModalOpen(false);
      setEditingRoute(null);
      setFormData(createEmptyForm());
    } catch (err) {
      console.error(err);
      setErrorMsg(
        "Failed to save route. Try again."
      );
    }
  };

  /* =====================================================
     FILTER + SORT
  ===================================================== */

  /*
   * Firestore is not runtime type-safe.
   * A document may be missing fields even though
   * the TypeScript Route interface requires them.
   *
   * Normalize every route before filtering, sorting,
   * and rendering.
   */
interface DisplayRoute {
  id?: string;

  routeNumber: string;
  start: string;
  destination: string;
  distance: number;
  stops: RouteStop[];

  departureTime: string;
  arrivalTime: string;
  busType: string;
  serviceName: string;
  duration: string;
}

const normalizedRoutes: DisplayRoute[] = routes.map((route) => {
  const routeNumber = String(
    route.routeNumber ??
      route.route ??
      route.serviceName ??
      ""
  );

  const start = String(
    route.start ??
      route.departureCity ??
      ""
  );

  const destination = String(
    route.destination ??
      route.arrivalCity ??
      ""
  );

  const distance = Number(
    route.distance ??
      route.distanceKm ??
      0
  );

  const stops: RouteStop[] = Array.isArray(route.stops)
    ? route.stops.map((stop) => ({
        name: String(stop?.name ?? ""),
        eta: String(stop?.eta ?? ""),
      }))
    : [];

  return {
    id: route.id,

    routeNumber,
    start,
    destination,
    distance,
    stops,

    departureTime: String(
      route.departureTime ?? ""
    ),

    arrivalTime: String(
      route.arrivalTime ?? ""
    ),

    busType: String(
      route.busType ?? ""
    ),

    serviceName: String(
      route.serviceName ?? ""
    ),

    duration: String(
      route.duration ?? ""
    ),
  };
});

  const filteredRoutes = normalizedRoutes
    .filter((route) => {
      const searchValue =
        search.toLowerCase().trim();

      if (!searchValue) {
        return true;
      }

      const stopSearchText =
        route.stops
          .map(
            (stop) =>
              `${stop.name} ${stop.eta}`
          )
          .join(" ")
          .toLowerCase();

      return (
        route.routeNumber
          .toLowerCase()
          .includes(searchValue) ||
        route.start
          .toLowerCase()
          .includes(searchValue) ||
        route.destination
          .toLowerCase()
          .includes(searchValue) ||
        String(route.distance)
          .toLowerCase()
          .includes(searchValue) ||
        stopSearchText.includes(searchValue)
      );
    })
    .sort((a, b) => {
      let valueA: string | number;
      let valueB: string | number;

      switch (sortField) {
        case "distance":
          valueA = a.distance;
          valueB = b.distance;
          break;

        case "start":
          valueA =
            a.start.toLowerCase();
          valueB =
            b.start.toLowerCase();
          break;

        case "destination":
          valueA =
            a.destination.toLowerCase();
          valueB =
            b.destination.toLowerCase();
          break;

        case "routeNumber":
        default:
          valueA =
            a.routeNumber.toLowerCase();
          valueB =
            b.routeNumber.toLowerCase();
          break;
      }

      if (valueA < valueB) {
        return sortAsc ? -1 : 1;
      }

      if (valueA > valueB) {
        return sortAsc ? 1 : -1;
      }

      return 0;
    });

  /* =====================================================
     PAGINATION
  ===================================================== */

  const totalPages =
    Math.ceil(
      filteredRoutes.length /
        itemsPerPage
    ) || 1;

  const paginatedRoutes =
    filteredRoutes.slice(
      (currentPage - 1) *
        itemsPerPage,
      currentPage * itemsPerPage
    );

  /* =====================================================
     RENDER
  ===================================================== */

  return (
    <div className="space-y-6">

      {/* =================================================
          TOP SEARCH BAR
      ================================================= */}

      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-4 rounded-2xl border border-slate-150 shadow-xs">

        <div className="flex flex-1 items-center gap-3 max-w-lg">

          <div className="relative flex-1">

            <Search className="h-4 w-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />

            <input
              type="text"
              placeholder="Search route, city, stop..."
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

      {/* =================================================
          SORT BUTTONS
      ================================================= */}

      <div className="flex flex-wrap items-center gap-2">

        <span className="text-[10px] font-semibold text-slate-400 uppercase">
          Sort:
        </span>

        <button
          onClick={() =>
            handleSort("routeNumber")
          }
          className={`px-3 py-1.5 rounded-lg text-[10px] font-semibold transition-all ${
            sortField === "routeNumber"
              ? "bg-indigo-100 text-indigo-700"
              : "bg-white text-slate-500 border border-slate-200"
          }`}
        >
          Route
        </button>

        <button
          onClick={() =>
            handleSort("start")
          }
          className={`px-3 py-1.5 rounded-lg text-[10px] font-semibold transition-all ${
            sortField === "start"
              ? "bg-indigo-100 text-indigo-700"
              : "bg-white text-slate-500 border border-slate-200"
          }`}
        >
          Start
        </button>

        <button
          onClick={() =>
            handleSort("destination")
          }
          className={`px-3 py-1.5 rounded-lg text-[10px] font-semibold transition-all ${
            sortField === "destination"
              ? "bg-indigo-100 text-indigo-700"
              : "bg-white text-slate-500 border border-slate-200"
          }`}
        >
          Destination
        </button>

        <button
          onClick={() =>
            handleSort("distance")
          }
          className={`px-3 py-1.5 rounded-lg text-[10px] font-semibold transition-all ${
            sortField === "distance"
              ? "bg-indigo-100 text-indigo-700"
              : "bg-white text-slate-500 border border-slate-200"
          }`}
        >
          Distance
        </button>

      </div>

      {/* =================================================
          ROUTES GRID
      ================================================= */}

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
                      Route {route.routeNumber}
                    </span>

                    <div className="flex items-center gap-1 text-[10px] text-slate-500 font-mono">

                      <Milestone className="h-3 w-3 text-slate-400" />

                      <span>
                        {route.distance} km
                      </span>

                    </div>

                  </div>

                  <h3 className="mt-2 text-sm font-bold text-slate-900 truncate">
                    {route.start} → {route.destination}
                  </h3>

                  <p className="text-[10px] text-slate-500 font-mono mt-1 truncate">
                    {route.routeNumber}
                  </p>

                </div>

                {/* Actions */}

                <div className="space-x-1 opacity-0 group-hover:opacity-100 transition-all shrink-0">

                  <button
                    onClick={() =>
                      handleOpenEdit(route)
                    }
                    className="p-1.5 text-slate-400 hover:text-indigo-600 rounded-lg hover:bg-slate-50 inline-flex"
                    title="Edit route"
                  >
                    <Edit className="h-4 w-4" />
                  </button>

                  <button
                    onClick={() =>
                      route.id &&
                      onDelete(route.id)
                    }
                    className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-slate-50 inline-flex"
                    title="Delete route"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>

                </div>

              </div>

              {/* Journey Details */}

              <div className="mt-4 bg-slate-50 p-3 rounded-xl border border-slate-100">

                <div className="flex items-center justify-between">

                  {/* Start */}

                  <div>

                    <p className="text-[10px] text-slate-400 font-medium">
                      START
                    </p>

                    <div className="flex items-center gap-1.5 mt-1">

                      <MapPin className="h-3.5 w-3.5 text-indigo-500" />

                      <p className="text-xs font-bold text-slate-800">
                        {route.start}
                      </p>

                    </div>

                  </div>

                  <span className="text-slate-300 font-mono text-lg">
                    ⟶
                  </span>

                  {/* Destination */}

                  <div className="text-right">

                    <p className="text-[10px] text-slate-400 font-medium">
                      DESTINATION
                    </p>

                    <div className="flex items-center justify-end gap-1.5 mt-1">

                      <p className="text-xs font-bold text-slate-800">
                        {route.destination}
                      </p>

                      <MapPin className="h-3.5 w-3.5 text-indigo-500" />

                    </div>

                  </div>

                </div>

              </div>

              {/* Stops */}

              <div className="mt-4">

                <div className="flex items-center justify-between mb-2">

                  <div className="flex items-center gap-1.5">

                    <Milestone className="h-3.5 w-3.5 text-indigo-500" />

                    <p className="text-[10px] text-slate-400 font-semibold">
                      STOPS
                    </p>

                  </div>

                  <span className="text-[10px] text-slate-400 font-mono">
                    {route.stops?.length || 0} stops
                  </span>

                </div>

                <div className="space-y-2">

                  {route.stops?.map(
                    (stop, index) => (

                      <div
                        key={`${route.id}-stop-${index}`}
                        className="flex items-center justify-between bg-white border border-slate-100 rounded-xl px-3 py-2"
                      >

                        <div className="flex items-center gap-2">

                          <span className="w-5 h-5 rounded-full bg-indigo-50 text-indigo-600 flex items-center justify-center text-[9px] font-bold">
                            {index + 1}
                          </span>

                          <span className="text-xs font-medium text-slate-700">
                            {String(
                              stop?.name ?? ""
                            )}
                          </span>

                        </div>

                        <div className="flex items-center gap-1 text-[10px] text-slate-400 font-mono">

                          <Clock className="h-3 w-3" />

                          {String(
                            stop?.eta ?? ""
                          )}

                        </div>

                      </div>

                    )
                  )}

                </div>

              </div>

            </div>

          </div>

        ))}

        {/* Empty State */}

        {filteredRoutes.length === 0 && (

          <div className="col-span-1 md:col-span-2 bg-white p-12 text-center text-slate-400 font-mono rounded-2xl border border-slate-150">
            No transit routes found.
          </div>

        )}

      </div>

      {/* =================================================
          PAGINATION
      ================================================= */}

      {filteredRoutes.length > 0 && (

        <div className="bg-white px-6 py-4 border border-slate-150 rounded-2xl flex items-center justify-between shadow-xs">

          <p className="text-slate-500 text-xs font-medium">

            Showing{" "}
            {(currentPage - 1) *
              itemsPerPage +
              1}{" "}
            to{" "}
            {Math.min(
              currentPage * itemsPerPage,
              filteredRoutes.length
            )}{" "}
            of {filteredRoutes.length} routes

          </p>

          <div className="flex items-center gap-2">

            <button
              onClick={() =>
                setCurrentPage((prev) =>
                  Math.max(prev - 1, 1)
                )
              }
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
                setCurrentPage((prev) =>
                  Math.min(
                    prev + 1,
                    totalPages
                  )
                )
              }
              disabled={
                currentPage === totalPages
              }
              className="px-3 py-1.5 text-xs font-semibold border border-slate-200 rounded-xl hover:bg-slate-50 disabled:opacity-50 disabled:pointer-events-none transition-all"
            >
              Next
            </button>

          </div>

        </div>

      )}

      {/* =================================================
          CREATE / EDIT MODAL
      ================================================= */}

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
                  ? "Modify Route"
                  : "Create Transport Route"}
              </h3>

              <button
                type="button"
                onClick={() =>
                  setIsModalOpen(false)
                }
                className="text-slate-400 hover:text-slate-600"
              >
                <X className="h-4 w-4" />
              </button>

            </div>

            {/* Modal Body */}

            <div className="p-6 space-y-4 max-h-[600px] overflow-y-auto">

              {errorMsg && (

                <div className="p-3 bg-rose-50 text-rose-700 rounded-xl text-xs border border-rose-100 font-medium">
                  {errorMsg}
                </div>

              )}

              {/* Route Number */}

              <div className="space-y-1.5">

                <label className="text-xs font-semibold text-slate-700 block">
                  Route Number
                </label>

                <input
                  type="text"
                  required
                  placeholder="e.g. 01"
                  value={formData.routeNumber}
                  onChange={(e) =>
                    setFormData({
                      ...formData,
                      routeNumber:
                        e.target.value,
                    })
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />

              </div>

              {/* Start / Destination */}

              <div className="grid grid-cols-2 gap-4">

                <div className="space-y-1.5">

                  <label className="text-xs font-semibold text-slate-700 block">
                    Start
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. Colombo"
                    value={formData.start}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        start: e.target.value,
                      })
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />

                </div>

                <div className="space-y-1.5">

                  <label className="text-xs font-semibold text-slate-700 block">
                    Destination
                  </label>

                  <input
                    type="text"
                    required
                    placeholder="e.g. Kandy"
                    value={formData.destination}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        destination:
                          e.target.value,
                      })
                    }
                    className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500"
                  />

                </div>

              </div>

              {/* Distance */}

              <div className="space-y-1.5">

                <label className="text-xs font-semibold text-slate-700 block">
                  Distance (km)
                </label>

                <input
                  type="number"
                  required
                  min={1}
                  value={formData.distance}
                  onChange={(e) =>
                    setFormData({
                      ...formData,
                      distance:
                        parseInt(
                          e.target.value
                        ) || 0,
                    })
                  }
                  className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                />

              </div>

              {/* Stops */}

              <div className="space-y-3">

                <div className="flex items-center justify-between">

                  <div>

                    <label className="text-xs font-semibold text-slate-700 block">
                      Route Stops
                    </label>

                    <p className="text-[10px] text-slate-400 mt-1">
                      Add each stop and its estimated arrival time.
                    </p>

                  </div>

                  <button
                    type="button"
                    onClick={handleAddStop}
                    className="flex items-center gap-1.5 px-3 py-1.5 bg-indigo-50 text-indigo-600 hover:bg-indigo-100 rounded-lg text-[10px] font-semibold"
                  >
                    <Plus className="h-3 w-3" />
                    Add Stop
                  </button>

                </div>

                <div className="space-y-3">

                  {formData.stops.map(
                    (stop, index) => (

                      <div
                        key={index}
                        className="p-3 bg-slate-50 border border-slate-200 rounded-xl"
                      >

                        <div className="flex items-center justify-between mb-2">

                          <span className="text-[10px] font-semibold text-slate-500">
                            STOP {index + 1}
                          </span>

                          {formData.stops.length > 1 && (

                            <button
                              type="button"
                              onClick={() =>
                                handleRemoveStop(
                                  index
                                )
                              }
                              className="text-slate-400 hover:text-rose-600"
                              title="Remove stop"
                            >
                              <X className="h-3.5 w-3.5" />
                            </button>

                          )}

                        </div>

                        <div className="grid grid-cols-2 gap-3">

                          {/* Stop Name */}

                          <div className="space-y-1">

                            <label className="text-[10px] font-medium text-slate-500">
                              Stop Name
                            </label>

                            <input
                              type="text"
                              placeholder="e.g. Kadawatha"
                              value={String(
                                stop?.name ?? ""
                              )}
                              onChange={(e) =>
                                handleStopChange(
                                  index,
                                  "name",
                                  e.target.value
                                )
                              }
                              className="w-full px-3 py-2 text-xs border border-slate-200 bg-white rounded-lg focus:outline-none focus:ring-1 focus:ring-indigo-500"
                            />

                          </div>

                          {/* ETA */}

                          <div className="space-y-1">

                            <label className="text-[10px] font-medium text-slate-500">
                              ETA
                            </label>

                            <input
                              type="text"
                              placeholder="e.g. 15 mins"
                              value={String(
                                stop?.eta ?? ""
                              )}
                              onChange={(e) =>
                                handleStopChange(
                                  index,
                                  "eta",
                                  e.target.value
                                )
                              }
                              className="w-full px-3 py-2 text-xs border border-slate-200 bg-white rounded-lg focus:outline-none focus:ring-1 focus:ring-indigo-500 font-mono"
                            />

                          </div>

                        </div>

                      </div>

                    )
                  )}

                </div>

              </div>

            </div>

            {/* Modal Footer */}

            <div className="px-6 py-4 bg-slate-50 border-t border-slate-100 flex justify-end gap-3">

              <button
                type="button"
                onClick={() =>
                  setIsModalOpen(false)
                }
                className="px-4 py-2 text-xs font-semibold text-slate-700 bg-white border border-slate-200 rounded-xl hover:bg-slate-50"
              >
                Cancel
              </button>

              <button
                type="submit"
                className="px-4 py-2 text-xs font-semibold text-white bg-indigo-600 hover:bg-indigo-700 rounded-xl shadow-lg shadow-indigo-600/15"
              >
                {editingRoute
                  ? "Save Route"
                  : "Create Route"}
              </button>

            </div>

          </form>

        </div>

      )}

    </div>
  );
}