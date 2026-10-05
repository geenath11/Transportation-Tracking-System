import {
  collection,
  addDoc,
  updateDoc,
  deleteDoc,
  doc,
  onSnapshot,
  query,
} from "firebase/firestore";

import { db } from "./firebase";

// Helper to log administrative actions
export async function logActivity(
  action: string,
  details: string,
  operator: string = "Admin"
) {
  try {
    await addDoc(collection(db, "activityLogs"), {
      action,
      details,
      operator,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error("Failed to log activity:", error);
  }
}

// Database seeding is disabled.
// Existing Firebase/Firestore data will be used.
export async function seedDatabaseIfEmpty(): Promise<void> {
  console.log(
    "Database seeding is disabled. Using existing Firebase data."
  );
}

// Subscription helper - Real-time Firestore updates
export function subscribeToCollection<T>(
  collectionName: string,
  callback: (data: T[]) => void
) {
  const q = query(collection(db, collectionName));

  return onSnapshot(
    q,
    (snapshot) => {
      const items: T[] = [];

      snapshot.forEach((document) => {
        items.push({
          id: document.id,
          ...document.data(),
        } as unknown as T);
      });

      callback(items);
    },
    (error) => {
      console.error(
        `Error subscribing to ${collectionName}:`,
        error
      );
    }
  );
}

// Create document
export async function createDocument<T extends object>(
  collectionName: string,
  data: T
): Promise<string> {
  try {
    const docRef = await addDoc(collection(db, collectionName), {
      ...data,
      createdAt: new Date().toISOString(),
    });

    return docRef.id;
  } catch (error) {
    console.error(
      `Error creating document in ${collectionName}:`,
      error
    );
    throw error;
  }
}

// Update document
export async function updateDocument<T extends object>(
  collectionName: string,
  id: string,
  data: Partial<T>
): Promise<void> {
  try {
    const docRef = doc(db, collectionName, id);

    await updateDoc(
      docRef,
      data as Record<string, unknown>
    );
  } catch (error) {
    console.error(
      `Error updating document in ${collectionName}:`,
      error
    );
    throw error;
  }
}

// Delete document
export async function deleteDocument(
  collectionName: string,
  id: string
): Promise<void> {
  try {
    const docRef = doc(db, collectionName, id);

    await deleteDoc(docRef);
  } catch (error) {
    console.error(
      `Error deleting document in ${collectionName}:`,
      error
    );
    throw error;
  }
}