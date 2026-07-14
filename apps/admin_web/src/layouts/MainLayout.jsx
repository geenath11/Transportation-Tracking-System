import Navbar from "../components/Navbar/Navbar";
import Sidebar from "../components/Sidebar/Sidebar";
import "./MainLayout.css";

function MainLayout({ children }) {
  return (
    <div className="container">
      <Sidebar />

      <div className="main">
        <Navbar />

        <div className="content">{children}</div>
      </div>
    </div>
  );
}

export default MainLayout;
