/* =========================================================
   个人简历网站 · 交互脚本
   1) 中/EN 双语切换（记忆到 localStorage）
   关键约束：切换文本时不能破坏元素内的 SVG 图标，
   因此带图标的元素把文案包进 [data-lang-text]，
   脚本优先替换它，而不是整元素的 textContent。
   ========================================================= */

(function () {
  "use strict";

  var STORAGE_KEY = "resume-lang";
  var toggle = document.getElementById("langToggle");

  function pick(el, attr, lang) {
    return lang === "en" ? el.getAttribute("data-en") : el.getAttribute("data-zh");
  }

  function applyLang(lang) {
    var isEn = lang === "en";
    document.documentElement.lang = isEn ? "en" : "zh";

    // 包在 span 里的文案：只改 span，保住同级的图标
    document.querySelectorAll("[data-lang-text]").forEach(function (el) {
      var text = pick(el, null, lang);
      if (text != null) el.textContent = text;
    });

    // 纯文本元素：可以直接整体替换
    document.querySelectorAll("[data-zh][data-en]:not([data-lang-text])").forEach(function (el) {
      var text = pick(el, null, lang);
      if (text == null) return;
      if (el.tagName === "META") el.setAttribute("content", text);
      else if (el.tagName === "TITLE") el.textContent = text;
      else el.textContent = text;
    });

    // 按钮自身显示"另一种语言"
    if (toggle) toggle.textContent = isEn ? "中" : "EN";

    try { localStorage.setItem(STORAGE_KEY, lang); } catch (e) {}
  }

  var saved = null;
  try { saved = localStorage.getItem(STORAGE_KEY); } catch (e) {}
  applyLang(saved || document.documentElement.lang || "zh");

  if (toggle) {
    toggle.addEventListener("click", function () {
      var current = document.documentElement.lang === "en" ? "en" : "zh";
      applyLang(current === "en" ? "zh" : "en");
    });
  }
})();
