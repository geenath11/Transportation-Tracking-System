import { useEffect, useState } from "react";
import MainLayout from "../../layouts/MainLayout";
import UserModal from "../../components/UserManagement/UserModal";
import {
  getUsers,
  addUser,
  updateUser,
  deleteUser,
} from "../../services/users";
import "./Users.css";

function Users() {
  const [users, setUsers] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [editingUser, setEditingUser] = useState(null);

  useEffect(() => {
    loadUsers();
  }, []);

  async function saveEditedUser(updatedUser) {
    await updateUser(editingUser.id, updatedUser);

    setEditingUser(null);

    loadUsers();
  }
  async function removeUser(id) {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this user?"
    );

    if (!confirmDelete) return;

    await deleteUser(id);

    loadUsers();
  }

  async function loadUsers() {
    const data = await getUsers();
    setUsers(data);
  }

  async function saveUser(user) {
    await addUser(user);

    loadUsers();

    setShowModal(false);
  }

  return (
    <MainLayout>
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <h1>User Management</h1>

        <button onClick={() => setShowModal(true)}>Add User</button>
      </div>

      {showModal && (
        <UserModal onSave={saveUser} onClose={() => setShowModal(false)} />
      )}

      {editingUser && (
        <UserModal
          user={editingUser}
          onSave={saveEditedUser}
          onClose={() => setEditingUser(null)}
        />
      )}

      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Actions</th>
          </tr>
        </thead>

        <tbody>
          {users.map((user) => (
            <tr key={user.id}>
              <td>{user.name}</td>
              <td>{user.email}</td>
              <td>{user.role}</td>

              <td>
                <button
                  onClick={() => setEditingUser(user)}
                  className="edit-btn"
                >
                  Edit
                </button>

                <button
                  onClick={() => removeUser(user.id)}
                  className="delete-btn"
                >
                  Delete
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </MainLayout>
  );
}

export default Users;
