import { useState } from "react";
import "./UserModal.css";

function UserModal({ onSave, onClose, user }) {
  const [name, setName] = useState(user?.name || "");
  const [email, setEmail] = useState(user?.email || "");
  const [role, setRole] = useState(user?.role || "");
  async function handleSubmit(e) {
    e.preventDefault();

    await onSave({
      name,
      email,
      role,
    });

    onClose();
  }

  return (
    <div className="modal-overlay">
      <div className="modal">
        <h2>{user ? "Edit User" : "Add User"}</h2>

        <form onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />

          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />

          <select
            value={role}
            onChange={(e) => setRole(e.target.value)}
            required
          >
            <option value="">Select Role</option>
            <option>Passenger</option>
            <option>Driver</option>
            <option>Admin</option>
          </select>

          <div className="buttons">
            <button type="button" onClick={onClose}>
              Cancel
            </button>

            <button type="submit">{user ? "Update User" : "Save User"}</button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default UserModal;
