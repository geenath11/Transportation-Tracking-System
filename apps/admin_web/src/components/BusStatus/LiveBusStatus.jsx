import "./LiveBusStatus.css";

function LiveBusStatus() {
  return (
    <div className="bus-status">
      <h2>Live Bus Status</h2>

      <table>
        <thead>
          <tr>
            <th>Bus</th>

            <th>Driver</th>

            <th>Status</th>
          </tr>
        </thead>

        <tbody>
          <tr>
            <td>NB-2548</td>

            <td>Kamal</td>

            <td>Running</td>
          </tr>

          <tr>
            <td>NC-7812</td>

            <td>Nimal</td>

            <td>Stopped</td>
          </tr>

          <tr>
            <td>WP-8945</td>

            <td>Sunil</td>

            <td>Running</td>
          </tr>
        </tbody>
      </table>
    </div>
  );
}

export default LiveBusStatus;
