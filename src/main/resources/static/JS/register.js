let emailChecked = false;
let nicknameChecked = false;

	function check(){
		if(document.getElementById("userId").value==""){
        	alert("이메일을 입력해주세요");
            document.getElementById("userId").focus();
            return false;
	}
			
		if (!emailChecked) {
			alert("이메일 중복 확인을 해주세요.");
			return false;
		}
			
		if(document.getElementById("userNickname").value==""){
        	alert("닉네임을 입력해주세요");
            document.getElementById("userNickname").focus();
            return false;
		}
			
		if (!nicknameChecked) {
			alert("닉네임 중복 확인을 해주세요.");
			return false;
		}
			
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
		
		//이메일 유효성 검증 + 중복 검사
		function validateEmail() {
			  const email = document.getElementById("userId").value;
			  const statusDiv = document.getElementById("emailStatus");

			  statusDiv.textContent = "";
			  statusDiv.style.color = "red";

			  if (!email.includes("@")) {
				statusDiv.textContent = "이메일 주소에 '@'를 포함하세요.";
			    return false;
			  }

			  const emailRegex = /^[^\s@]+@[^\s@]+\.(com|net|org|co\.kr|kr|edu|gov|io|ai|me|shop|xyz)$/;

			  if (!emailRegex.test(email)) {
				statusDiv.textContent = "이메일 형식이 올바르지 않습니다. 예: example@domain.com";
			    return false;
			  }

			  // AJAX Email(userId)중복 검사
			  fetch(`/checkEmail?userId=` + encodeURIComponent(email))
			    .then(res => res.json())
			    .then(data => {
			      if (data) {
			    	statusDiv.textContent = "✅ 사용 가능한 이메일입니다.";
			    	statusDiv.style.color = "green";
			    	emailChecked = true;
			      } else {
			    	statusDiv.textContent = "❌ 이미 등록된 이메일입니다.";
			    	statusDiv.style.color = "red";
			    	emailChecked = false;
			      }
			    })
			return true;
		}
		
//닉네임 유효성 검증 + 중복 검사
	function validateNickname() {
		const nickname = document.getElementById("userNickname").value;
		const statusDiv = document.getElementById("nicknameStatus");
		
		statusDiv.textContent = "";
		statusDiv.style.color = "red";
		
		if (nickname.trim() === "") {
		  statusDiv.textContent = "닉네임을 입력해주세요.";
		  nicknameChecked = false;
		  return;
		}
		
		// AJAX 닉네임 중복 검사
		fetch(`/checkNickname?nickname=` + encodeURIComponent(nickname))
		  .then(res => res.json())
		  .then(data => {
		    if (data) {
		      statusDiv.textContent = "✅ 사용 가능한 닉네임입니다.";
		      statusDiv.style.color = "green";
		      nicknameChecked = true;
		    } else {
		      statusDiv.textContent = "❌ 이미 사용 중인 닉네임입니다.";
		      statusDiv.style.color = "red";
		      nicknameChecked = false;
		    }
		  });
	}