import {
  collection,
  getDocs,
  addDoc,
  updateDoc,
  deleteDoc,
  doc,
} from "firebase/firestore";

import { db } from "./firebase";

export async function getUsers() {
  const snapshot = await getDocs(collection(db, "users"));

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

export async function addUser(user) {
  await addDoc(collection(db, "users"), user);
}

export async function updateUser(id, user) {
  await updateDoc(doc(db, "users", id), user);
}

export async function deleteUser(id) {
  await deleteDoc(doc(db, "users", id));
}
