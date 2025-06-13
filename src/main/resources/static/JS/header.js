/**
 * 
 */
function toggleUserMenu() {
  const menu = document.getElementById("userDropdown");
  menu.style.display = (menu.style.display === "block") ? "none" : "block";
}

document.addEventListener('click', function (event) {
  const dropdown = document.getElementById("userDropdown");
  const icon = document.querySelector(".user-icon");
  if (!icon.contains(event.target) && !dropdown.contains(event.target)) {
    dropdown.style.display = "none";
  }
});