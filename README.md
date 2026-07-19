
# Smart Transportation Tracking System - Web Admin

## Overview

The Web Admin Panel is a React and TypeScript application for managing the Smart Transportation Tracking System. This initial version establishes the frontend foundation by providing the main dashboard layout, navigation structure, and placeholder pages for future development.

## Features

- Responsive admin dashboard layout
- Sidebar navigation
- Top navigation bar
- Hash-based page navigation
- Placeholder pages for:
  - Dashboard
  - Users
  - Drivers
  - Conductors
  - Vehicles
  - Routes
  - Timetables
  - Bookings
  - Complaints
  - Notifications
  - Analytics
  - Settings

## TypeScript Migration

The Web Admin Panel was migrated from JavaScript to TypeScript during the early stages of development to improve type safety, maintainability, scalability, and developer productivity. TypeScript enables early error detection, better IDE support, and safer refactoring, providing a stronger foundation for future development.


## Tech Stack

- React
- TypeScript
- Vite
- Tailwind CSS
- Lucide React

## Project Structure

```
src/
├── components/
│   ├── Navbar.tsx
│   └── Sidebar.tsx
├── pages/
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
