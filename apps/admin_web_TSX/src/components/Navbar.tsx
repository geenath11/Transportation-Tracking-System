import React from "react";
import { Menu } from "lucide-react";

interface NavbarProps {
  activePage: string;
  onMenuToggle: () => void;
}

export default function Navbar({
  activePage,
  onMenuToggle,
}: NavbarProps) {
   [];

  const formatTitle = (str: string) => {
    if (!str) return "Dashboard";
    return str.charAt(0).toUpperCase() + str.slice(1);
  };

  return (
    <header className="h-16 bg-white border-b border-slate-200 px-6 flex items-center justify-between sticky top-0 z-30">
      {/* Left section: Hamburger & Title */}
      <div className="flex items-center gap-4">
        <button
          onClick={onMenuToggle}
          className="lg:hidden p-2 text-slate-500 hover:text-slate-700 hover:bg-slate-100 rounded-lg transition-all"
        >
          <Menu className="h-5 w-5" />
        </button>
        <div className="flex flex-col">
          <h2 className="font-display font-semibold text-slate-800 text-lg leading-tight">
            {formatTitle(activePage)}
          </h2>
          <p className="text-[10px] text-slate-400 font-medium">Smart Transportation System</p>
        </div>
      </div>

      

      {/* Right section: System status, Time & Profile */}
      <div className="flex items-center gap-4">
       

       

        {/* Divider */}
    

        
      </div>
    </header>
  );
}
