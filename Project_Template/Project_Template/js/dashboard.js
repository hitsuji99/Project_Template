// lay du lieu localStorage
let userList = JSON.parse(localStorage.getItem("userList")) || [];

// lay phan tu tbody
let tBody = document.getElementById("table-body");

// hien thi bang tu du lieu users trong localStorage
function renderUsers() {
  tBody.innerHTML = ""; // xoa du lieu cu

  userList.forEach((user) => {
     // nếu muốn đổi ngược thứ tự hiển thì dùng    for (let i = userList.length - 1; i >= 0; i--) {
     // let user = userList[i];

    // duyet tung user
    let statusClass = "deactive";
    if (user.status === "Active") {
      statusClass = "active";
    }

    let tr = document.createElement("tr"); // tao <tr>

    // them noi dung (id cua icon la usercode cua user)
    tr.innerHTML = `
      <td>${user.usercode}</td>
      <td>${user.username}</td>
      <td>${user.email}</td>
      <td class="uppercase">${user.role}</td>
      <td>${user.birthday}</td>
      <td>
        <span class="status-cell ${statusClass}">
          <span class="dot"></span>${user.status}
        </span>
      </td>
      <td>
        <i id="${user.usercode}" class="fa-solid fa-trash"></i>
        <i id="${user.usercode}" class="fa-solid fa-pen"></i>
      </td>
    `;

    tBody.appendChild(tr); // dua <tr> vao <tbody>
  });
}

renderUsers();

// bam vao icon trong bang
tBody.addEventListener("click", function (e) {
  // bam icon thung rac de xoa
  if (e.target.classList.contains("fa-trash")) {
    let deleteID = e.target.id;

    if (confirm("Bạn có chắc muốn xoá người dùng này không?")) {
      let deleteIndex = userList.findIndex((user) => user.usercode === deleteID);

      userList.splice(deleteIndex, 1);

      // luu lai vao localStorage
      localStorage.setItem("userList", JSON.stringify(userList));

      renderUsers();
    }
  }

  // bam icon cay but de sang trang edit
  if (e.target.classList.contains("fa-pen")) {
    // luu ma user can sua, trang edit se lay ra dung
    localStorage.setItem("editUserCode", e.target.id);
    window.location.href = "edit-user.html";
  }
});
