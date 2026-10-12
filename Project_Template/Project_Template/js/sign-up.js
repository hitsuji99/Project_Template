// lay du lieu localStorage
const userList = JSON.parse(localStorage.getItem("userList")) || [];

const form = document.getElementById("sign-up-form");


const msg = document.getElementById("msg");
const validation = document.getElementById("sign-up-validation");
const emailError = document.querySelector(".email-cannot-blank");
const userError = document.querySelector(".username-cannot-blank");
const passwordError = document.querySelector(".password-cannot-blank");

// regex
const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const usernameRegex = /^[a-zA-Z][a-zA-Z0-9_]{2,15}$/;
const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;

form.addEventListener("submit", function (e) {
  e.preventDefault();

  const email = document.getElementById("email").value.trim();
  const username = document.getElementById("username").value.trim();
  const password = document.getElementById("password").value;

  // reset cac loi
  emailError.innerText = "";
  userError.innerText = "";
  passwordError.innerText = "";
  validation.classList.add("hidden");
  msg.classList.remove("show");

  let isValid = true;
  const checkEmail = userList.some((u) => u.email === email);

  if (!emailRegex.test(email)) {
    emailError.innerText = "Email không hợp lệ";
    isValid = false;
  }

  if (!usernameRegex.test(username)) {
    userError.innerText = "Username không hợp lệ";
    isValid = false;
  }

  if (!passwordRegex.test(password)) {
    passwordError.innerText = "Password không hợp lệ";
    isValid = false;
  }

  // co loi thi hien khung thong bao
  if (!isValid) {
    validation.classList.remove("hidden");
    msg.classList.add("show");
    return;
  }

  // dang ky thanh cong
  const newUser = {
    usercode: "U" + Date.now(),
    username: username,
    email: email,
    password: password,
    role: "user",
    birthday: "",
    status: "Active",
    description: "",
  };

  userList.push(newUser);  // nếu muốn thêm user mới lên đầu tiên thì dùng unshift thay vì push userList.unshift(newUser);
  localStorage.setItem("userList", JSON.stringify(userList));
  window.location.href = "./sign-in.html";
});