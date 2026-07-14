import "./StatCard.css";

function StatCard({ title, value, icon }) {
  return (
    <div className="stat-card">
      <div className="card-top">
        <h3>{title}</h3>

        <div className="icon">{icon}</div>
      </div>

      <h1>{value}</h1>
    </div>
  );
}

export default StatCard;
