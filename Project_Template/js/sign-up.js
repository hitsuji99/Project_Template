// Lấy các phần tử cần dùng
const form = document.getElementById("sign-up-form");
const email = document.getElementById("email");
const username = document.getElementById("username");
const password = document.getElementById("password");
// lấy các khu vực thông báo
const validation = document.getElementById("sign-up-validation");
const signUpError = document.getElementById("sign-up-error");
const signUpToast = document.getElementById("sign-up-toast");
const msg = document.getElementById("msg");
// Lấy 3 thông báo "không được bỏ trống"
const passwordBlank = document.querySelector(".password-cannot-blank");
const usernameBlank = document.querySelector(".username-cannot-blank");
const emailBlank = document.querySelector(".email-cannot-blank");
// Lấy các thông báo lỗi còn lại
const emailError = document.querySelector(".email-error");
// Password tối thiểu 8
const passwordMinLengthError = document.querySelector(
  ".password-min-length-error",
);
// Password phải có số
const passwordNumberError = document.querySelector(
  ".password-number-required-error",
);
// phải có chữ hoa + chữ thường
const passwordCaseError = document.querySelector(
  ".password-uppercase-lowercase-error",
);
form.noValidate = true;
passwordBlank.classList.add("hidden");
usernameBlank.classList.add("hidden");
emailBlank.classList.add("hidden");
// mỗi lần submit chúng ta phải reset lỗi trước.
form.addEventListener("submit", function (e) {
   e.preventDefault();

  // Mặc định cho rằng dữ liệu hợp lệ
  let blankError = false;
  let formatError = false;

  // Ẩn lỗi cũ trước
  emailBlank.classList.add("hidden");
  usernameBlank.classList.add("hidden");
  passwordBlank.classList.add("hidden");

  validation.classList.add("hidden");

  msg.classList.remove("show");

  emailError.classList.add("hidden");
  passwordMinLengthError.classList.add("hidden");
  passwordNumberError.classList.add("hidden");
  passwordCaseError.classList.add("hidden");

  signUpError.classList.add("hidden");
  signUpToast.classList.add("hidden");

  // Username không được để trống

  if (username.value.trim() === "") {
    usernameBlank.classList.remove("hidden");

    blankError = true;
  }

  // Email không được để trống

  if (email.value.trim() === "") {
    emailBlank.classList.remove("hidden");
   

   blankError = true;
  }

  // Email đúng định dạng

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  if (email.value.trim() !== "" && !emailRegex.test(email.value.trim())) {
    emailError.classList.remove("hidden");

    formatError = true;
  }

  // Password không được để trống

  if (password.value.trim() === "") {
    passwordBlank.classList.remove("hidden");
    validation.classList.remove("hidden");

    blankError = true;
  }

  // Password tối thiểu 8 ký tự

  if (password.value.trim() !== "" && password.value.trim().length < 8) {
    passwordMinLengthError.classList.remove("hidden");

    formatError = true;
  }

  // Password phải có chữ số

  const numberRegex = /[0-9]/;

  if (password.value.trim() !== "" && !numberRegex.test(password.value.trim())) {
    passwordNumberError.classList.remove("hidden");

    formatError = true;
  }

  // Password phải có chữ hoa + chữ thường

  const lowercaseRegex = /[a-z]/;
  const uppercaseRegex = /[A-Z]/;

  if (
    password.value.trim() !== "" &&
    (!lowercaseRegex.test(password.value.trim()) ||
      !uppercaseRegex.test(password.value.trim()))
  ) {
    passwordCaseError.classList.remove("hidden");

    formatError = true;
  }

  // Có lỗi thì hiện thông báo

  if (blankError === true || formatError === true) {
    msg.classList.add("show");

    if (blankError === true) {
        validation.classList.remove("hidden");
    }
    if (formatError === true) {
    // Nếu email format hoặc password có lỗi
    signUpError.classList.remove("hidden");
  }
}
  // Nếu tất cả đều hợp lệ

  if (blankError ===  false && formatError === false) {
    msg.classList.add("show");
    signUpToast.classList.remove("hidden");

     // Lấy danh sách người dùng đã đăng ký từ localStorage
    const usersText = localStorage.getItem("users");
    let users = [];

    if (usersText !== null) {
        users = JSON.parse(usersText);
    }
    // Thêm người dùng mới vào cuoi danh sách

    users.push({
        email: email.value.trim(),
        username: username.value.trim(),
        password: password.value.trim(),
    });
    // lưu danh sách người dùng vào localStorage
    localStorage.setItem("users", JSON.stringify(users));

    localStorage.setItem("signUpSuccess", "Đăng ký thành công");
    
        window.location.href = "./sign-in.html";
}
});

