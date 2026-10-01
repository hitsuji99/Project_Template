// Lấy các phần tử cần dùng
const form = document.getElementById("sign-up-form");
const email = document.getElementById("email");
const username = document.getElementById("username");
const password = document.getElementById("password");
// lấy các khu vực thông báo
const validation = document.getElementById("sign-up-validation");
const signUpError = document.getElementById("sign-up-error");
const signUpToast = document.getElementById("sign-up-toast");
// Lấy 3 thông báo "không được bỏ trống"
const passwordBlank = document.querySelector(".password-cannot-blank");
const usernameBlank = document.querySelector(".username-cannot-blank");
const emailBlank = document.querySelector(".email-cannot-blank");
// Lấy các thông báo lỗi còn lại
const emailError = document.querySelector(".email-error");
// Password tối thiểu 8
const passwordMinLengthError = document.querySelector(".password-min-length-error");
// Password phải có số
const passwordNumberError = document.querySelector(".password-number-required-error"
);
// phải có chữ hoa + chữ thường
const passwordCaseError = document.querySelector(".password-uppercase-lowercase-error");
// Bắt sự kiện submit
form.addEventListener("submit", function (e) {
    e.preventDefault();
//    console.log("sign up");
});
if (email.value.trim() === "") {
    emailBlank.classList.remove("hidden");
}
if (username.value.trim() === "") {
    usernameBlank.classList.remove("hidden"); 
    // xóa class hidden, làm thông báo xuất hiện.
}
if (password.value.trim() === "") {
    passwordBlank.classList.remove("hidden");
}

// mỗi lần submit chúng ta phải reset lỗi trước.
form.addEventListener("submit", function (e) {

    e.preventDefault();

    // Ẩn lỗi cũ trước
    emailBlank.classList.add("hidden");
    usernameBlank.classList.add("hidden");
    passwordBlank.classList.add("hidden");

    // Username không được để trống
    if (username.value.trim() === "") {
        usernameBlank.classList.remove("hidden");
    }

    // Email không được để trống
    if (email.value.trim() === "") {
        emailBlank.classList.remove("hidden");
    }

    // Password không được để trống
    if (password.value.trim() === "") {
        passwordBlank.classList.remove("hidden");
    }

    // Email đúng định dạng
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (email.value.trim() !== "" && !emailRegex.test(email.value)) {
        emailError.classList.remove("hidden");
    }

    // Password tối thiểu 8 ký tự
    if (
        password.value.trim() !== "" &&
        password.value.length < 8
    ) {
        passwordMinLengthError.classList.remove("hidden");
    }

    // Password phải có chữ số
    const numberRegex = /[0-9]/;

    if (
        password.value.trim() !== "" &&
        !numberRegex.test(password.value)
    ) {
        passwordNumberError.classList.remove("hidden");
    }

    // Password phải có chữ thường + chữ hoa
    const lowercaseRegex = /[a-z]/;
    const uppercaseRegex = /[A-Z]/;

    if (
        password.value.trim() !== "" &&
        (
            !lowercaseRegex.test(password.value) ||
            !uppercaseRegex.test(password.value)
        )
    ) {
        passwordCaseError.classList.remove("hidden");
    }

});