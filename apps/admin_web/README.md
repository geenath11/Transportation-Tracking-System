# Admin Panel - User Management Module

## Overview

This update introduces the User Management module for the Smart Transportation Admin Panel. The module is integrated with Firebase Firestore and provides complete CRUD (Create, Read, Update, Delete) functionality for managing system users. The dashboard has also been improved with reusable components and a cleaner project structure to support future development.

## Features Implemented

### User Management

- Display all users from Firebase Firestore.
- Add new users through a modal form.
- Edit existing user information.
- Delete users with a confirmation prompt.
- Automatically refresh the user list after each operation.

### Firebase Integration

- Connected the React application to Firebase.
- Integrated Cloud Firestore as the database.
- Created service functions for user operations.
- Configured Firebase using environment variables.

### Dashboard Improvements

- Added dashboard statistic cards.
- Added Live Bus Status component.
- Added Recent Activity component.
- Improved dashboard layout using reusable components.

### Project Structure

- Organized pages, layouts, components, and services.
- Added reusable modal component for user management.
- Prepared the project structure for future modules such as Drivers, Conductors, Vehicles, Routes, and Timetables.

## Technologies Used

- React
- Vite
- Firebase Authentication
- Firebase Cloud Firestore
- React Router DOM
- CSS

## Environment Configuration

Firebase configuration has been moved to environment variables.

Create a `.env` file in the project root and configure the following variables:

```env
VITE_FIREBASE_API_KEY=
VITE_FIREBASE_AUTH_DOMAIN=
VITE_FIREBASE_PROJECT_ID=
VITE_FIREBASE_STORAGE_BUCKET=
VITE_FIREBASE_MESSAGING_SENDER_ID=
VITE_FIREBASE_APP_ID=
```

## Completed Functionality

- Dashboard Layout
- Sidebar Navigation
- Navbar
- User CRUD Operations
- Firebase Firestore Integration
- User Modal
- Delete Confirmation
- Environment Variable Configuration

## Future Work

The following modules will be implemented in future updates:

- Driver Management
- Conductor Management
- Vehicle Management
- Route Management
- Timetable Management
- Booking Management
- Complaint Management
- Analytics Dashboard
- Settings Module
