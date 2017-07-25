// 프로필
function startProfile() {
	getProfileModifyData(); // 기존 데이터
}

// 프로필 수정화면 데이터를 가져온다.
function getProfileModifyData() {

	var userKey = getLocal('userKey'); // 유저키
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_room_profileModifyView.jsp",
		dataType:'JSON',
		data:{"userKey":userKey},
		success:function(data) {
			$("input[name=regId]").val(data["nickname"]);

			var Html = "";

			Html += '<div data-role="fieldcontain">';
			Html += '<label for="slider2">성별</label>';
			Html += '<select name="subSex" data-role="slider">';
			if (data["sex"] == 1) {
				Html += '<option value="1">남</option>';
				Html += '<option value="2">여</option>';
			} else {
				Html += '<option value="2">여</option>';
				Html += '<option value="1">남</option>';
			}
			
			Html += '</select>';
			Html += '</div>';
			Html += '<div data-role="fieldcontain">';
			Html += '<label for="slider">나이</label>';
			Html += '<input type="range" name="subAge" value="'+data["age"]+'" min="0" max="100" data-highlight="true"  />';
			Html += '</div>';


			$(".profileData").html(Html).trigger("create");

		}
	});
}

// 프로필 수정 서브밋
function profileModifySubmit() {

	var userKey = getLocal('userKey'); // 유저키
	
	var regPw = $("input[name=regPw]").val();
	var subSex = $("select[name=subSex]").val();
	var subAge = $("input[name=subAge]").val();

	if (!regPw) {
		regPw = 0;
	}
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_room_profileUpdate.jsp",
		dataType:'JSON',
		data:{"userKey":userKey,"regPw":regPw,"subSex":subSex,"subAge":subAge},
		success:function(data) {
			modal({
				type: 'success',
				title: '수정',
				text: "수정을 완료하였습니다.",
				callback: function(result) {
					$('.profileModifyForm').slideUp(1000);
					setTimeout("history.back()", 1000);
				}
			}); // End of modal
		}
	});
}

// 회원탈퇴 - confirm
function profileMemberLeaveCheck() {
	modal({
		type: 'confirm',
		title: '회원 탈퇴',
		text: "정말로 탈퇴하시겠습니까? 탈퇴 후 복구가 불가능 합니다.",
		callback: function(result) {
			if (result == true) profileMemberLeaveSubmit();
		}
	});
}

// 회원탈퇴 서브밋
function profileMemberLeaveSubmit() {

	var userKey = getLocal('userKey'); // 유저키
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_room_profileLeave.jsp",
		dataType:'JSON',
		data:{"userKey":userKey},
		success:function(data) {
			modal({
				type: 'success',
				title: '회원 탈퇴',
				text: "그동안 이용해주셔서 감사합니다.",
				callback: function(result) {
					logout();
				}
			}); // End of modal
		}
	});
}

// 개선사항 입력 완료
function adviceSubmit() {

	var userKey = getLocal('userKey'); // 유저키
	var advice = $("textarea[name=advice]").val();
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_room_adviceSubmit.jsp",
		dataType:'JSON',
		data:{"userKey":userKey,"advice":advice},
		success:function(data) {
			modal({
				type: 'success',
				title: '완료',
				text: "감사합니다. 검토하여 반영하도록 하겠습니다.",
				callback: function(result) {
					history.back();
					$("textarea[name=advice]").val('');
				}
			}); // End of modal
		}
	});
}