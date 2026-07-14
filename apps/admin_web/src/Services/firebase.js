import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "smart-transit-admin.firebaseapp.com",
  projectId: "smart-transit-admin",
  storageBucket: "smart-transit-admin.firebasestorage.app",
  messagingSenderId: "349937334240",
  appId: "1:349937334240:web:493209e97180adae619d85",
};

const app = initializeApp(firebaseConfig);

export const db = getFirestore(app);

export const auth = getAuth(app);
