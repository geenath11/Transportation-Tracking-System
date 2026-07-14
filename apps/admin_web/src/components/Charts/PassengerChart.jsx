import "./PassengerChart.css";

import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";

import { Line } from "react-chartjs-2";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
);

function PassengerChart() {
  const data = {
    labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],

    datasets: [
      {
        label: "Passengers",

        data: [250, 310, 280, 420, 500, 650, 720],

        borderColor: "#2563eb",

        tension: 0.4,

        fill: false,
      },
    ],
  };

  return (
    <div className="chart">
      <h2>Passenger Activity</h2>

      <Line data={data} />
    </div>
  );
}

export default PassengerChart;
