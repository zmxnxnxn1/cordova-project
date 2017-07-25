// 알람 시작
function startAlarm() {
	getAlarmList() // 알람 리스트
}

// 알람 리스트를 불러온다.
function getAlarmList() {
	
	var userKey = getLocal('userKey'); // 유저키
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_alarm_list.jsp",
		dataType:'JSON',
		data:{"userKey":userKey},
		success:function(data) {
			createAlarmListHtml(data);
		}
	});
}

// 알람 리스트 데이터를 HTML 코드로 만든다.
function createAlarmListHtml(data) {

	var Html = '';
	Html += '<ul class="ui-listview-outer" data-role="listview" class="myMoimListUl">';
	Html += '<li class="sub-title">알림</li>';

	for (key in data["result"]) {
		Html += '<li data-role="collapsible" data-corners="false" data-shadow="false" data-iconpos="right">';
		Html += '<h2>'+data["result"][key]["alarmName"]+'</h2>';
		Html += '<ul data-role="listview" data-corners="false" data-shadow="false" data-inset="true">';
		Html += '<li><table style="width:100%;">';
		Html += '<tr><td>'+data["result"][key]["message"]+'</td></tr>';
		Html += '</table>';
		Html += '</li>';
		Html += '<li><a href="javascript:executeAlarmFunction('+data["result"][key]["function"]+')">이동</a></li>';
		Html += '<li style="margin-bottom:1.0em;"><a href="javascript:executeAlarmFunctionCheck('+data["result"][key]["seq"]+')">삭제</a></li>';
		Html += '</ul>';
		Html += '</li>';
	}
	Html += '</ul>';

	$(".alarmList").html(Html).trigger("create");
}

// 알람 펑션을 실행한다.
function executeAlarmFunction(executeFunction) {

}

function executeAlarmFunctionCheck(alarmSeq) {
	modal({
		type: 'confirm',
		title: '알림 삭제',
		text: '정말로 삭제하시겠습니까?',
		callback: function(result) {
			if (result == true) {
				executeAlarmFunctionDelete(alarmSeq);
			}
		}
	});
}

// 알람 펑션을 삭제한다..
function executeAlarmFunctionDelete(alarmSeq) {
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_alarm_delete.jsp",
		dataType:'JSON',
		data:{"alarmSeq":alarmSeq},
		success:function(data) {
			startAlarm();
		}
	});
}