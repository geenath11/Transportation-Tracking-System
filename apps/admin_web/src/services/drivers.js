import {
  collection,
  getDocs,
  addDoc,
  updateDoc,
  deleteDoc,
  doc,
} from "firebase/firestore";

import { db } from "./firebase";

export async function getDrivers() {
  const snapshot = await getDocs(collection(db, "drivers"));

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

export async function addDriver(driver) {
  await addDoc(collection(db, "drivers"), driver);
}

export async function updateDriver(id, driver) {
  await updateDoc(doc(db, "drivers", id), driver);
}

export async function deleteDriver(id) {
  await deleteDoc(doc(db, "drivers", id));
}
