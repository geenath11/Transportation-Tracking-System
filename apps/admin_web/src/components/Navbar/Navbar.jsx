import "./Navbar.css";
import { signOut } from "firebase/auth";
import { auth } from "../../services/firebase";
import { useNavigate } from "react-router-dom";

function Navbar() {
  const navigate = useNavigate();

  async function logout() {
    await signOut(auth);

    navigate("/login");
  }

  return (
    <div className="navbar">
      <h3>Admin Dashboard</h3>

      <button onClick={logout}>Logout</button>
    </div>
  );
}

export default Navbar;
