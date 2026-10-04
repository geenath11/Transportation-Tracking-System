export type UserRole = "Passenger" | "Admin" | "Operator";

export interface User {
  id?: string;
  name: string;
  email: string;
  role: UserRole;
  createdAt?: string;
}

export type DriverStatus = "Active" | "Inactive";

export interface Driver {
  id?: string;
  name: string;
  email: string;
  licenseNumber: string;
  phoneNumber: string;
  status: DriverStatus;
  createdAt?: string;
}

export type ConductorStatus = "Active" | "Inactive";

export interface Conductor {
  id?: string;
  name: string;
  email: string;
  phone: string;
  status: ConductorStatus;
  createdAt?: string;
}

export type VehicleStatus = "Running" | "Stopped" | "Maintenance";

export interface Vehicle {
  id?: string;
  vehicleNumber: string;
  vehicleType: string;
  capacity: number;
  status: VehicleStatus;
  createdAt?: string;
}

export interface Route {
  id?: string;
  route: string;
  departureCity: string;
  arrivalCity: string;
  departureTime: string;
  arrivalTime: string;
  busType: string;
  serviceName: string;
  distanceKm: number;
  duration: string;
  createdAt?: string;
}

export interface Timetable {
  id?: string;
  routeId: string;
  routeNumber: string;
  vehicleId: string;
  vehicleNumber: string;
  driverId: string;
  driverName: string;
  departureTime: string;
  arrivalTime: string;
  createdAt?: string;
}

export interface Booking {
  id?: string;
  ticketId: string;
  passengerName: string;
  passengerPhone: string;
  userId: string;
  from: string;
  to: string;
  bus: string;
  date: string;
  departureTime: string;
  arrivalTime: string;
  selectedSeats: string[];
  totalPrice: number;
  paymentStatus: string;
  ticketStatus: string;
  createdAt?: string;
}

export type ComplaintStatus =
  | "Pending"
  | "In Progress"
  | "Resolved";

export interface Complaint {
  id?: string;
  complaintId: string;
  passengerName: string;
  subject: string;
  description: string;
  status: ComplaintStatus;
  createdAt?: string;
}

export type NotificationTarget =
  | "Passengers"
  | "Drivers"
  | "Conductors"
  | "All Users";

export type NotificationStatus =
  | "Draft"
  | "Scheduled"
  | "Sent";

export interface NotificationItem {
  id?: string;
  title: string;
  message: string;
  targetUser: NotificationTarget;
  status: NotificationStatus;
  createdAt?: string;
}

export interface ActivityLog {
  id?: string;
  action: string;
  details: string;
  timestamp: string;
  operator: string;
}