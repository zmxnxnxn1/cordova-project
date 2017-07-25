// 내모임 시작
function startMyMoim() {
	callJoinSomoimList(); // 가입한 소모임 리스트
}

// 내가 가입한 모임 불러오기
function callJoinSomoimList() {

	var userKey = getLocal('userKey'); // 유저키
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_joinList.jsp",
		dataType:'JSON',
		data:{"userKey":userKey},
		success:function(data) {

			var Html = '';
			Html += '<ul class="ui-listview-outer" data-role="listview" class="myMoimListUl">';
			Html += '<li class="sub-title">가입한 모임</li>';

			for (key in data["result"]) {
				//Html += '<li data-corners="false" data-shadow="false" data-iconpos="right">';
				Html += '<li data-role="collapsible" data-corners="false" data-shadow="false" data-iconpos="right">';
				Html += '<h2>'+data["result"][key]["cellName"]+'</h2>';
				Html += '<ul data-role="listview" data-corners="false" data-shadow="false" data-inset="true">';
				Html += '<li><table style="width:100%;">';
				Html += '<tr><td>'+data["result"][key]["categoryName"]+'</td><td style="text-align:right;">'+data["result"][key]["userCount"]+'명</td></tr>';
				Html += '</table>';
				Html += '</li>';
				Html += '<li style="margin-bottom:1.0em;;"><a href="javascript:moveCell('+data["result"][key]["seq"]+')">이동</a></li>';
				Html += '</ul>';
				Html += '</li>';
			}
			Html += '</ul>';

			Html += '<br /></br /><button onclick="moveCellCreate()">모임만들기</button>';
			
			$(".myMoimList").html(Html).trigger("create");
		}
	});
}

// 모임 만들기
function cellCreateSubmit() {

	var categoryName = $("input[name=category_name]").val();
	var locationSeq = $("select[name=locationNumber] :selected").val();
	var cellName = $("input[name=cellName]").val();
	var intro = $("textarea[name=cellIntro]").val();
	$("input[name=approve]").is(":checked") == true ? approve=1 : approve=0; // 1:승인필요
	var userKey = getLocal('userKey'); // 유저키
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_create.jsp",
		dataType:'JSON',
		data:{"categoryName":categoryName,"locationSeq":locationSeq,"cellName":cellName,"intro":intro,"approve":approve,"userKey":userKey},
		success:function(data) {
			modal({
				type: 'success',
				title: 'Success',
				text: cellName + ' 모임 생성이 완료되었습니다.',
				callback: function(result) {
					history.back();
					startMyMoim();
				}
			}); // End of modal
		} 
	});
}