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
  TrendingUp,
  MapPin,
  Clock,
  Activity
} from "lucide-react";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement
} from 'chart.js';
import { Bar, Doughnut, Line } from 'react-chartjs-2';

import { 
  User, 
  Driver, 
  Conductor, 
  Vehicle, 
  Route as TransitRoute, 
  Timetable, 
  Booking, 
  Complaint,
  ActivityLog
} from "../types";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement
);

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
  onPageChange
}: DashboardProps) {

  // Statistics Calculation
  const stats = [
    { label: "Total Users", value: users.length, icon: Users, color: "bg-indigo-50 text-indigo-600 border-indigo-100", page: "users" },
    { label: "Total Drivers", value: drivers.length, icon: UserCheck, color: "bg-emerald-50 text-emerald-600 border-emerald-100", page: "drivers" },
    { label: "Total Conductors", value: conductors.length, icon: Contact, color: "bg-sky-50 text-sky-600 border-sky-100", page: "conductors" },
    { label: "Total Vehicles", value: vehicles.length, icon: Bus, color: "bg-amber-50 text-amber-600 border-amber-100", page: "vehicles" },
    { label: "Total Routes", value: routes.length, icon: Route, color: "bg-violet-50 text-violet-600 border-violet-100", page: "routes" },
    { label: "Total Timetables", value: timetables.length, icon: Calendar, color: "bg-fuchsia-50 text-fuchsia-600 border-fuchsia-100", page: "timetables" },
    { label: "Total Bookings", value: bookings.length, icon: Ticket, color: "bg-rose-50 text-rose-600 border-rose-100", page: "bookings" },
    { label: "Total Complaints", value: complaints.filter(c => c.status !== "Resolved").length, icon: AlertTriangle, color: "bg-orange-50 text-orange-600 border-orange-100", page: "complaints" },
  ];

  // Helper statuses
  const runningBuses = vehicles.filter(v => v.status === "Running");
  const stoppedBuses = vehicles.filter(v => v.status === "Stopped");
  const maintenanceBuses = vehicles.filter(v => v.status === "Maintenance");

  // Chart 1: Passenger Activity (Monday - Sunday)
  const passengerActivityData = {
    labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
    datasets: [
      {
        label: "Weekly Passengers",
        data: [1200, 1500, 1400, 1650, 1800, 2200, 1950],
        borderColor: "rgb(79, 70, 229)",
        backgroundColor: "rgba(79, 70, 229, 0.1)",
        tension: 0.4,
        fill: true,
      }
    ]
  };

  // Chart 2: Vehicle Status Doughnut
  const vehicleStatusData = {
    labels: ["Running", "Stopped", "Maintenance"],
    datasets: [
      {
        data: [
          runningBuses.length || 3, 
          stoppedBuses.length || 2, 
          maintenanceBuses.length || 1
        ],
        backgroundColor: [
          "rgba(16, 185, 129, 0.8)", // Emerald
          "rgba(239, 68, 68, 0.8)",  // Red
          "rgba(245, 158, 11, 0.8)"  // Amber
        ],
        borderColor: ["#fff", "#fff", "#fff"],
        borderWidth: 2,
      }
    ]
  };

  // Chart 3: Bookings Overview (Daily, Weekly, Monthly)
  const bookingsOverviewData = {
    labels: ["Daily", "Weekly", "Monthly"],
    datasets: [
      {
        label: "Bookings Volume",
        data: [
          bookings.length * 8, 
          bookings.length * 48, 
          bookings.length * 192
        ],
        backgroundColor: [
          "rgba(99, 102, 241, 0.85)", 
          "rgba(139, 92, 246, 0.85)", 
          "rgba(236, 72, 153, 0.85)"
        ],
        borderRadius: 8,
      }
    ]
  };

  const chartOptions = {
    responsive: true,
    plugins: {
      legend: {
        display: false,
      }
    },
    scales: {
      y: {
        grid: {
          color: "#f1f5f9",
        },
        ticks: {
          font: {
            family: "Inter"
          }
        }
      },
      x: {
        grid: {
          display: false,
        },
        ticks: {
          font: {
            family: "Inter"
          }
        }
      }
    }
  };

  return (
    <div className="space-y-6">
      {/* Dynamic Header Section */}
      <div className="bg-gradient-to-r from-slate-900 to-indigo-950 p-6 rounded-2xl text-white shadow-xl flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h3 className="font-display font-bold text-xl md:text-2xl">Transit Command Dashboard</h3>
          <p className="text-slate-300 text-xs mt-1 max-w-xl">
            Real-time insights and monitoring console for public transport operators, drivers, vehicle allocations, and bookings.
          </p>
        </div>
        <div className="flex items-center gap-2 self-start md:self-center">
          <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
          <span className="text-[10px] font-mono text-emerald-400 font-semibold tracking-wider">LIVE SYSTEM ACTIVE</span>
        </div>
      </div>

      {/* Grid of Statistical Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        {stats.map((stat, i) => {
          const Icon = stat.icon;
          return (
            <button
              key={i}
              onClick={() => onPageChange(stat.page)}
              className="text-left bg-white p-4 rounded-2xl border border-slate-100 hover:border-slate-300 shadow-xs hover:shadow-md transition-all duration-200 group flex flex-col justify-between"
            >
              <div className="flex items-center justify-between w-full">
                <div className={`p-2 rounded-xl border ${stat.color} transition-all`}>
                  <Icon className="h-5 w-5" />
                </div>
                <ArrowUpRight className="h-4.5 w-4.5 text-slate-400 group-hover:text-slate-600 transition-all opacity-0 group-hover:opacity-100" />
              </div>
              <div className="mt-4">
                <p className="text-xs text-slate-400 font-medium">{stat.label}</p>
                <div className="flex items-baseline gap-2">
                  <h4 className="text-2xl font-bold font-display text-slate-900 mt-0.5">{stat.value}</h4>
                  <span className="text-[10px] text-emerald-600 font-semibold flex items-center gap-0.5">
                    <TrendingUp className="h-3 w-3" />
                    +4%
                  </span>
                </div>
              </div>
            </button>
          );
        })}
      </div>

      {/* Charts Roster */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Passenger Activity */}
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h4 className="text-sm font-semibold text-slate-800 font-display">Passenger Activity</h4>
              <p className="text-[10px] text-slate-400">Weekly tracking history</p>
            </div>
            <div className="px-2 py-0.5 rounded-md bg-slate-100 text-[10px] font-medium text-slate-600 font-mono">
              7 Days
            </div>
          </div>
          <div className="h-56 flex items-center justify-center">
            <Line data={passengerActivityData} options={chartOptions} />
          </div>
        </div>

        {/* Bookings Overview */}
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h4 className="text-sm font-semibold text-slate-800 font-display">Bookings Overview</h4>
              <p className="text-[10px] text-slate-400">Demand distribution</p>
            </div>
            <div className="px-2 py-0.5 rounded-md bg-indigo-50 text-[10px] font-medium text-indigo-600 font-mono">
              Aggregate
            </div>
          </div>
          <div className="h-56 flex items-center justify-center">
            <Bar data={bookingsOverviewData} options={chartOptions} />
          </div>
        </div>

        {/* Vehicle Status */}
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h4 className="text-sm font-semibold text-slate-800 font-display">Vehicle Status</h4>
              <p className="text-[10px] text-slate-400">Fleet operational state</p>
            </div>
            <div className="px-2 py-0.5 rounded-md bg-emerald-50 text-[10px] font-medium text-emerald-600 font-mono">
              Active Fleet
            </div>
          </div>
          <div className="h-56 flex items-center justify-center relative">
            <Doughnut 
              data={vehicleStatusData} 
              options={{
                responsive: true,
                plugins: { legend: { position: 'bottom', labels: { boxWidth: 12, font: { size: 10, family: 'Inter' } } } }
              }} 
            />
          </div>
        </div>
      </div>

      {/* Dual Column: Live Bus Status & Recent Activity */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Live Bus Status */}
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs flex flex-col">
          <div className="flex items-center gap-2 mb-4">
            <Activity className="h-4.5 w-4.5 text-indigo-600" />
            <h4 className="text-sm font-semibold text-slate-800 font-display">Live Bus Allocations</h4>
          </div>
          <div className="overflow-x-auto flex-1">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="bg-slate-50 text-slate-500 font-medium border-b border-slate-150">
                  <th className="py-2.5 px-3 rounded-l-lg">Bus Plate</th>
                  <th className="py-2.5 px-3">Driver Name</th>
                  <th className="py-2.5 px-3">Active Route</th>
                  <th className="py-2.5 px-3 rounded-r-lg text-right">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {timetables.map((t, idx) => (
                  <tr key={idx} className="hover:bg-slate-50/55 transition-all">
                    <td className="py-3 px-3 font-mono font-semibold text-slate-700">{t.vehicleNumber}</td>
                    <td className="py-3 px-3 text-slate-600 font-medium">{t.driverName}</td>
                    <td className="py-3 px-3 text-slate-500">Route {t.routeNumber}</td>
                    <td className="py-3 px-3 text-right">
                      <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-semibold bg-emerald-50 text-emerald-700">
                        <span className="h-1.5 w-1.5 rounded-full bg-emerald-500" />
                        Running
                      </span>
                    </td>
                  </tr>
                ))}
                {timetables.length === 0 && (
                  <tr>
                    <td colSpan={4} className="py-8 text-center text-slate-400 font-mono">
                      No live bus routes active.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Recent Activity Stream */}
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <h4 className="text-sm font-semibold text-slate-800 mb-4 font-display flex items-center gap-2">
            <Clock className="h-4.5 w-4.5 text-indigo-600" />
            Audit Log Activity Stream
          </h4>
          <div className="space-y-4 max-h-[220px] overflow-y-auto pr-1">
            {activityLogs.slice(0, 5).map((log, index) => (
              <div key={index} className="flex gap-3 text-xs leading-normal">
                <div className="flex flex-col items-center">
                  <div className="h-6 w-6 rounded-full bg-slate-100 flex items-center justify-center text-[10px] font-semibold text-slate-600 border border-slate-200">
                    {index + 1}
                  </div>
                  {index < 4 && <div className="w-[1px] bg-slate-200 flex-1 my-1" />}
                </div>
                <div className="flex-1">
                  <div className="flex items-center justify-between">
                    <p className="font-semibold text-slate-800">{log.action}</p>
                    <span className="text-[10px] font-mono text-slate-400">
                      {new Date(log.timestamp).toLocaleTimeString("en-US", { hour12: false })}
                    </span>
                  </div>
                  <p className="text-slate-500 mt-0.5 text-[11px]">{log.details}</p>
                  <p className="text-[9px] font-mono text-indigo-500 mt-0.5">By: {log.operator}</p>
                </div>
              </div>
            ))}
            {activityLogs.length === 0 && (
              <div className="py-8 text-center text-slate-400 font-mono text-xs">
                No recent admin activity logged.
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
