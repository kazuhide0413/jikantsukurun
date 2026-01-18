// app/javascript/loading.js

const LOADING_ID = "global-loading";

const showLoading = () => {
  const el = document.getElementById(LOADING_ID);
  if (!el) return;
  el.classList.remove("hidden");
};

const hideLoading = () => {
  const el = document.getElementById(LOADING_ID);
  if (!el) return;
  el.classList.add("hidden");
};

// 1) Turbo使ってる遷移ではここでも出る（使ってないなら何もしない）
document.addEventListener("turbo:visit", showLoading);
document.addEventListener("turbo:load", hideLoading);
document.addEventListener("turbo:render", hideLoading);
document.addEventListener("turbo:before-cache", hideLoading);

// 2) Turboが効かない（フルリロード）リンクでも出す
document.addEventListener("click", (e) => {
  const a = e.target.closest("a");
  if (!a) return;

  // 新規タブ・別操作は除外
  if (a.target === "_blank") return;
  if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;

  const href = a.getAttribute("href");
  if (!href || href.startsWith("#") || href.startsWith("javascript:")) return;

  // 外部リンクは除外（必要なら外してOK）
  const url = new URL(a.href, window.location.href);
  if (url.origin !== window.location.origin) return;

  showLoading();
});

// 3) フォーム送信（POST/PUT/PATCH/DELETE）でも出す
document.addEventListener("submit", (e) => {
  const form = e.target;
  if (!(form instanceof HTMLFormElement)) return;

  // GET検索フォームなどは除外（必要なら外してOK）
  const method = (form.getAttribute("method") || "get").toLowerCase();
  if (method === "get") return;

  showLoading();
});

// 4) 送信ボタンを「処理中…」にして二重送信防止
document.addEventListener("submit", (e) => {
  const form = e.target;
  if (!(form instanceof HTMLFormElement)) return;

  // GET検索フォームなどは対象外
  const method = (form.getAttribute("method") || "get").toLowerCase();
  if (method === "get") return;

  // data-loading-button が付いた送信ボタンだけを対象にする
  const btn =
    form.querySelector('button[type="submit"][data-loading-button]') ||
    form.querySelector('input[type="submit"][data-loading-button]');

  if (!btn) return;

  // 二重送信防止
  btn.disabled = true;

  // 元の表示を保存
  if (!btn.dataset.originalText) {
    btn.dataset.originalText = btn.tagName.toLowerCase() === "input" ? btn.value : btn.innerHTML;
  }

  const loadingHtml = `
    <span class="inline-flex items-center justify-center gap-2">
      <span class="h-5 w-5 animate-spin rounded-full border-2 border-black/30 border-t-black"></span>
      処理中...
    </span>
  `;

  if (btn.tagName.toLowerCase() === "input") {
    btn.value = "処理中...";
  } else {
    btn.innerHTML = loadingHtml;
  }
});