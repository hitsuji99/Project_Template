
// lấy các phần tử 
const signInForm = document.querySelector("#sign-in-form");
const email = document.querySelector("#email");
const password = document.querySelector("#password");

const loginValidation = document.querySelector("#login-validation");
const emailCannotBlank = document.querySelector(".email-cannot-blank");
const passwordCannotBlank = document.querySelector(".password-cannot-blank");
const closeBtn = document.querySelector(".close-btn");

const loginToast = document.querySelector("#login-toast");
const loginError = document.querySelector("#login-error");
const msg = document.querySelector("#msg");

// an tat ca thong bao 

function hideAllMessages() {
    loginValidation.classList.add("hidden");
    emailCannotBlank.classList.add("hidden");
    passwordCannotBlank.classList.add("hidden");
    loginToast.classList.add("hidden");
    loginError.classList.add("hidden");
    msg.classList.remove("show");
}

signInForm.addEventListener("submit", function(e) {
    e.preventDefault();

    hideAllMessages();

    const emailValue = email.value.trim();
    const passwordValue = password.value.trim();

    // email ko duoc de trong 
    if (emailValue === "") {
        emailCannotBlank.classList.remove("hidden");
        loginValidation.classList.remove("hidden");
        msg.classList.add("show");
        email.focus();  // con trỏ nhảy vào ô email
        return;
    }
    // mat khau ko duoc de trong
    if (passwordValue === "") {
        passwordCannotBlank.classList.remove("hidden");
        loginValidation.classList.remove("hidden");
        msg.classList.add("show");
        password.focus();
        return;
    }

    // lay danh sach nguoi dung da dang ky 
    const usersText = localStorage.getItem("users");
    let users = [];

    if(usersText !== null) {
        users = JSON.parse(usersText);
    }

    // tim nguoi dung khop voi ca email va password 
    const user = users.find( function (u) {
        return u.email === emailValue && u.password === passwordValue;        
    });

    // email hoac password ko ton tai
    if (!user) {
        loginError.classList.remove("hidden");
        msg.classList.add("show");
        return;
    }

    // dang nhap thanh cong, chuyen dashboard
    localStorage.setItem("loggedInUser", JSON.stringify(user));
    loginToast.classList.remove("hidden");
    msg.classList.add("show");

    window.location.href = "./dashboard.html";
    
}) ;

// nut X 
closeBtn.addEventListener("click", function () {
    loginValidation.classList.add("hidden");
     msg.classList.remove("show");
});
