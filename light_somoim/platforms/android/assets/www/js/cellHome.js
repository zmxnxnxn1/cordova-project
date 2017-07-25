// 셀 홈
function callCellHome() {
	callCellHomeInfo(); // 기본 정보
	cellUserList(); // 셀 유저 리스트
	getCellStateControButton(); // 가입,탈퇴,삭제 등 기능을 만든다.
	getCellUserInviteList(); // 유저 초대 리스트
	createUserInviteList(); // 초대 리스트 만들기
	cellTopMenuAddActive(0); // 샐 탑메뉴 색칠
	callMeeting(); // 정모 불러오기 (전체)
	callBoard(); // 게시판 불러오기 (전체)
}

// 셀 메인정보 불러오기
function callCellHomeInfo() {

	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호

	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_homeInfo.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {

			var Html = '';
			Html += '<div class="ui-bar ui-bar-a ui-corner-all" style="margin-bottom:1em; background-color:white; border-color:#38c; color:black;">';
			Html += '<p style="font-size:1.3em; text-align:center;">'+data["result"][0]["cellName"];
			if (data["cell_modify"] == 1) { // 모임 기본정보 수정
				Html += '<a style="float:right; margin-top:0" class="ui-btn ui-shadow ui-corner-all ui-icon-gear ui-btn-icon-notext" href="javascript:moveCellModify()"></a>';
			}
			Html += '</p>';
			Html += '<div style="text-align:right; color:#38c;">'+data["result"][0]["locationName"]+'</div>';
			Html += '</div>';
			Html += '<div class="ui-body ui-body-a ui-corner-all" style="margin-bottom:1em; border-color:#38c;">';
			Html += '<div>'+data["result"][0]["cellIntro"]+'</div>';
			Html += '</div>';
			
			$(".cellHomeInfo").html(Html).trigger("create");
		}
	});
}

// 셀 가입회원 리스트
function cellUserList() {
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호

	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_userList.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {
		
			var Html = '';
			Html += '<ul class="ui-listview-outer" data-role="listview" class="myMoimListUl">';
			Html += '<li style="background-color:#38c; font-weight:bold; color:white; text-align:center; font-size:1.2em;">멤버</li>';

			for (key in data["result"]) {
				Html += '<li data-role="collapsible" data-corners="false" data-shadow="false" data-iconpos="right">';
				Html += '<h2>'+data["result"][key]["userName"]+'</h2>';
				Html += '<ul data-role="listview" data-corners="false" data-shadow="false" data-inset="true" style="margin-bottom:1.0em;">';
				Html += '<li style="border-bottom-width:1px; border-right-width:1px;"><table style="width:100%;">';
				Html += '<tr><td>'+data["result"][key]["userMemo"]+'</td></tr>';
				Html += '</table>';
				Html += '</li>';

				if (data["result"][key]["grade_seq"] != 1) { // 모임장은 권한 변경 필요 없음
					// 가입 승인
					if (data["cellAdmin"][0]["member_approve"] && data["result"][key]["userGradeName"] == "가입대기") {
						Html += '<li><a href="javascript:cellUserApprove('+data["result"][key]["seq"]+')">가입승인</a></li>';
					}
					// 모임장 양도
					if (data["cellAdmin"][0]["cell_transfer"] && (data["result"][key]["grade_seq"] == 2 || data["result"][key]["grade_seq"] == 3)) {
						Html += '<li><a href="javascript:cellMasterTransferCheck('+data["result"][key]["seq"]+')">모임장 양도</a></li>';
					}
					// 멤버 권한 변경
					if (data["cellAdmin"][0]["cell_transfer"] && (data["result"][key]["grade_seq"] == 2 || data["result"][key]["grade_seq"] == 3)) {
						var changeGradeName = "";
						data["result"][key]["grade_seq"] == 2 ? changeGradeName = "일반회원으로" : changeGradeName = "운영진으로";
						Html += '<li><a href="javascript:cellUserGradeChange('+data["result"][key]["seq"]+')">'+changeGradeName+'</a></li>';
					}
					// 멤버 추방
					if (data["cellAdmin"][0]["cell_transfer"]) {
						Html += '<li><a href="javascript:cellUserBan('+data["result"][key]["seq"]+')">추방</a></li>';
					}
				}

				Html += '</ul>';
				Html += '</li>';
			}
			Html += '</ul>';
			
			$(".cellMemberList").html(Html).trigger("create");
			
		}
	});
}

// 가입 승인하기
function cellUserApprove(seq) {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	var approveUserSeq = seq; // 승인 받을 유저 seq
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_userApprove.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq, "approveUserSeq":approveUserSeq},
		success:function(data) {
			modal({
				type: 'success',
				title: '가입승인',
				text: "가입승인이 완료되었습니다.",
				callback: function(result) {
					cellUserList();
				}
			}); // End of modal
		}
	});
}

// 모임장 양도 confirm
function cellMasterTransferCheck(seq) {
	modal({
		type: 'confirm',
		title: '모임장 양도',
		text: "정말로 모임장을 해당유저에게 양도하시겠습니까?",
		callback: function(result) {
			if (result == true) cellMasterTransfer(seq);
		}
	});
}

// 모임장 양도하기
function cellMasterTransfer(seq) {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	var masterUserSeq = seq; // 모임장 받을 유저 seq
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_masterTransfer.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq, "masterUserSeq":masterUserSeq},
		success:function(data) {
			modal({
				type: 'success',
				title: '모임장 양도',
				text: "모임장 양도가 완료되었습니다.",
				callback: function(result) {
					callCellHome();
				}
			}); // End of modal
		},
		error:function(data) {}
	});
}

// 멤버 권한 변경 / 운영진->일반회원 / 일반회원->운영진
function cellUserGradeChange(seq) {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	var gradeChangeUserSeq = seq; // 등급 변경 받을 유저 seq
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_gradeChange.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq, "gradeChangeUserSeq":gradeChangeUserSeq},
		success:function(data) {
			modal({
				type: 'success',
				title: '등급 변경',
				text: "등급 변경이 완료되었습니다.",
				callback: function(result) {
					cellUserList();
				}
			}); // End of modal
		},
		error:function(data) {}
	});
}

// 멤버 추방
function cellUserBan(seq) {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	var banUserSeq = seq; // 추방 당하는 유저 seq
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_userBan.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq, "banUserSeq":banUserSeq},
		success:function(data) {
			modal({
				type: 'success',
				title: '추방',
				text: "추방이 완료되었습니다.",
				callback: function(result) {
					cellUserList();
				}
			}); // End of modal
		},
		error:function(data) {}
	});
}

// 모임 컨트롤 버튼을 불러온다.
// 가입하기, 탈퇴하기, 삭제하기
function getCellStateControButton() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_stateControl.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {
			
			var Html = "";
			
			if (data["CellJoin"][0]["gradeSeq"] == 0) {
				Html += '<a href="javascript:cellUserJoin()" data-role="button" data-theme="d" data-icon="heart">가입하기</a>';
			} else if (data["CellControl"][0]["cellLeave"] == 1) {
				Html += '<a href="javascript:cellUserLeave()" data-role="button" data-theme="f" data-icon="alert">탈퇴하기</a>';
			} else if (data["CellControl"][0]["cellDelete"] == 1) {
				Html += '<a href="javascript:cellDeleteCheck()" data-role="button" data-theme="c" data-icon="delete">모임삭제</a>';
			}
			
			$(".cellControl").html(Html).trigger("create");	
		}
	});
}

// 모임 가입하기
function cellUserJoin() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_userJoin.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {
			if (data["result"] == 3) {
				modal({
					type: 'success',
					title: '소모임 가입',
					text: "소모임 가입이 완료되었습니다.",
					callback: function(result) {
						callCellHome();
					}
				}); // End of modal
			} else if (data["result"] == 4) {
				modal({
					type: 'success',
					title: '소모임 가입',
					text: "소모임 가입을 요청하였습니다. \n승인 후 가입됩니다.",
					callback: function(result) {
						callCellHome();
					}
				}); // End of modal
			}
		}
	});
}

// 모임 탈퇴하기
function cellUserLeave() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_userLeave.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {
			modal({
				type: 'success',
				title: '소모임 탈퇴',
				text: "소모임을 탈퇴하였습니다.",
				callback: function(result) {
					callCellHome();
				}
			}); // End of modal
		}
	});
}

// 모암 삭제하기 confirm
function cellDeleteCheck() {
	modal({
		type: 'confirm',
		title: '모임 삭제',
		text: "정말로 모임을 삭제하시겠습니까? \n 삭제 후에는 복구가 불가능합니다.",
		callback: function(result) {
			if (result == true) cellDelete();
		}
	});
}

// 모임 삭제하기
function cellDelete() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_delete.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {
			modal({
				type: 'success',
				title: '소모임 삭제',
				text: "소모임 삭제가 완료되었습니다.",
				callback: function(result) {
					history.back();
					startMyMoim();
				}
			}); // End of modal
		},
		error:function(data) {}
	});
}

// 모임 멤버 초대 가능 리스트를 불러온다.
function getCellUserInviteList() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_userInviteList.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {

			
				var Html = '<div class="ui-controlgroup-controls">';
				Html += '<div><label class="ui-btn ui-corner-all" style="color:white; background-color:#38c; font-weight:Bold; font-size:1.2em">초대</label></div>';
				Html += '<fieldset data-role="controlgroup" style="margin:0">';
				for (key in data["result"]) {
					Html += '<input name="userInviteSeq[]" id="checkbox-'+(key)+'a" type="checkbox" value="'+data["result"][key]["userSeq"]+'" >';
					Html += '<label for="checkbox-'+(key)+'a">'+data["result"][key]["userName"]+'</label>';
				}
				Html += '</fieldset>';
				Html += '</div>';

				if (data["invite"][0]["memberInvite"] == 1 && data["result"].length != 0) { // 모임 초대 권한이 있을 경우에만 초대기능을 넣는다.
					Html += '<table style="width:100%; margin-top:0.5em;"><tr>';
					Html += '<td align=right><a class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-icon-action ui-btn-icon-right ui-btn-e" href="javascript:userInvite()">초대</a></td>';
					Html += '</tr></table>';
				} // End of if
				
				$(".cellInviteList").html(Html).trigger("create");

		} // End of success
	});
}

// 멤버를 초대한다.
function userInvite() {

	var inviteUserList = "";
	$(".cellInviteList div input[type=checkbox]").each(function(index) {
		if ($(this).is(":checked")) {
			inviteUserList += this.value + ";";
		}
	});
	
	inviteUserList = inviteUserList.slice(0, -1);
	
	if (inviteUserList == "") {
		modal({
			type: 'warning',
			title: '초대',
			text: "초대할 멤버를 선택하십시오."
		}); // End of modal
		return;
	}
	
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_alarm_inviteInsert.jsp",
		dataType:'JSON',
		data:{"cellSeq":cellSeq, "UserList":inviteUserList},
		success:function(data) {
			getCellUserInviteList();
			modal({
				type: 'success',
				title: '초대',
				text: "초대를 완료되었습니다."
			}); // End of modal
		}
	});
	
}

// 멤버 초대할 유져를 만든다.
function createUserInviteList() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호

	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_createInviteList.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		async: false,
		success:function(data) {
			getCellUserInviteList(); // 모임 멤버 초대 가능 리스트
		}
	});
}

// 모임 기본정보 수정 페이지로 이동한다.
function moveCellModify() {
	movePage("#pageModifyCell");
	getCellModifyData();
}

// 모임 기본정보 변경할 기본 데이터를 가져온다.
function getCellModifyData() {

	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_getModify.jsp",
		dataType:'JSON',
		data:{"userKey":userKey,"cellSeq":cellSeq},
		success:function(data) {
			$("input[name=modifyCellName]").val(data["result"][0]["cellName"]);
			$("textarea[name=modifyCellIntro]").val(data["result"][0]["intro"]);
			$("input[name=modifyCategory_name]").val(data["result"][0]["category_name"]);
			if (data["result"][0]["approve"] == 1) { // 1:승인필요
				$(".cellCreateContent .ui-controlgroup-controls .ui-checkbox .ui-first-child").removeClass("ui-checkbox-off").addClass("checkbox-on ui-checkbox-on");
			}
		} 
	});
}

// 모임 기본정보 수정 값 제출
function cellModifySubmit() {

	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	var cellName = $("input[name=modifyCellName]").val();
	var intro = $("textarea[name=modifyCellIntro]").val();
	var locationSeq = $("select[name=modifyLocationNumber] :selected").val();
	var categoryName = $("input[name=modifyCategory_name]").val();
	$("input[name=modifyApprove]").is(":checked") == true ? approve=1 : approve=0; // 1:승인필요
	
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_submitModify.jsp",
		dataType:'JSON',
		data:{"categoryName":categoryName,"locationSeq":locationSeq,"cellName":cellName,"intro":intro,"approve":approve,"userKey":userKey,"cellSeq":cellSeq},
		success:function(data) {
			modal({
				type: 'success',
				title: 'Success',
				text: cellName + ' 수정이 완료되었습니다.',
				callback: function(result) {
					history.back();
					callCellHomeInfo();
				}
			}); // End of modal
		} 
	});
}