// lay du lieu localStorage
const userList = JSON.parse(localStorage.getItem("userList")) || [];

// lay cac phan tu can dung
const form = document.getElementById("sign-in-form");

const msg = document.getElementById("msg");
const loginValidation = document.getElementById("login-validation");
const emailBlank = document.querySelector(".email-cannot-blank");
const passwordBlank = document.querySelector(".password-cannot-blank");
const loginToast = document.getElementById("login-toast");
const loginError = document.getElementById("login-error");
const closeBtn = document.querySelector(".close-btn");

form.addEventListener("submit", function (e) {
  e.preventDefault();

  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value;

  // an tat ca thong bao cu
  loginValidation.classList.add("hidden");
  emailBlank.classList.add("hidden");
  passwordBlank.classList.add("hidden");
  loginToast.classList.add("hidden");
  loginError.classList.add("hidden");
  msg.classList.remove("show");

  // email, password khong duoc de trong
  let isValid = true;

  if (email === "") {
    emailBlank.classList.remove("hidden");
    isValid = false;
  }

  if (password === "") {
    passwordBlank.classList.remove("hidden");
    isValid = false;
  }

  if (!isValid) {
    loginValidation.classList.remove("hidden");
    msg.classList.add("show");
    return;
  }

  // tim user khop ca email va password
  const result = userList.find((u) => u.email === email && u.password === password);

  if (!result) {
    loginError.classList.remove("hidden");
    msg.classList.add("show");
    return;
  }

  // dang nhap thanh cong: luu user dang dang nhap roi sang dashboard
  localStorage.setItem("userLoggedIn", JSON.stringify(result));
  loginToast.classList.remove("hidden");
  msg.classList.add("show");

    window.location.href = "dashboard.html";
});

// nut X tat thong bao loi
closeBtn.addEventListener("click", function () {
  loginValidation.classList.add("hidden");
  msg.classList.remove("show");
});
