// app/javascript/loading.js
const showLoading = () => {
  const el = document.getElementById("global-loading");
  if (el) el.classList.remove("hidden");
};

const hideLoading = () => {
  const el = document.getElementById("global-loading");
  if (el) el.classList.add("hidden");
};

// Turbo遷移開始 → 表示
document.addEventListener("turbo:visit", showLoading);

// Turbo描画完了 → 非表示
document.addEventListener("turbo:load", hideLoading);
document.addEventListener("turbo:render", hideLoading);

// 戻る/キャッシュ復元系で残らないように保険
document.addEventListener("turbo:before-cache", hideLoading);
