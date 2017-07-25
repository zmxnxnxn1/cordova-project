// 게시판
function callBoard() {
	getBoardList() // 게시글 리스트
}

// 게시글 리스트를 불러온다.
function getBoardList() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_boardList.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {

			var clickEvent;
			data["board_read"] == 1 ? clickEvent = "moveCellBoardView" : clickEvent = "alert('멤버가 아니면 글을 볼 수 없습니다.')";
			
			// 게시글 리스트를 HTML 코드로 만든다.
			var Html = "";

			for (key in data["result"]) {
				Html += '<a href="javascript:'+clickEvent+'('+data["result"][key]["seq"]+')'+'">';
				Html += '<div style="padding:10px; color:black; border-bottom:1px solid #38c;">';
				Html += '	<div>';
				Html += '		<span style="font-weight:bold;">'+data["result"][key]["reg_name"]+'</span>';
				Html += '		<span class="glyphicon glyphicon-comment" style="margin-left:10px; font-size:0.7em; color:gray"></span>';
				Html += '		<span style="font-size:0.8em; color:gray;">'+data["result"][key]["reply_count"]+'</span>';
				Html += '		<span style="font-size:0.9em; color:gray; float:right;">'+data["result"][key]["reg_date"]+'</span>';
				Html += '	</div>';
				Html += '	<hr style="margin-top:10px; margin-bottom:10px;" />';
				Html += '	<div style="font-weight:normal">'+data["result"][key]["title"]+'</div>';
				Html += '</div>';
				Html += '</a>';
			}
			
			$(".cellBoardList").html(Html).trigger("create");
		}
	});
}

// 게시글로 이동
function moveCellBoardView(boardSeq) {
	setLocal('boardSeq', boardSeq); // 로컬저장소에 boardSeq 값을 넣는다.

	$.mobile.changePage( "#pageBoardView", {transition: "flow", changeHash: true });
	callBoardView(); // 게시글 상세내용을 불러온다.
}

// 게시글 불러오기
function callBoardView() {
	getBoardView() // 게시글 본문
	getReplyList() // 리플 리스트
}

// 게시글 본문 불러오기
function getBoardView() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	var boardSeq = getLocal('boardSeq'); // 게시글 seq
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_boardView.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq, "boardSeq":boardSeq},
		success:function(data) {
			
			var Html = "";
			
			Html += '<div style="width:100%; background-color:white; border-top:1px solid gray; border-bottom:1px solid gray; padding:10px; color:black; ">';
			Html += '	<div>';
			Html += '		<span class="ui-btn ui-shadow ui-corner-all ui-icon-user ui-btn-icon-notext ui-btn-inline" style="margin:0"></span>';
			Html += '		<span style="font-weight:bold; margin-left:5px;">'+data["result"][0]["reg_name"]+'</span>';
			Html += '		<span style="font-size:0.9em; color:gray; margin-left:5px;">'+data["result"][0]["reg_date"]+'</span>';
			if (data["writer"] || data["board_admin"]) {
				Html += '<span class="boardAdminButton">';
				Html += '	<select name="boardControlSelectBox" seq="'+data["result"][0]["seq"]+'"onchange="boardControl(this)" style="font-size:0.9em">';
				Html += '		<option value="0" selected>관리</option>';
				if (data["writer"]) {
					Html += '		<option value="modify">수정</option>';
				}
				Html += '		<option value="delete">삭제</option>';
				Html += '	</select>';	
				Html += '</span>';
			}
			
			Html += '	</div>';
			Html += '	<hr style="margin-top:20px; margin-bottom:10px;" />';
			Html += '	<div style="font-weight:bold">'+data["result"][0]["title"]+'</div>';
			Html += '	<hr style="margin-top:10px; margin-bottom:10px;" />';
			Html += '	<div>'+data["result"][0]["description"]+'</div>';
			Html += '</div>';
			
			$("#cellBoardMain").html(Html).trigger("create");
		}
	});
}

// 게시글 관리 버튼 컨트롤
function boardControl(obj) {
	if (obj.value == 0) return;
	seq = $(obj).attr("seq");
	
	obj.value == "modify" ? moveBoardModify() : ""; // 게시글 수정
	obj.value == "delete" ? deleteCellBoard(seq) : ""; // 게시글 삭제
}

// 게시글 삭제
function deleteCellBoard(seq) {
	
	var boardSeq = getLocal('boardSeq'); // 게시글 seq

	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_boardDelete.jsp",
		dataType:'JSON',
		data:{"boardSeq":boardSeq},
		success:function(data) {
			modal({
				type: 'success',
				title: '삭제',
				text: "삭제를 완료하였습니다.",
				callback: function(result) {
					history.back();
					callBoard();
				}
			}); // End of modal
		}
	});
}

// 리플리스트 불러오기
function getReplyList() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	var boardSeq = getLocal('boardSeq'); // 게시글 seq
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_replyList.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq, "boardSeq":boardSeq},
		success:function(data) {
			
			var Html = "";
			for (key in data["result"]) {
				Html += '<div style="width:95%; margin:0 auto; padding:10px; color:black; margin-top:5px;">';
				Html += '	<div>';
				Html += '		<span style="font-weight:bold;">'+data["result"][key]["reg_name"]+'</span>';
				Html += '		<span style="font-size:0.9em; color:gray;">'+data["result"][key]["reg_date"]+'</span>';
				if (data["board_admin"]) { // 삭제 권한이 있을경우
					Html += '		<span style="float:right;"><button onclick="replyDeleteCheck('+data["result"][key]["seq"]+')" style="margin:0">삭제</button></span>';
				}
				Html += '	</div>';
				Html += '	<div style="margin-top:5px;">'+data["result"][key]["description"]+'</div>';
				Html += '</div>';
				Html += '<hr />';
			}
			
			$("#cellBoardReply").html(Html).trigger("create");
		}
	});
}

// 리플 삭제 - confirm
function replyDeleteCheck(seq) {
	modal({
		type: 'confirm',
		title: '삭제',
		text: "정말로 삭제하시겠습니까?",
		callback: function(result) {
			if (result == true) replyDelete(seq);
		}
	});
}

// 리플 삭제
function replyDelete(seq) {
	
	var replySeq = seq; // 리플 seq
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_replyDelete.jsp",
		dataType:'JSON',
		data:{"replySeq":replySeq},
		success:function(data) {
			modal({
				type: 'success',
				title: '삭제 완료',
				text: "삭제를 완료되었습니다.",
				callback: function(result) {
					callBoardView();
				}
			}); // End of modal
		}
	});
}

// 리플 등록
function insertReply() {
	
	var userKey = getLocal('userKey'); // 유저키
	var boardSeq = getLocal('boardSeq'); // 게시글 seq
	var replyDescription = $("input[name=reply_des]").val();
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_replyInsert.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "boardSeq":boardSeq, "replyDescription":replyDescription},
		success:function(data) {
			callBoardView();
		}
	});
}

// 글쓰기 화면으로 이동
function moveBoardWrite() {
	movePage("#pageBoardWrite");
}

// 글작성 제출하기
function submitCellBoardWrite() {
				
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	var title = $("input[name=title]").val();
	var description = $("textarea[name=description]").val();
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_boardWrite.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq, "title":title, "description":description},
		success:function(data) {
			modal({
				type: 'success',
				title: '완료',
				text: "작성을 완료되었습니다.",
				callback: function(result) {
					history.back();
					getBoardList();
				}
			}); // End of modal
		}
	});
}

// 게시글 수정화면으로 이동
function moveBoardModify() {
	movePage("#pageBoardModify");
	getCellBoardModify(); // 기존 작성 글
}

// 기존에 작성한 글 가져오기
function getCellBoardModify() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	var boardSeq = getLocal('boardSeq'); // 게시글 seq
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_boardGetModify.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq, "boardSeq":boardSeq},
		success:function(data) {
			$("input[name=modify_title]").val(data["result"][0]["title"]);
			$("textarea[name=modify_description]").val(data["result"][0]["description"]);
		}
	});
}

// 글 수정 제출하기
function submitCellBoardUpdate() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	var boardSeq = getLocal('boardSeq'); // 게시글 seq

	var title = $("input[name=modify_title]").val();
	var description = $("textarea[name=modify_description]").val();
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_boardSubmitModify.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq, "boardSeq":boardSeq, "title":title, "description":description},
		success:function(data) {
			modal({
				type: 'success',
				title: '수정',
				text: "수정을 완료되었습니다.",
				callback: function(result) {
					history.back();
					getBoardView();
				}
			}); // End of modal
		}
	});
}