import "./SearchBar.css";

function SearchBar() {
  return (
    <div className="search-bar">
      <input type="text" placeholder="Search users..." />

      <button>Add User</button>
    </div>
  );
}

export default SearchBar;
