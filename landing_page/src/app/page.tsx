import Image from "next/image";
import React from "react";

export default function Home() {
  return (
    <div className="min-h-screen flex flex-col font-[family-name:var(--font-geist-sans)] text-slate-100 bg-slate-900">
      
      {/* HEADER */}
      <header className="w-full flex items-center justify-between p-6 max-w-6xl mx-auto">
        <div className="flex items-center gap-2 font-bold text-xl tracking-wide">
          <div className="w-8 h-8 rounded bg-emerald-500 flex items-center justify-center text-slate-900">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
              <path d="M2.25 10.515V21h19.5V10.515A2.25 2.25 0 0019.5 8.25h-15a2.25 2.25 0 00-2.25 2.265z" />
              <path d="M4.5 4.5a2.25 2.25 0 012.25-2.25h10.5A2.25 2.25 0 0119.5 4.5v2.25h-15V4.5z" />
            </svg>
          </div>
          PocketLedger
        </div>
        <nav className="hidden md:flex gap-6 text-sm font-medium text-slate-300">
          <a href="#features" className="hover:text-emerald-400 transition-colors">Features</a>
          <a href="#solution" className="hover:text-emerald-400 transition-colors">Solution</a>
          <a href="#testimonials" className="hover:text-emerald-400 transition-colors">Reviews</a>
        </nav>
        <button className="bg-emerald-500 hover:bg-emerald-400 text-slate-900 font-bold px-5 py-2 rounded-full transition-all transform hover:scale-105">
          Get Early Access
        </button>
      </header>

      <main className="flex-1 w-full max-w-6xl mx-auto px-6 flex flex-col gap-24 py-16">
        
        {/* HERO */}
        <section className="flex flex-col md:flex-row items-center gap-12">
          <div className="flex-1 flex flex-col gap-6">
            <div className="inline-block px-3 py-1 bg-emerald-900/40 border border-emerald-500/20 text-emerald-400 text-xs font-semibold rounded-full w-max">
              100% Offline-First Architecture
            </div>
            <h1 className="text-5xl md:text-7xl font-extrabold tracking-tight text-white leading-tight">
              Take Control of Your Money &mdash; <span className="text-emerald-500">Even Offline.</span>
            </h1>
            <p className="text-lg md:text-xl text-slate-400 max-w-2xl leading-relaxed">
              PocketLedger is the extremely fast, privacy-focused personal finance app that tracks every rupiah without mandating internet access or cloud syncs.
            </p>
            <div className="flex items-center gap-4 pt-4">
              <button className="bg-emerald-500 hover:bg-emerald-400 text-slate-900 font-bold px-8 py-3.5 rounded-full text-lg transition-all transform hover:scale-105 shadow-xl shadow-emerald-500/20">
                Download for iOS
              </button>
              <button className="bg-slate-800 border border-slate-700 hover:bg-slate-700 text-white font-bold px-8 py-3.5 rounded-full text-lg transition-all hidden sm:block">
                Download for Android
              </button>
            </div>
          </div>
          <div className="flex-1 flex justify-center md:justify-end relative">
            <div className="absolute inset-0 bg-gradient-to-tr from-emerald-500/20 to-transparent blur-3xl -z-10 rounded-full" />
            <div className="w-[280px] h-[580px] bg-slate-800 rounded-[3rem] border-[8px] border-slate-900 shadow-2xl relative overflow-hidden flex flex-col">
              {/* Fake App screen */}
              <div className="bg-slate-900 flex-1 p-5 flex flex-col gap-6">
                <div className="flex justify-between items-center pt-8">
                  <div>
                    <div className="text-slate-400 text-xs">Total Balance</div>
                    <div className="text-white text-3xl font-bold">Rp 12.450.000</div>
                  </div>
                  <div className="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center">👤</div>
                </div>
                <div className="flex gap-4">
                  <div className="flex-1 bg-emerald-500/10 border border-emerald-500/20 rounded-2xl p-4">
                     <div className="text-emerald-400 text-xs mb-1">Income</div>
                     <div className="text-white font-semibold">Rp 15.000.000</div>
                  </div>
                  <div className="flex-1 bg-red-500/10 border border-red-500/20 rounded-2xl p-4">
                     <div className="text-red-400 text-xs mb-1">Expense</div>
                     <div className="text-white font-semibold">Rp 2.550.000</div>
                  </div>
                </div>
                <div className="mt-4">
                  <div className="text-sm font-semibold text-slate-300 mb-4">Recent Transactions</div>
                  {[1, 2, 3].map(i => (
                    <div key={i} className="flex justify-between items-center mb-4 pb-4 border-b border-slate-800 last:border-0">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-slate-800" />
                        <div>
                          <div className="text-sm font-medium text-white">Groceries</div>
                          <div className="text-xs text-slate-500">Today, 14:00</div>
                        </div>
                      </div>
                      <div className="text-red-400 font-semibold text-sm">-Rp 150.000</div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* PROBLEM */}
        <section id="solution" className="py-12 text-center flex flex-col items-center gap-6">
          <h2 className="text-3xl md:text-5xl font-bold text-white max-w-3xl">
            Most finance apps are broken.
          </h2>
          <p className="text-slate-400 text-lg max-w-2xl leading-relaxed">
            They require constant internet connectivity, force you to upload your sensitive financial history to unknown servers, and are bloated with slow UIs making entering a single transaction take way too long.
          </p>
        </section>

        {/* FEATURES GRID */}
        <section id="features" className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-slate-800/50 border border-slate-700/50 p-8 rounded-3xl flex flex-col gap-4 hover:bg-slate-800 transition-colors">
            <div className="w-12 h-12 bg-emerald-500/20 text-emerald-400 rounded-xl flex items-center justify-center text-2xl">
              ⚡
            </div>
            <h3 className="text-xl font-bold text-white">Ultra Fast Entry</h3>
            <p className="text-slate-400">Log a transaction in seconds. No waiting for server calls or arbitrary loading spinners. Pure local performance.</p>
          </div>
          <div className="bg-slate-800/50 border border-slate-700/50 p-8 rounded-3xl flex flex-col gap-4 hover:bg-slate-800 transition-colors">
            <div className="w-12 h-12 bg-blue-500/20 text-blue-400 rounded-xl flex items-center justify-center text-2xl">
              🔒
            </div>
            <h3 className="text-xl font-bold text-white">100% Private</h3>
            <p className="text-slate-400">All your financial data is stored locally in an SQLite database on your device. We couldn't look at it even if we wanted to.</p>
          </div>
          <div className="bg-slate-800/50 border border-slate-700/50 p-8 rounded-3xl flex flex-col gap-4 hover:bg-slate-800 transition-colors">
            <div className="w-12 h-12 bg-amber-500/20 text-amber-500 rounded-xl flex items-center justify-center text-2xl">
              📊
            </div>
            <h3 className="text-xl font-bold text-white">Smart Analytics</h3>
            <p className="text-slate-400">Beautiful, interactive charts powered by FL Chart to give you an instant overview of your spending habits and budget limits.</p>
          </div>
        </section>

        {/* TESTIMONIALS */}
        <section id="testimonials" className="py-16 text-center">
          <h2 className="text-3xl font-bold mb-12">Loved by Freelancers & Students</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="p-8 rounded-3xl bg-gradient-to-b from-slate-800 to-slate-900 border border-slate-800 text-left">
              <div className="flex text-amber-400 mb-4">★★★★★</div>
              <p className="text-slate-300 italic mb-6">"Finally an app that works flawlessly when I'm traveling without data. The speed at which I can log a coffee purchase is insane."</p>
              <div className="font-bold text-white">- Sarah J., Freelance Designer</div>
            </div>
            <div className="p-8 rounded-3xl bg-gradient-to-b from-slate-800 to-slate-900 border border-slate-800 text-left">
              <div className="flex text-amber-400 mb-4">★★★★★</div>
              <p className="text-slate-300 italic mb-6">"I don't trust cloud apps with my bank details. PocketLedger solving the privacy issue while looking this good is a game-changer."</p>
              <div className="font-bold text-white">- Budi A., Student</div>
            </div>
          </div>
        </section>

        {/* CTA */}
        <section className="bg-emerald-900/30 border border-emerald-500/20 rounded-3xl p-12 text-center flex flex-col items-center gap-6">
          <h2 className="text-4xl font-bold text-white">Ready to track your money safely?</h2>
          <p className="text-slate-400 max-w-xl">Join thousands of users who have taken back control of their financial privacy and budgeting.</p>
          <button className="mt-4 bg-emerald-500 hover:bg-emerald-400 text-slate-900 font-bold px-10 py-4 rounded-full text-xl transition-all transform hover:scale-105 shadow-xl shadow-emerald-500/20">
            Download PocketLedger Free
          </button>
        </section>
        
      </main>

      <footer className="w-full border-t border-slate-800 py-12 text-center text-slate-500 text-sm">
        <div className="mb-4">© 2026 PocketLedger. All rights reserved.</div>
        <div className="flex justify-center gap-6">
          <a href="/privacy" className="hover:text-slate-300">Privacy Policy</a>
          <a href="/terms" className="hover:text-slate-300">Terms of Service</a>
          <a href="/contact" className="hover:text-slate-300">Contact Support</a>
        </div>
      </footer>
    </div>
  );
}
