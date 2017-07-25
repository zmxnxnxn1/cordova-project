// 정모
function callMeeting() {
	cellMeetingList(); // 정모 리스트
}

// 정모 리스트 불러오기
function cellMeetingList() {

	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호

	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_meeting_list.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {
		
			var Html = '';

			if (data["meetingCreateGrade"] == 1) { // 미팅 만들기 권한이 있으면 만들기 버튼을 생성한다.
				Html += '<div style="margin:1.0em;"><button onclick="moveCreateMeetingForm()">정모만들기</button></div> <br />';
			}

			Html += '<ul class="ui-listview-outer" data-role="listview" class="myMoimListUl">';
			
			for (key in data["result"]) {
				Html += '<li data-corners="false" data-shadow="false" data-iconpos="right">';
				Html += '<h2>'+data["result"][key]["title"]+'</h2>';


				Html += '<ul data-role="listview" data-corners="false" data-shadow="false" data-inset="true" style="margin-bottom:1.0em;">';
				Html += '<li style="border-bottom-width:1px; border-right-width:1px;"><table style="width:100%;">';
				Html += '<tr><td>모임 시간 : '+data["result"][key]["meeting_date"]+' '+data["result"][key]["meeting_time"]+'</td></tr>'; // 시간
				Html += '</table>';
				Html += '</li>';
				Html += '<li style="border-right-width:1px;"><table style="width:100%;">';
				Html += '<tr><td>모임 장소 : '+data["result"][key]["location"]+'</td></tr>'; // 장소
				Html += '</table>';
				Html += '</li>';

				/* [STR] 정모 수정 */
				if (data["userMeetingAdmin"] == 1) {
					Html += '<li><a href="javascript:moveMeetingModify('+data["result"][key]["seq"]+')">수정</a></li>';
				}
				/* [END] 정모 수정 */

				/* [STR] 참가신청, 참가취소 */
				if (data["result"][key]["enterMeeting"] == 0) {
					Html += '<li><a href="javascript:enterMeetingControl('+data["result"][key]["seq"]+', 1)">참가신청</a></li>';
				} else {
					Html += '<li><a href="javascript:enterMeetingControl('+data["result"][key]["seq"]+', 0)">참가취소</a></li>';
				}
				/* [END] 참가신청, 참가취소 */

				/* [STR] 참가자 목록 */
				Html += '<li data-role="collapsible" data-corners="false" data-shadow="false" data-iconpos="right">';
				Html += '<h5>참가자 목록</h5>';
				Html += '<ul class="meetingUserList" data-role="listview" data-corners="false" data-shadow="false" data-inset="true">';
				for (key2 in data["result"][key]["enterList"]) {
					Html +=	'<li>'+data["result"][key]["enterList"][key2]["enterName"]+'</li>';
				}
				Html += '</ul>';
				Html += '</li>';
				/* [END] 참가자 목록 */

				Html += '</ul>';
				Html += '</li>';
			}
			
			$(".cellMeetingList").html(Html).trigger("create");
			
		}
	});
}

// 정모참가 또는 참가취소를 한다.
function enterMeetingControl(meetingSeq, meetingEnter) {

	var userKey = getLocal('userKey'); // 유저키
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_meeting_enter.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "meetingSeq":meetingSeq, "meetingEnter":meetingEnter},
		success:function(data) {
			var enterResult = "";
			data["result"] == 1 ? enterResult = "참가신청을" : enterResult = "참가취소를";

			modal({
				type: 'success',
				title: '정모 참여',
				text: enterResult+" 완료되었습니다.",
				callback: function(result) {
					callMeeting();
				}
			}); // End of modal
		}
	});
}

// 정모만들기 화면으로 이동한다.
function moveCreateMeetingForm() {
	movePage("#pageCreateMeeting");
}

// 정모를 만든다. submit
function cellMeetingSubmit() {

	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	var meetingName = $("input[name=meetingName]").val();	
	var meetingDate = $("input[name=meetingDate]").val();	
	var meetingTime = $("input[name=meetingTime]").val();	
	var meetingLocation = $("input[name=meetingLocation]").val();
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_meeting_create.jsp",
		dataType:'JSON',
		data:{"userKey":userKey,"cellSeq":cellSeq,"meetingName":meetingName,"meetingDate":meetingDate,"meetingTime":meetingTime,"meetingLocation":meetingLocation},
		success:function(data) {
			modal({
				type: 'success',
				title: '정모만들기',
				text: meetingName + " 정모를 만들었습니다.",
				callback: function(result) {
					history.back();
					callMeeting();
				}
			}); // End of modal
		}
	});
}

// 정모 수정화면으로 이동한다.
function moveMeetingModify(seq) {
	setLocal("meetingSeq", seq);
	movePage("#pageModifyMeeting");
	getMeetingModifyData();
}

// 정모 수정화면 데이터를 가져온다.
function getMeetingModifyData() {

	var userKey = getLocal('userKey'); // 유저키
	var meetingSeq = getLocal('meetingSeq'); // 정모 번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_meeting_getModify.jsp",
		dataType:'JSON',
		data:{"userKey":userKey,"meetingSeq":meetingSeq},
		success:function(data) {
			$("input[name=modifyMeetingName]").val(data["result"][0]["meetingName"]);
			$("input[name=modifyMeetingDate]").val(data["result"][0]["meeting_date"]);
			$("input[name=modifyMeetingTime]").val(data["result"][0]["meeting_time"]);
			$("input[name=modifyMeetingLocation]").val(data["result"][0]["location"]);
		}
	});
}

// 정모 정모 수정 제출
function meetingModifySubmit() {

	var userKey = getLocal('userKey'); // 유저키
	var meetingSeq = getLocal('meetingSeq'); // 정모 번호
	
	var meetingName = $("input[name=modifyMeetingName]").val();	
	var meetingDate = $("input[name=modifyMeetingDate]").val();	
	var meetingTime = $("input[name=modifyMeetingTime]").val();	
	var meetingLocation = $("input[name=modifyMeetingLocation]").val();
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_meeting_submitModify.jsp",
		dataType:'JSON',
		data:{"userKey":userKey,"meetingSeq":meetingSeq,"meetingName":meetingName,"meetingDate":meetingDate,"meetingTime":meetingTime,"meetingLocation":meetingLocation},
		success:function(data) {
			modal({
				type: 'success',
				title: '수정',
				text: meetingName + " 수정을 완료하였습니다.",
				callback: function(result) {
					history.back();
					callMeeting();
				}
			}); // End of modal
		}
	});
}

// 정모 삭제 - confirm
function meetingDeleteCheck() {
	modal({
		type: 'confirm',
		title: '삭제',
		text: "정말로 삭제하시겠습니까?",
		callback: function(result) {
			if (result == true) meetingDelete();
		}
	});
}

// 정모 삭제
function meetingDelete() {

	var meetingSeq = getLocal('meetingSeq'); // 정모 번호

	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_meeting_delete.jsp",
		dataType:'JSON',
		data:{"meetingSeq":meetingSeq},
		success:function(data) {
			modal({
				type: 'success',
				title: '삭제',
				text: "삭제를 완료하였습니다.",
				callback: function(result) {
					history.back();
					callMeeting();
				}
			}); // End of modal
		}
	});
}