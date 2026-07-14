import "./UserTable.css";

function UserTable() {
  return (
    <table className="user-table">

      <thead>

        <tr>

          <th>Name</th>

          <th>Email</th>

          <th>Role</th>

          <th>Actions</th>

        </tr>

      </thead>

      <tbody>

        <tr>

          <td>John Silva</td>

          <td>john@gmail.com</td>

          <td>Passenger</td>

          <td>

            <button>Edit</button>

            <button>Delete</button>

          </td>

        </tr>

        <tr>

          <td>Nimal Perera</td>

          <td>nimal@gmail.com</td>

          <td>Driver</td>

          <td>

            <button>Edit</button>

            <button>Delete</button>

          </td>

        </tr>

      </tbody>

    </table>
  );
}

export default UserTable;