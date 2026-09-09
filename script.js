/* =========================================================
   个人简历网站 · 交互脚本
   1) 中/EN 语言切换（记忆到 localStorage）
   2) 滚动淡入动画
   3) 技能进度条动画
   ========================================================= */

(function () {
  "use strict";

  /* ---------- 1. 双语切换 ---------- */
  var STORAGE_KEY = "resume-lang";
  var toggle = document.getElementById("langToggle");

  function applyLang(lang) {
    var isEn = lang === "en";
    document.documentElement.lang = isEn ? "en" : "zh";

    // 所有带 data-zh / data-en 的元素切换文字
    var nodes = document.querySelectorAll("[data-zh][data-en]");
    nodes.forEach(function (el) {
      el.textContent = isEn ? el.getAttribute("data-en") : el.getAttribute("data-zh");
    });

    // 切换按钮自身显示"另一种语言"
    if (toggle) toggle.textContent = isEn ? "中" : "EN";

    try { localStorage.setItem(STORAGE_KEY, lang); } catch (e) {}
  }

  // 初始语言：优先读取存储，否则用 <html lang>
  var saved = null;
  try { saved = localStorage.getItem(STORAGE_KEY); } catch (e) {}
  var initial = saved || document.documentElement.lang || "zh";
  applyLang(initial);

  if (toggle) {
    toggle.addEventListener("click", function () {
      var current = (document.documentElement.lang === "en") ? "en" : "zh";
      applyLang(current === "en" ? "zh" : "en");
    });
  }

  /* ---------- 2. 滚动淡入 ---------- */
  var revealEls = document.querySelectorAll(".reveal");
  if ("IntersectionObserver" in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          io.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 });
    revealEls.forEach(function (el) { io.observe(el); });
  } else {
    revealEls.forEach(function (el) { el.classList.add("is-visible"); });
  }

  /* ---------- 3. 技能进度条 ---------- */
  var bars = document.querySelectorAll(".bar__fill");
  function fillBars() {
    bars.forEach(function (bar) {
      var lvl = bar.getAttribute("data-level") || "0";
      bar.style.width = lvl + "%";
    });
  }
  if ("IntersectionObserver" in window && bars.length) {
    var barIO = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          fillBars();
          barIO.disconnect();
        }
      });
    }, { threshold: 0.2 });
    barIO.observe(bars[0].closest(".skills-grid") || bars[0]);
  } else {
    fillBars();
  }
})();
