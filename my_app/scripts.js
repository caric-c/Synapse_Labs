function redirectTo(page) {
  window.location.href = `details.html?page=${page}`;
}

function goBack() {
  window.history.back();
}

window.onload = function () {
  const params = new URLSearchParams(window.location.search);
  const page = params.get("page");

  if (page) {
    document.getElementById("page-title").innerText =
      page.charAt(0).toUpperCase() + page.slice(1);
    document.getElementById("content").innerText = `Details about ${page}.`;
  }
};
