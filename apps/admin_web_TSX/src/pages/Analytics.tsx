import React from "react";
import { Bar, Doughnut, Line, PolarArea } from "react-chartjs-2";
import { BarChart3, Users, TrendingUp, ShieldAlert, Bus, Landmark } from "lucide-react";
import { 
  User, 
  Driver, 
  Conductor, 
  Vehicle, 
  Route, 
  Booking, 
  Complaint 
} from "../types";

import {
  Chart as ChartJS,
  RadialLinearScale,
  ArcElement,
  Tooltip,
  Legend
} from 'chart.js';

ChartJS.register(RadialLinearScale, ArcElement, Tooltip, Legend);

interface AnalyticsProps {
  users: User[];
  drivers: Driver[];
  conductors: Conductor[];
  vehicles: Vehicle[];
  routes: Route[];
  bookings: Booking[];
  complaints: Complaint[];
}

export default function Analytics({
  users,
  drivers,
  conductors,
  vehicles,
  routes,
  bookings,
  complaints
}: AnalyticsProps) {

  // Dynamic values
  const totalFleetSeats = vehicles.reduce((acc, curr) => acc + (curr.capacity || 0), 0);
  const activeDrivers = drivers.filter(d => d.status === "Active").length;
  const resolvedComplaints = complaints.filter(c => c.status === "Resolved").length;
  const pendingComplaints = complaints.filter(c => c.status !== "Resolved").length;

  // Chart 1: Passenger Growth Trend (Jan - Jun)
  const passengerGrowthData = {
    labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"],
    datasets: [
      {
        label: "Active Passengers",
        data: [1500, 1850, 2200, 2100, 2600, 3100, 3450],
        borderColor: "rgb(99, 102, 241)",
        backgroundColor: "rgba(99, 102, 241, 0.05)",
        tension: 0.4,
        fill: true,
      }
    ]
  };

  // Chart 2: Fleet Seating Capacities
  const fleetCapacityData = {
    labels: vehicles.map(v => v.vehicleNumber) || ["Bus 1", "Bus 2"],
    datasets: [
      {
        label: "Seat Allocation Capacity",
        data: vehicles.map(v => v.capacity) || [40, 50],
        backgroundColor: [
          "rgba(99, 102, 241, 0.8)",
          "rgba(139, 92, 246, 0.8)",
          "rgba(245, 158, 11, 0.8)",
          "rgba(16, 185, 129, 0.8)"
        ],
        borderWidth: 1,
      }
    ]
  };

  // Chart 3: Booking Status Trends
  const bookingStatusData = {
    labels: ["Confirmed", "Pending", "Cancelled"],
    datasets: [
      {
        data: [
          bookings.filter(b => b.status === "Confirmed").length || 10,
          bookings.filter(b => b.status === "Pending").length || 5,
          bookings.filter(b => b.status === "Cancelled").length || 2
        ],
        backgroundColor: [
          "rgba(16, 185, 129, 0.85)", // Confirmed: Green
          "rgba(245, 158, 11, 0.85)",  // Pending: Amber
          "rgba(239, 68, 68, 0.85)"   // Cancelled: Rose
        ],
        borderWidth: 2,
      }
    ]
  };

  // Chart 4: Complaint Resolution statistics
  const complaintStatsData = {
    labels: ["Pending", "In Investigation", "Resolved"],
    datasets: [
      {
        label: "Complaints Tracker",
        data: [
          complaints.filter(c => c.status === "Pending").length || 2,
          complaints.filter(c => c.status === "In Progress").length || 1,
          complaints.filter(c => c.status === "Resolved").length || 4
        ],
        backgroundColor: [
          "rgba(239, 68, 68, 0.75)",
          "rgba(245, 158, 11, 0.75)",
          "rgba(16, 185, 129, 0.75)"
        ],
      }
    ]
  };

  const genericOptions = {
    responsive: true,
    plugins: {
      legend: {
        labels: {
          font: {
            family: "Inter",
            size: 11
          }
        }
      }
    }
  };

  return (
    <div className="space-y-6">
      {/* Overview Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <div className="flex justify-between items-start">
            <div>
              <p className="text-slate-400 text-xs font-semibold">Active Fleet Seats</p>
              <h3 className="text-2xl font-bold font-display mt-1 text-slate-900">{totalFleetSeats} Seats</h3>
            </div>
            <div className="p-2.5 bg-indigo-50 text-indigo-600 rounded-xl">
              <Bus className="h-5 w-5" />
            </div>
          </div>
          <p className="text-[10px] text-slate-400 mt-2 font-mono">Aggregation of total seating capacity</p>
        </div>

        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <div className="flex justify-between items-start">
            <div>
              <p className="text-slate-400 text-xs font-semibold">Active Drivers</p>
              <h3 className="text-2xl font-bold font-display mt-1 text-slate-900">{activeDrivers} Operators</h3>
            </div>
            <div className="p-2.5 bg-emerald-50 text-emerald-600 rounded-xl">
              <Users className="h-5 w-5" />
            </div>
          </div>
          <p className="text-[10px] text-emerald-600 mt-2 font-mono">{(activeDrivers / (drivers.length || 1) * 100).toFixed(0)}% on-duty operational roster</p>
        </div>

        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <div className="flex justify-between items-start">
            <div>
              <p className="text-slate-400 text-xs font-semibold">Complaint Resolution</p>
              <h3 className="text-2xl font-bold font-display mt-1 text-slate-900">
                {((resolvedComplaints / (complaints.length || 1)) * 100).toFixed(0)}% Rate
              </h3>
            </div>
            <div className="p-2.5 bg-rose-50 text-rose-600 rounded-xl">
              <ShieldAlert className="h-5 w-5" />
            </div>
          </div>
          <p className="text-[10px] text-slate-400 mt-2 font-mono">{resolvedComplaints} resolved, {pendingComplaints} pending review</p>
        </div>

        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <div className="flex justify-between items-start">
            <div>
              <p className="text-slate-400 text-xs font-semibold">Average Route Length</p>
              <h3 className="text-2xl font-bold font-display mt-1 text-slate-900">
                {(routes.reduce((acc, curr) => acc + (curr.distance || 0), 0) / (routes.length || 1)).toFixed(0)} km
              </h3>
            </div>
            <div className="p-2.5 bg-amber-50 text-amber-600 rounded-xl">
              <Landmark className="h-5 w-5" />
            </div>
          </div>
          <p className="text-[10px] text-slate-400 mt-2 font-mono">Aggregated length over active routes</p>
        </div>
      </div>

      {/* Analytics Charts Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Passenger Growth Trend */}
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <h4 className="text-sm font-semibold text-slate-800 font-display mb-4">Passenger Growth Trend</h4>
          <div className="h-64 flex items-center justify-center">
            <Line data={passengerGrowthData} options={genericOptions} />
          </div>
        </div>

        {/* Fleet Seating Capacities */}
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <h4 className="text-sm font-semibold text-slate-800 font-display mb-4">Individual Vehicle Capacities</h4>
          <div className="h-64 flex items-center justify-center">
            <Bar data={fleetCapacityData} options={genericOptions} />
          </div>
        </div>

        {/* Booking Status distribution */}
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <h4 className="text-sm font-semibold text-slate-800 font-display mb-4">Booking Ratios</h4>
          <div className="h-64 flex items-center justify-center">
            <Doughnut data={bookingStatusData} options={genericOptions} />
          </div>
        </div>

        {/* Complaint Resolution Statistics */}
        <div className="bg-white p-5 rounded-2xl border border-slate-150 shadow-xs">
          <h4 className="text-sm font-semibold text-slate-800 font-display mb-4">Complaint Status</h4>
          <div className="h-64 flex items-center justify-center">
            <PolarArea data={complaintStatsData} options={genericOptions} />
          </div>
        </div>
      </div>
    </div>
  );
}
