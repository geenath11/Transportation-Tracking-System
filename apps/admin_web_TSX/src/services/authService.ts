import { 
  signInWithEmailAndPassword, 
  createUserWithEmailAndPassword,
  signOut as firebaseSignOut,
  onAuthStateChanged,
  User as FirebaseUser
} from "firebase/auth";
import { auth } from "./firebase";
import { logActivity } from "./dbService";

// Standard Admin Account
export const DEFAULT_ADMIN_EMAIL = "admin@transport.com";
export const DEFAULT_ADMIN_PASSWORD = "password123";

export async function loginWithFirebase(email: string, password: string): Promise<FirebaseUser> {
  try {
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    await logActivity("Admin Login", `Successfully logged in: ${email}`, email);
    return userCredential.user;
  } catch (error: any) {
    // If the user does not exist in our newly provisioned Firebase project,
    // auto-create the default admin account on-the-fly for seamless onboarding!
    if (
      (error.code === "auth/user-not-found" || error.code === "auth/invalid-credential" || error.code === "auth/cannot-find-user") && 
      email === DEFAULT_ADMIN_EMAIL && 
      password === DEFAULT_ADMIN_PASSWORD
    ) {
      try {
        const userCredential = await createUserWithEmailAndPassword(auth, email, password);
        await logActivity("Admin Registered", `Auto-created default admin account: ${email}`, email);
        return userCredential.user;
      } catch (createError) {
        console.error("Auto-create admin failed:", createError);
        throw error;
      }
    }
    console.error("Firebase auth login error:", error);
    throw error;
  }
}

export async function logoutWithFirebase() {
  const currentUserEmail = auth.currentUser?.email || "Admin";
  try {
    await firebaseSignOut(auth);
    await logActivity("Admin Logout", `Successfully logged out`, currentUserEmail);
  } catch (error) {
    console.error("Firebase auth logout error:", error);
    throw error;
  }
}

export function onAuthStateSubscription(callback: (user: FirebaseUser | null) => void) {
  return onAuthStateChanged(auth, callback);
}
