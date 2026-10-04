# Smart Transportation Tracking System - Web Admin

## Overview

The Web Admin Panel is a React and TypeScript application for managing the Smart Transportation Tracking System.

It provides administrators with a centralized interface to manage and monitor the transportation system, including users, drivers, conductors, vehicles, routes, timetables, bookings, complaints, notifications, and analytics.

The application uses a reusable admin dashboard interface with Firebase/Firestore integration for managing and retrieving system data.

## Features

### Admin Dashboard
- Responsive admin dashboard layout
- Sidebar navigation
- Top navigation bar
- Dashboard overview and system information
- Reusable UI components

### User Management
- View and manage system users
- Display user information from Firebase
- User-related administrative operations

### Driver Management
- View driver information
- Manage driver records

### Conductor Management
- View conductor information
- Manage conductor records

### Vehicle Management
- View and manage transportation vehicles

### Route Management
- Manage transportation routes
- Display route-related information

### Timetable Management
- Manage transportation timetables

### Booking / Ticket Management
- Retrieve booking and ticket information from Firebase
- Display passenger and ticket information
- Manage booking records
- Support ticket-related administrative operations
- Match ticket data with the Firestore data structure

### Complaints
- View and manage passenger complaints

### Notifications
- Manage system notifications

### Analytics
- Display transportation-related analytics and information

### Settings
- Administrative settings interface

## TypeScript Migration

The Web Admin Panel was migrated from JavaScript to TypeScript to improve type safety, maintainability, scalability, and developer productivity.

TypeScript provides:

- Strong type checking
- Early error detection
- Improved IDE support
- Safer refactoring
- Better maintainability
- Improved scalability for future development

## Firebase Integration

Firebase is used as the backend infrastructure for the Web Admin Panel.

Current integration includes:

- Firebase Authentication
- Cloud Firestore
- Firebase configuration through environment variables
- Firestore data retrieval and management
- User data integration
- Booking and ticket data integration

Firebase configuration is stored using environment variables and is not hardcoded into the application source code.

## Tech Stack

- React
- TypeScript
- Vite
- Tailwind CSS
- Lucide React
- Firebase
- Cloud Firestore

## Project Structure

```text
src/
├── components/
│   ├── Navbar.tsx
│   ├── Sidebar.tsx
│   └── DeleteConfirmationModal.tsx
│
├── pages/
│   ├── Analytics.tsx
│   ├── Bookings.tsx
│   ├── Complaints.tsx
│   ├── Conductors.tsx
│   ├── Dashboard.tsx
│   ├── Drivers.tsx
│   ├── Routes.tsx
│   ├── Settings.tsx
│   ├── Timetables.tsx
│   ├── Users.tsx
│   └── Vehicles.tsx
│
├── App.tsx
├── main.tsx
└── index.css
```

## Getting Started

### Install dependencies

```bash
npm install
```

### Start the development server

```bash
npm run dev
```

### Build for production

```bash
npm run build
```

## Current Status

This commit initialises the frontend structure of the Web Admin Panel. Backend integration, authentication, Firebase services, and module functionality will be implemented in future updates.
