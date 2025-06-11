function checkLogin() {
    const userId = document.login.userId.value.trim();
    const userPasswd = document.login.userPasswd.value.trim();

    if (userId === "") {
        alert("이메일을 입력해주세요.");
        document.login.userId.focus();
        return false;
    }

    // 이메일 형식 간단히 검사 (선택)
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(userId)) {
        alert("올바른 이메일 형식을 입력해주세요.");
        document.login.userId.focus();
        return false;
    }

    if (userPasswd === "") {
        alert("비밀번호를 입력해주세요.");
        document.login.userPasswd.focus();
        return false;
    }

    return true; // 서버로 submit 진행
}
