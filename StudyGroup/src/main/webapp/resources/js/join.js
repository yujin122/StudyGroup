//본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample4_postcode').value = data.zonecode;
                document.getElementById("sample4_roadAddress").value = roadAddr;
                
                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                if(roadAddr !== ''){
                    document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("sample4_extraAddress").value = '';
                }

                
            }
        }).open();
    }
    
    $(function(){
		$("#mem_pwd_check").keyup(function(){
			var pwd1 = $("#mem_pwd").val();
			var pwd2 = $("#mem_pwd_check").val();
			
			if(pwd1 == pwd2){
				$("#pwd_txt").text("비밀번호가 일치합니다.");
				$("#pwd_txt").css('color', 'green');
				$("#pwd_check").val("1");
			}else{
				$("#pwd_txt").text("비밀번호가 일치하지 않습니다.");
				$("#pwd_txt").css('color', 'red');
				$("#pwd_check").val("0");
			}
			
		});
	});
	
	function sign_up_check(){
		if($("#mem_name").val() == ''){
			alert("이름을 입력해주세요.");
			$("#mem_name").focus();
			return false;
		}
		if($("#mem_id").val() == ''){
			alert("아이디를 입력해주세요");
			$("#mem_id").focus();
			return false;
		}
		if($("#mem_pwd").val() == ''){
			alert("비밀번호를 입력해주세요");
			$("#mem_pwd").focus();
			return false;
		}
		if($("#pwd_check").val() != '1'){
			alert("비밀번호를 확인해주세요.");
			$("#mem_pwd_check").focus();
			return false;
		}
		if($("#mem_nickname").val() == ''){
			alert("닉네임을 입력해주세요");
			$("#mem_nickname").focus();
			return false;
		}
		if($("#mem_phone").val() == ''){
			alert("전화번호를 입력해주세요");
			$("#mem_phone").focus();
			return false;
		}
		if($("#mem_email").val() == ''){
			alert("이메일을 입력해주세요");
			$("#mem_email").focus();
			return false;
		}
	}
    