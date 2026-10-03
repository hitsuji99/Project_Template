// lay cac phan tu trong dashboard
const tableBody = document.querySelector("#table-body");

const searchBox = document.querySelector("#search-box");

const paginationList = document.querySelector("#pagination-list");

const arrowLeft = document.querySelector(".arrow-left");

const arrowRight = document.querySelector(".arrow-right");

// so user hien thi tren 1 trang
const PAGE_SIZE = 5;

let users = []; // toan bo user trong localStorage
let showUsers = []; // user hien thi (sau khi search)
let currentPage = 1; // trang hien tai

//lay danh sach user tu localStorage
function loadUsers() {
  const usersText = localStorage.getItem("users");
    if (usersText === null) {
        users = [];
    } else {
        users = JSON.parse(usersText);
    }   

    showUsers = users; // hien thi toan bo user khi load
}

//  1--- hien thi bang tu du lieu trong users trong localStorage
function renderTable() {
  // xoa toan bo du lieu hien thi trong bang
  tableBody.innerHTML = "";
    const start = (currentPage - 1) * PAGE_SIZE;
    const pageUsers = showUsers.slice(start, start + PAGE_SIZE);

    pageUsers.forEach((user) => {
        const row = document.createElement("tr");
        const statusClass = user.status === "active" ? "active" : "deactive";
        const statusText = user.status === "active" ? "Active" : "Deactive";
 
        row.innerHTML =
            "<td>" + user.userCode + "</td>" +
            "<td>" + user.username + "</td>" +
            "<td>" + user.email + "</td>" +
            '<td class="uppercase">' + user.role + "</td>" +
            "<td>" + user.birthday + "</td>" +
            "<td>" +
                '<span class="status-cell ' + statusClass + '">' +
                    '<span class="dot"></span>' + statusText +
                "</span>" +
            "</td>" +
            "<td>" +
                '<i class="fa-solid fa-trash"></i>' +
                '<i class="fa-solid fa-pen"></i>' +
            "</td>";
                    // gan email vao dong de biet dang thao tac voi user nao


        row.dataset.email = user.email; // them thuoc tinh email vao row
        tableBody.appendChild(row);
    });
}
//  2--- Tính năng xoá từng hàng, từng bản ghi trong bảng dữ liệu users
tableBody.addEventListener("click", function (e) {
    const row = e.target.closest("tr");
    if (!row) {

            return;
}

const email = row.dataset.email; 

// bam icon de xoa user
if (e.target.classList.contains("fa-trash")) {
       const confirmDelete = confirm("Bạn có chắc muốn xoá người dùng " + email + " không?");

    if (!confirmDelete) {
        return;
    }

    // bo user co email ra khoi danh sach users
    users = users.filter(function (user) {
        return user.email !== email;
    });

    //luu lai danh sach users moi vao localStorage
    localStorage.setItem("users", JSON.stringify(users));

    // loc va ve lai bang hien thi
    search();
}

// sang trang edit user
if (e.target.classList.contains("fa-pen")) {
    // chuyen sang trang edit user
    window.location.href = "edit-user.html?email=" + encodeURIComponent(email);
}
});

//  3--- tim kiem user theo name --- 
function search() {
    const searchValue = searchBox.value.trim().toLowerCase();
    if (searchValue === "") {
        showUsers = users; // hien thi toan bo user khi search rong
    } else {
        showUsers = users.filter(function (user) {
            return user.username.toLowerCase().includes(searchValue);
        });
    }

    // tim xong thi quay ve trang 1
    currentPage = 1;
    renderTable();
    renderPagination();
}

searchBox.addEventListener("input", search);

// 4--- Tính năng hiển thị số trang tương ứng 5 đối tượng trên 1 trang
function renderPagination() {
    paginationList.innerHTML = "";
    const totalPages = Math.ceil(showUsers.length / PAGE_SIZE);

    for (let page = 1; page <= totalPages; page++) {
        const item = document.createElement("li");
        item.textContent = page;
        item.className = "pagination-element";

        // to mau trang hien tai
        if (page === currentPage) {
            item.classList.add("highlight");
        }

        // click vao so trang de chuyen trang
        item.addEventListener("click", function () {
            currentPage = page;
            renderTable();
            renderPagination();
        });
        
        paginationList.appendChild(item);
    }
}

// 5--- Tính năng chuyển trang bằng mũi tên
arrowLeft.addEventListener("click", function () {
    if (currentPage > 1) {
        currentPage--;
        renderTable();
        renderPagination();
    }
});

arrowRight.addEventListener("click", function () {
    const totalPages = Math.ceil(showUsers.length / PAGE_SIZE);
    if (currentPage < totalPages) {
        currentPage++;
        renderTable();
        renderPagination();
    }
});

// chay cac ham khi load trang
loadUsers();
renderTable();
renderPagination();

