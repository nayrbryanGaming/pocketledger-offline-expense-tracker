"use client";

import React from "react";
import { motion } from "framer-motion";

export default function Home() {
  const fadeInUp = {
    initial: { opacity: 0, y: 20 },
    animate: { opacity: 1, y: 0 },
    transition: { duration: 0.6 }
  };

  const stagger = {
    animate: {
      transition: {
        staggerChildren: 0.1
      }
    }
  };

  return (
    <div className="min-h-screen bg-[#0F172A] text-slate-100 font-sans selection:bg-emerald-500/30">
      
      {/* Premium Navbar */}
      <nav className="fixed top-0 left-0 right-0 z-50 bg-[#0F172A]/80 backdrop-blur-xl border-b border-slate-800">
        <div className="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
          <div className="flex items-center gap-3">
             <div className="w-10 h-10 bg-gradient-to-tr from-emerald-500 to-emerald-400 rounded-xl flex items-center justify-center shadow-lg shadow-emerald-500/20">
                <svg className="w-6 h-6 text-[#0F172A]" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M21 18V19C21 20.1 20.1 21 19 21H5C3.89 21 3 20.1 3 19V5C3 3.9 3.89 3 5 3H19C20.1 3 21 3.9 21 5V6H12C10.89 6 10 6.89 10 8V16C10 17.11 10.89 18 12 18H21ZM12 16H22V8H12V16ZM16 13.5C15.17 13.5 14.5 12.83 14.5 12C14.5 11.17 15.17 10.5 16 10.5C16.83 10.5 17.5 11.17 17.5 12C17.5 12.83 16.83 13.5 16 13.5Z"/>
                </svg>
             </div>
             <span className="text-2xl font-bold tracking-tight text-white">PocketLedger</span>
          </div>
          <div className="hidden md:flex gap-8 text-sm font-medium text-slate-400">
             <a href="#features" className="hover:text-emerald-400 transition-colors">Features</a>
             <a href="#security" className="hover:text-emerald-400 transition-colors">Privacy</a>
             <a href="#testimonials" className="hover:text-emerald-400 transition-colors">Stories</a>
          </div>
          <button className="bg-emerald-500 hover:bg-emerald-400 text-[#0F172A] font-bold px-6 py-2.5 rounded-full transition-all hover:scale-105 active:scale-95 shadow-xl shadow-emerald-500/10">
            Download App
          </button>
        </div>
      </nav>

      <main className="pt-32 pb-20 max-w-7xl mx-auto px-6">
        
        {/* Hero Section */}
        <section className="flex flex-col lg:flex-row items-center gap-16 py-10 lg:py-20">
          <motion.div 
            initial="initial"
            animate="animate"
            variants={stagger}
            className="flex-1 text-center lg:text-left"
          >
            <motion.div variants={fadeInUp} className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-bold uppercase tracking-wider mb-8">
              <span className="relative flex h-2 w-2">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
              </span>
              Offline Finance Revolution
            </motion.div>
            <motion.h1 variants={fadeInUp} className="text-6xl md:text-8xl font-black text-white leading-[1.05] tracking-tight mb-8">
              Track Every <span className="text-emerald-500">Rupiah.</span> <br />
              <span className="text-slate-500 italic">Stay Offline.</span>
            </motion.h1>
            <motion.p variants={fadeInUp} className="text-lg md:text-xl text-slate-400 max-w-2xl mx-auto lg:mx-0 leading-relaxed mb-10">
              PocketLedger is a privacy-first personal finance app. No cloud sync, no data harvesting, just lightning-fast expense tracking that works anywhere &mdash; even in the deepest jungle.
            </motion.p>
            <motion.div variants={fadeInUp} className="flex flex-col sm:flex-row items-center gap-4 justify-center lg:justify-start">
              <button className="w-full sm:w-auto bg-emerald-500 hover:bg-emerald-400 text-[#0F172A] font-bold px-10 py-4 rounded-2xl text-lg transition-all shadow-2xl shadow-emerald-500/20 active:translate-y-1">
                Install on Android
              </button>
              <button className="w-full sm:w-auto bg-slate-800 border border-slate-700 hover:bg-slate-700 text-white font-bold px-10 py-4 rounded-2xl text-lg transition-all active:translate-y-1">
                App Store (Soon)
              </button>
            </motion.div>
          </motion.div>

          <motion.div 
            initial={{ opacity: 0, scale: 0.9, rotate: 5 }}
            animate={{ opacity: 1, scale: 1, rotate: 0 }}
            transition={{ duration: 0.8, ease: "easeOut" }}
            className="flex-1 relative group"
          >
            <div className="absolute inset-0 bg-emerald-500/20 blur-[100px] group-hover:bg-emerald-500/30 transition-all duration-500" />
            <div className="relative w-full max-w-[340px] mx-auto aspect-[9/19] bg-slate-900 rounded-[3.5rem] p-4 shadow-2xl border-[12px] border-slate-800 ring-1 ring-slate-700">
               {/* Phone Notch */}
               <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-7 bg-slate-800 rounded-b-3xl z-10" />
               
               {/* Internal App Preview */}
               <div className="w-full h-full bg-[#0F172A] rounded-[2.5rem] overflow-hidden p-6 flex flex-col gap-6 pt-10">
                  <div className="flex justify-between items-start">
                    <div>
                       <p className="text-slate-500 text-[10px] font-bold uppercase tracking-wider">Total Balance</p>
                       <p className="text-white text-2xl font-bold">Rp 15.200.000</p>
                    </div>
                    <div className="w-10 h-10 rounded-full bg-slate-800/50 border border-slate-700" />
                  </div>
                  
                  <div className="h-28 w-full bg-emerald-500/10 rounded-2xl border border-emerald-500/20 p-4 flex flex-col justify-between">
                     <p className="text-emerald-500 text-xs font-bold">Monthly Insight</p>
                     <div className="flex items-end gap-1 h-12">
                        {[40, 70, 50, 90, 60, 80].map((h, i) => (
                          <div key={i} className="flex-1 bg-emerald-500 rounded-sm" style={{ height: `${h}%` }} />
                        ))}
                     </div>
                  </div>

                  <div className="flex-1 flex flex-col gap-3">
                     <p className="text-slate-500 text-[10px] font-bold uppercase">Recent Activities</p>
                     {[1,2,3,4].map(i => (
                       <div key={i} className="bg-slate-800/30 h-12 rounded-xl border border-slate-800 flex items-center px-3 gap-3">
                          <div className="w-6 h-6 rounded-full bg-slate-700" />
                          <div className="flex-1 h-2 bg-slate-700 rounded-full w-20" />
                          <div className="w-8 h-2 bg-red-500/20 rounded-full" />
                       </div>
                     ))}
                  </div>
                  
                  <div className="w-full h-12 bg-emerald-500 rounded-xl shadow-lg" />
               </div>
            </div>
          </motion.div>
        </section>

        {/* Features Grid */}
        <section id="features" className="py-24">
           <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              <div className="bg-slate-900/50 border border-slate-800 p-10 rounded-[2.5rem] hover:bg-slate-800/50 transition-all group">
                 <div className="w-14 h-14 bg-emerald-500/10 rounded-2xl flex items-center justify-center text-emerald-400 mb-6 group-hover:scale-110 transition-all font-bold text-2xl font-mono">⚡</div>
                 <h3 className="text-2xl font-bold text-white mb-4">Instant Budgeting</h3>
                 <p className="text-slate-400 leading-relaxed">Set monthly limits for any category with a single tap. Visual progress bars keep you accountable 24/7 without needing an account.</p>
              </div>
              <div className="bg-slate-900/50 border border-slate-800 p-10 rounded-[2.5rem] hover:bg-slate-800/50 transition-all group">
                 <div className="w-14 h-14 bg-blue-500/10 rounded-2xl flex items-center justify-center text-blue-400 mb-6 group-hover:scale-110 transition-all font-bold text-2xl font-mono">🔒</div>
                 <h3 className="text-2xl font-bold text-white mb-4">Hardened Privacy</h3>
                 <p className="text-slate-400 leading-relaxed">Your data never leaves your device. Not even for us. Full database control is in your hands via local SQLite encryption.</p>
              </div>
              <div className="bg-slate-900/50 border border-slate-800 p-10 rounded-[2.5rem] hover:bg-slate-800/50 transition-all group">
                 <div className="w-14 h-14 bg-amber-500/10 rounded-2xl flex items-center justify-center text-amber-500 mb-6 group-hover:scale-110 transition-all font-bold text-2xl font-mono">📉</div>
                 <h3 className="text-2xl font-bold text-white mb-4">Elite Analytics</h3>
                 <p className="text-slate-400 leading-relaxed">Compare this month vs last month with precision. Beautiful interactive charts powered by high-performance local data engine.</p>
              </div>
           </div>
        </section>

        {/* CTA */}
        <section className="bg-gradient-to-br from-emerald-600 to-emerald-400 rounded-[3rem] p-16 text-center relative overflow-hidden shadow-2xl">
           <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 blur-[100px] rounded-full -translate-y-1/2 translate-x-1/2" />
           <h2 className="text-4xl md:text-5xl font-black text-[#0F172A] mb-6">Stop leaking your financial data.</h2>
           <p className="text-[#0F172A]/80 text-lg max-w-xl mx-auto mb-10 font-medium leading-relaxed underline decoration-white/30 underline-offset-4">
              Join the movement of users who track money offline. No accounts required. No emails collected.
           </p>
           <button className="bg-[#0F172A] text-white font-bold px-12 py-5 rounded-2xl text-xl hover:bg-black transition-all shadow-xl active:translate-y-1">
              Start Tracking Now &mdash; Free
           </button>
        </section>

      </main>

      <footer className="py-20 border-t border-slate-900 bg-[#08101E]">
         <div className="max-w-7xl mx-auto px-6 grid grid-cols-1 md:grid-cols-4 gap-12 text-slate-500 text-sm">
            <div className="col-span-1 md:col-span-2">
               <div className="flex items-center gap-2 text-white font-bold text-xl mb-6">
                  <div className="w-8 h-8 rounded-lg bg-emerald-500" />
                  PocketLedger
               </div>
               <p className="max-w-xs leading-relaxed font-medium">Built for the digital minimalist. Track every rupiah, even without internet. Privacy is a human right.</p>
            </div>
            <div className="flex flex-col gap-4">
               <p className="text-white font-bold uppercase tracking-widest text-xs mb-2">Legal</p>
               <a href="/privacy" className="hover:text-emerald-400 transition-colors">Privacy Policy</a>
               <a href="/terms" className="hover:text-emerald-400 transition-colors">Terms of Service</a>
               <a href="/disclaimer" className="hover:text-emerald-400 transition-colors">Disclaimer</a>
            </div>
            <div className="flex flex-col gap-4">
               <p className="text-white font-bold uppercase tracking-widest text-xs mb-2">Support</p>
               <a href="mailto:support@pocketledger.app" className="hover:text-emerald-400 transition-colors underline decoration-emerald-500/20 underline-offset-4">support@pocketledger.app</a>
            </div>
         </div>
      </footer>
    </div>
  );
}
