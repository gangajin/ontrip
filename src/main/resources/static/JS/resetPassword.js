function pwCheck(){
    const pw = document.getElementById("userPasswd").value;
	const pw2 = document.getElementById("userPasswd2").value;

	if(pw === ""){
		alert("비밀번호를 입력해주세요");
		document.getElementById("userPasswd").focus();
		return false;
	}

	if(pw2 === ""){
		alert("비밀번호 확인을 입력해주세요");
		document.getElementById("userPasswd2").focus();
		return false;
	}

	//비밀번호 유효성 검사
	const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+=-]).{8,}$/;

	if (!pwRegex.test(pw)) {
		alert("비밀번호는 8자이상, 영문자/숫자/특수문자를 각각 1개 이상 포함해야 합니다.");
		document.getElementById("userPasswd").value = "";
		document.getElementById("userPasswd2").value = "";
		document.getElementById("userPasswd").focus();
		return false;
	}

	//비밀번호 일치 확인
	if(pw !== pw2){
		alert("비밀번호가 일치하지 않습니다! 다시 입력하세요");
		document.getElementById("userPasswd").value = "";
		document.getElementById("userPasswd2").value = "";
		document.getElementById("userPasswd").focus();
		return false;
	}
	return true;
}
