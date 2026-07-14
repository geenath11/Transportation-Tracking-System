import { useState } from "react";

function UserForm({ onSave }) {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [role, setRole] = useState("");

  function submit(e) {
    e.preventDefault();

    onSave({
      name,
      email,
      role,
    });

    setName("");
    setEmail("");
    setRole("");
  }

  return (
    <form onSubmit={submit}>
      <input
        type="text"
        placeholder="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />

      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />

      <select value={role} onChange={(e) => setRole(e.target.value)}>
        <option value="">Select Role</option>
        <option>Passenger</option>
        <option>Driver</option>
        <option>Admin</option>
      </select>

      <button type="submit">Save User</button>
    </form>
  );
}

export default UserForm;
