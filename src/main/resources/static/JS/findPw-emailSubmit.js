function emailCheck(){
	const userId = document.getElementById("userId").value;
	
	if(userId===""){
		alert("이메일을 입력해주세요");
		document.getElementById("userId").focus();
		return false;
	}
	// Ajax: DB에 존재하는 이메일인지 확인
	fetch("/checkEmailExists?userId=" + encodeURIComponent(userId))
		.then(response => response.json())
	    .then(result => {
	    	if (result) {
	       		alert("이메일이 전송되었습니다.");
	                document.findPassword.submit();  // form submit 진행
	        } else {
	        	alert("존재하지 않는 이메일입니다.");
	        }
	    });

	return false; // 원래 submit 막고, Ajax 결과에 따라 submit
}