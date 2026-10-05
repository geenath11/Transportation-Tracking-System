import React from "react";

import {
  Users,
  UserCheck,
  Contact,
  Bus,
  Route,
  Calendar,
  Ticket,
  AlertTriangle,
  ArrowUpRight,
  Clock,
  Activity,
} from "lucide-react";

import {
  User,
  Driver,
  Conductor,
  Vehicle,
  Route as TransitRoute,
  Timetable,
  Booking,
  Complaint,
  ActivityLog,
} from "../types";

interface DashboardProps {
  users: User[];
  drivers: Driver[];
  conductors: Conductor[];
  vehicles: Vehicle[];
  routes: TransitRoute[];
  timetables: Timetable[];
  bookings: Booking[];
  complaints: Complaint[];
  activityLogs: ActivityLog[];
  onPageChange: (page: string) => void;
}

export default function Dashboard({
  users,
  drivers,
  conductors,
  vehicles,
  routes,
  timetables,
  bookings,
  complaints,
  activityLogs,
  onPageChange,
}: DashboardProps) {
  /* =========================================================
     TOP STATISTICS
  ========================================================= */

  const stats = [
    {
      label: "Total Users",
      value: users.length,
      icon: Users,
      color: "bg-indigo-50 text-indigo-600 border-indigo-100",
      page: "users",
    },
    {
      label: "Total Drivers",
      value: drivers.length,
      icon: UserCheck,
      color: "bg-emerald-50 text-emerald-600 border-emerald-100",
      page: "drivers",
    },
    {
      label: "Total Conductors",
      value: conductors.length,
      icon: Contact,
      color: "bg-sky-50 text-sky-600 border-sky-100",
      page: "conductors",
    },
    {
      label: "Total Vehicles",
      value: vehicles.length,
      icon: Bus,
      color: "bg-amber-50 text-amber-600 border-amber-100",
      page: "vehicles",
    },
    {
      label: "Total Routes",
      value: routes.length,
      icon: Route,
      color: "bg-violet-50 text-violet-600 border-violet-100",
      page: "routes",
    },
    {
      label: "Total Timetables",
      value: timetables.length,
      icon: Calendar,
      color: "bg-fuchsia-50 text-fuchsia-600 border-fuchsia-100",
      page: "timetables",
    },
    {
      label: "Total Bookings",
      value: bookings.length,
      icon: Ticket,
      color: "bg-rose-50 text-rose-600 border-rose-100",
      page: "bookings",
    },
    {
      label: "Total Complaints",
      value: complaints.filter(
        (c) => c.status !== "Resolved"
      ).length,
      icon: AlertTriangle,
      color: "bg-orange-50 text-orange-600 border-orange-100",
      page: "complaints",
    },
  ];

  /* =========================================================
     VEHICLE STATUS
  ========================================================= */

  const runningBuses = vehicles.filter(
    (v) => v.status === "Running"
  );

  const stoppedBuses = vehicles.filter(
    (v) => v.status === "Stopped"
  );

  const maintenanceBuses = vehicles.filter(
    (v) => v.status === "Maintenance"
  );

  /* =========================================================
     TODAY'S BUS OPERATIONS
  ========================================================= */

  const todayOperations = {
    active: runningBuses.length,
    maintenance: maintenanceBuses.length,
    stopped: stoppedBuses.length,
    scheduled: timetables.length,
  };

  /* =========================================================
     TICKET STATUS
  ========================================================= */

  const ticketStatus = {
    total: bookings.length,

    confirmed: bookings.filter(
      (b) => b.ticketStatus === "Confirmed"
    ).length,

    pending: bookings.filter(
      (b) => b.ticketStatus === "Pending"
    ).length,

    cancelled: bookings.filter(
      (b) => b.ticketStatus === "Cancelled"
    ).length,
  };

  /* =========================================================
     FLEET AVAILABILITY
  ========================================================= */

  const fleetAvailability = {
    total: vehicles.length,
    running: runningBuses.length,
    stopped: stoppedBuses.length,
    maintenance: maintenanceBuses.length,
  };

  return (
    <div className="space-y-6">

      {/* =====================================================
          HEADER
      ===================================================== */}

      <div className="bg-gradient-to-r from-slate-900 to-indigo-950 p-6 rounded-2xl text-white shadow-xl flex flex-col md:flex-row md:items-center justify-between gap-4">

        <div>
          <h3 className="font-display font-bold text-xl md:text-2xl">
            Transit Command Dashboard
          </h3>

          <p className="text-slate-300 text-xs mt-1 max-w-xl">
            Real-time insights and monitoring console for public
            transport operators, drivers, vehicle allocations,
            and bookings.
          </p>
        </div>

        <div className="flex items-center gap-2 self-start md:self-center">

          <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />

          <span className="text-[10px] font-mono text-emerald-400 font-semibold tracking-wider">
            LIVE SYSTEM ACTIVE
          </span>

        </div>

      </div>

      {/* =====================================================
          TOP STATISTICS
          4 COLUMNS
      ===================================================== */}

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">

        {stats.map((stat, index) => {
          const Icon = stat.icon;

          return (
            <button
              key={index}
              onClick={() => onPageChange(stat.page)}
              className="text-left bg-white p-4 rounded-2xl border border-slate-100 hover:border-slate-300 shadow-xs hover:shadow-md transition-all duration-200 group flex flex-col justify-between"
            >

              <div className="flex items-center justify-between w-full">

                <div
                  className={`p-2 rounded-xl border ${stat.color} transition-all`}
                >
                  <Icon className="h-5 w-5" />
                </div>

                <ArrowUpRight className="h-4.5 w-4.5 text-slate-400 group-hover:text-slate-600 transition-all opacity-0 group-hover:opacity-100" />

              </div>

              <div className="mt-4">

                <p className="text-xs text-slate-400 font-medium">
                  {stat.label}
                </p>

                <h4 className="text-2xl font-bold font-display text-slate-900 mt-0.5">
                  {stat.value}
                </h4>

              </div>

            </button>
          );
        })}

      </div>

      {/* =====================================================
          OPERATIONS / BOOKINGS / FLEET
          
          6-COLUMN GRID
          
          Operations = 2 columns
          Booking    = 2 columns
          Fleet      = 2 columns
      ===================================================== */}

      <div className="grid grid-cols-1 md:grid-cols-6 gap-5">

        {/* ===================================================
            TODAY'S BUS OPERATIONS
            2 / 6 COLUMNS
        =================================================== */}

        <div className="md:col-span-2 bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">

          <div className="flex items-center justify-between mb-5">

            <div>
              <h4 className="text-sm font-semibold text-slate-800 font-display">
                Today's Bus Operations
              </h4>

              <p className="text-[10px] text-slate-400 mt-1">
                Current transportation activity
              </p>
            </div>

            <span className="px-2 py-0.5 rounded-md bg-indigo-50 text-[10px] font-medium text-indigo-600">
              Today
            </span>

          </div>

          <div className="grid grid-cols-2 gap-3">

            {/* Active */}

            <div className="p-3 rounded-xl bg-emerald-50">

              <p className="text-[10px] text-emerald-600 font-medium">
                Active Trips
              </p>

              <p className="text-2xl font-bold text-emerald-700 mt-1">
                {todayOperations.active}
              </p>

            </div>

            {/* Scheduled */}

            <div className="p-3 rounded-xl bg-indigo-50">

              <p className="text-[10px] text-indigo-600 font-medium">
                Scheduled
              </p>

              <p className="text-2xl font-bold text-indigo-700 mt-1">
                {todayOperations.scheduled}
              </p>

            </div>

            {/* Stopped */}

            <div className="p-3 rounded-xl bg-slate-50">

              <p className="text-[10px] text-slate-500 font-medium">
                Stopped
              </p>

              <p className="text-2xl font-bold text-slate-700 mt-1">
                {todayOperations.stopped}
              </p>

            </div>

            {/* Maintenance */}

            <div className="p-3 rounded-xl bg-amber-50">

              <p className="text-[10px] text-amber-600 font-medium">
                Maintenance
              </p>

              <p className="text-2xl font-bold text-amber-700 mt-1">
                {todayOperations.maintenance}
              </p>

            </div>

          </div>

        </div>

        {/* ===================================================
            TICKET & BOOKING STATUS
            2 / 6 COLUMNS
        =================================================== */}

        <div className="md:col-span-2 bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">

          <div className="flex items-center justify-between mb-5">

            <div>
              <h4 className="text-sm font-semibold text-slate-800 font-display">
                Ticket & Booking Status
              </h4>

              <p className="text-[10px] text-slate-400 mt-1">
                Current booking activity
              </p>
            </div>

            <span className="px-2 py-0.5 rounded-md bg-indigo-50 text-[10px] font-medium text-indigo-600">
              Live
            </span>

          </div>

          {/* Total */}

          <div className="p-4 rounded-xl bg-slate-50 mb-3">

            <p className="text-[10px] text-slate-500 font-medium">
              Total Bookings
            </p>

            <p className="text-3xl font-bold text-slate-900 mt-1">
              {ticketStatus.total}
            </p>

          </div>

          {/* Status */}

          <div className="grid grid-cols-3 gap-2">

            {/* Confirmed */}

            <div className="text-center p-2 rounded-lg bg-emerald-50">

              <p className="text-lg font-bold text-emerald-700">
                {ticketStatus.confirmed}
              </p>

              <p className="text-[9px] text-emerald-600">
                Confirmed
              </p>

            </div>

            {/* Pending */}

            <div className="text-center p-2 rounded-lg bg-amber-50">

              <p className="text-lg font-bold text-amber-700">
                {ticketStatus.pending}
              </p>

              <p className="text-[9px] text-amber-600">
                Pending
              </p>

            </div>

            {/* Cancelled */}

            <div className="text-center p-2 rounded-lg bg-rose-50">

              <p className="text-lg font-bold text-rose-700">
                {ticketStatus.cancelled}
              </p>

              <p className="text-[9px] text-rose-600">
                Cancelled
              </p>

            </div>

          </div>

        </div>

        {/* ===================================================
            FLEET AVAILABILITY
            2 / 6 COLUMNS
        =================================================== */}

        <div className="md:col-span-2 bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">

          <div className="flex items-center justify-between mb-5">

            <div>
              <h4 className="text-sm font-semibold text-slate-800 font-display">
                Fleet Availability
              </h4>

              <p className="text-[10px] text-slate-400 mt-1">
                Current vehicle availability
              </p>
            </div>

            <span className="px-2 py-0.5 rounded-md bg-emerald-50 text-[10px] font-medium text-emerald-600">
              Active Fleet
            </span>

          </div>

          {/* Total buses */}

          <div className="flex items-center justify-center mb-5">

            <div className="h-32 w-32 rounded-full border-[12px] border-indigo-100 flex flex-col items-center justify-center">

              <span className="text-3xl font-bold text-slate-900">
                {fleetAvailability.total}
              </span>

              <span className="text-[9px] text-slate-400">
                Total Buses
              </span>

            </div>

          </div>

          {/* Fleet breakdown */}

          <div className="grid grid-cols-3 gap-2">

            {/* Running */}

            <div className="text-center">

              <p className="text-sm font-bold text-emerald-600">
                {fleetAvailability.running}
              </p>

              <p className="text-[9px] text-slate-400">
                On Trip
              </p>

            </div>

            {/* Stopped */}

            <div className="text-center">

              <p className="text-sm font-bold text-slate-600">
                {fleetAvailability.stopped}
              </p>

              <p className="text-[9px] text-slate-400">
                Stopped
              </p>

            </div>

            {/* Maintenance */}

            <div className="text-center">

              <p className="text-sm font-bold text-amber-600">
                {fleetAvailability.maintenance}
              </p>

              <p className="text-[9px] text-slate-400">
                Maintenance
              </p>

            </div>

          </div>

        </div>

      </div>

      {/* =====================================================
          LIVE BUS ALLOCATIONS + RECENT ACTIVITY

          6-COLUMN GRID

          Live Bus       = 3 columns
          Recent Activity = 3 columns
      ===================================================== */}

      <div className="grid grid-cols-1 md:grid-cols-6 gap-5">

        {/* ===================================================
            LIVE BUS ALLOCATIONS
            3 / 6 COLUMNS
        =================================================== */}

        <div className="md:col-span-3 bg-white p-5 rounded-2xl border border-slate-150 shadow-xs flex flex-col min-w-0">

          {/* Header */}

          <div className="flex items-center justify-between mb-4">

            <div className="flex items-center gap-2 min-w-0">

              <Activity className="h-4.5 w-4.5 text-indigo-600 shrink-0" />

              <div className="min-w-0">

                <h4 className="text-sm font-semibold text-slate-800 font-display">
                  Live Bus Allocations
                </h4>

                <p className="text-[10px] text-slate-400 truncate">
                  Currently assigned buses and active routes
                </p>

              </div>

            </div>

            <button
              onClick={() => onPageChange("bus-allocation")}
              className="text-[10px] font-semibold text-indigo-600 hover:text-indigo-700 shrink-0"
            >
              Manage
            </button>

          </div>

          {/* Table */}

          <div className="overflow-x-auto flex-1">

            <table className="w-full text-left text-xs">

              <thead>

                <tr className="bg-slate-50 text-slate-500 font-medium border-b border-slate-150">

                  <th className="py-2.5 px-3 rounded-l-lg">
                    Bus Plate
                  </th>

                  <th className="py-2.5 px-3">
                    Driver
                  </th>

                  <th className="py-2.5 px-3">
                    Route
                  </th>

                  <th className="py-2.5 px-3">
                    Departure
                  </th>

                  <th className="py-2.5 px-3 rounded-r-lg text-right">
                    Status
                  </th>

                </tr>

              </thead>

              <tbody className="divide-y divide-slate-100">

                {timetables
                  .filter(
                    (t) =>
                      t.vehicleNumber &&
                      t.routeNumber
                  )
                  .slice(0, 5)
                  .map((t, index) => (

                    <tr
                      key={`${t.vehicleNumber}-${t.routeNumber}-${index}`}
                      className="hover:bg-slate-50/55 transition-all"
                    >

                      <td className="py-3 px-3 font-mono font-semibold text-slate-700">
                        {t.vehicleNumber}
                      </td>

                      <td className="py-3 px-3 text-slate-600 font-medium">
                        {t.driverName || "Unassigned"}
                      </td>

                      <td className="py-3 px-3 text-slate-500">
                        Route {t.routeNumber}
                      </td>

                      <td className="py-3 px-3 text-slate-500">
                        {t.departureTime || "--"}
                      </td>

                      <td className="py-3 px-3 text-right">

                        <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-semibold bg-emerald-50 text-emerald-700">

                          <span className="h-1.5 w-1.5 rounded-full bg-emerald-500" />

                          Active

                        </span>

                      </td>

                    </tr>

                  ))}

                {timetables.length === 0 && (

                  <tr>

                    <td
                      colSpan={5}
                      className="py-8 text-center text-slate-400 font-mono"
                    >
                      No bus allocations available.
                    </td>

                  </tr>

                )}

              </tbody>

            </table>

          </div>

        </div>

        {/* ===================================================
            RECENT ACTIVITY
            3 / 6 COLUMNS
        =================================================== */}

        <div className="md:col-span-3 bg-white rounded-2xl border border-slate-150 shadow-xs overflow-hidden min-w-0">

          {/* Header */}

          <div className="flex items-center justify-between px-5 py-4 border-b border-slate-100">

            <div className="flex items-center gap-2 min-w-0">

              <div className="h-8 w-8 rounded-lg bg-indigo-50 flex items-center justify-center shrink-0">

                <Clock className="h-4 w-4 text-indigo-600" />

              </div>

              <div className="min-w-0">

                <h4 className="text-sm font-semibold text-slate-800 font-display">
                  Recent Activity
                </h4>

                <p className="text-[10px] text-slate-400 truncate">
                  Latest system activities
                </p>

              </div>

            </div>

            <span className="px-2 py-1 rounded-md bg-slate-50 text-[10px] font-medium text-slate-500 shrink-0">
              Latest 5
            </span>

          </div>

          {/* Activity List */}

          <div className="divide-y divide-slate-100">

            {activityLogs
              .slice(0, 5)
              .map((log, index) => (

                <div
                  key={index}
                  className="flex items-center gap-3 px-5 py-3 hover:bg-slate-50 transition-colors"
                >

                  {/* Number */}

                  <div className="h-7 w-7 shrink-0 rounded-full bg-slate-100 flex items-center justify-center text-[10px] font-semibold text-slate-500">
                    {index + 1}
                  </div>

                  {/* Content */}

                  <div className="flex-1 min-w-0">

                    <div className="flex items-center justify-between gap-3">

                      <p className="text-xs font-semibold text-slate-800 truncate">
                        {log.action}
                      </p>

                      <span className="text-[10px] font-mono text-slate-400 shrink-0">

                        {new Date(
                          log.timestamp
                        ).toLocaleTimeString("en-US", {
                          hour12: false,
                        })}

                      </span>

                    </div>

                    <p className="text-[10px] text-slate-500 mt-0.5 truncate">
                      {log.details}
                    </p>

                    <p className="text-[9px] font-mono text-indigo-500 mt-0.5 truncate">
                      By: {log.operator}
                    </p>

                  </div>

                </div>

              ))}

            {/* Empty state */}

            {activityLogs.length === 0 && (

              <div className="py-8 text-center">

                <Clock className="h-7 w-7 mx-auto text-slate-300 mb-2" />

                <p className="text-xs font-medium text-slate-500">
                  No recent activity
                </p>

                <p className="text-[10px] text-slate-400 mt-1">
                  Admin activities will appear here.
                </p>

              </div>

            )}

          </div>

        </div>

      </div>

    </div>
  );
}