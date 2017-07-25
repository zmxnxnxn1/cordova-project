var cellTopMenuNumberAddActive = 1; // 탑 메뉴 색칠 기본값 (전역변수)
var matchingLoadingCheck = 0; // 매칭 중인지 확인 값 (전역변수);

function appStart() {
	defaultJspFileRoute(); // JSP 기본 경로 설정
	loadHeaderMenu('main'); // 헤더 메뉴 출력
	getLastTopMenuNumber(); // 마지막으로 접속한 탑 메뉴 번호
	settingMainPanel(); // 라이트 메뉴 세팅
	loadRightMenu(); // 라이트 메뉴 출력
	settingMainPanel() // 패널 기본 세팅
	loginCheck(); // 로그인 체크
}

//JSP 파일 기본 경로를 설정한다.
function defaultJspFileRoute() {
	//jspFileRoute = "http://localhost:8080/JSON_OUTPUT/";
	jspFileRoute = "http://doubleah.com:9000/light_somoim/";
}

// 페이지를 이동한다.
function movePage(page) {
	//location.href = page;
	$.mobile.changePage( page, {transition: "flip", changeHash: true });
}

// 페이지를 이동한다. 트랜지션 : pop
function movePagePop(page) {
	$.mobile.changePage( page, {transition: "pop", changeHash: true });
}

// 로컬공간 값 확인
function checkLocal(value) {
	alert(window.localStorage.getItem(value));
	console.log(window.localStorage.getItem(value));
}

// 로컬공간 값 가져오기
function getLocal(value) {
	var result = window.localStorage.getItem(value);
	return result;
}

// 로컬공간 값 설정
function setLocal(key, value) {
	window.localStorage.setItem(key, value);
}

// 로컬공간 값 삭제
function delLocal(value) {
	window.localStorage.removeItem(value);
}

// 로컬공간 값 임의조작 <- admin
function controlLocal(key) {
	var result = prompt('값을 입력하세요.', '');
	if (!result) return;
	window.localStorage.setItem(key, result);
}

// 로그인 상태인지 확인한다.
function loginCheck() {
	var loginKeyCheck = getLocal("userKey");

	if (loginKeyCheck == null) {
		location.replace("index.html");
	}
}

// 로그아웃 - confirm
function logoutCheck() {
	modal({
		type: 'confirm',
		title: '로그아웃',
		text: "정말로 로그아웃 하시겠습니까?",
		callback: function(result) {
			if (result == true) logout();
		}
	});
}

// 로그아웃
function logout() {
	window.localStorage.removeItem("userKey");
	window.localStorage.removeItem("cellNumber");
	window.localStorage.removeItem("boardSeq");
	window.localStorage.removeItem("meetingSeq");
	location.replace("index.html");
}

// 모임으로 이동한다.
function moveCell(num) {
	setLocal('cellNumber', num);
	$.mobile.changePage( "#pageCell", {transition: "slidefade", changeHash: true });
	loadHeaderMenu('cell');
	callCellHome();
}

// 모임만들기로 이동한다.
function moveCellCreate() {
	movePage("#pageCreateCell");
}

// 헤더를 만든다.
function loadHeaderMenu(page) {
	var Html = "";

	if (page == 'main') {
		Html += '<a style="color:#A6A6A6;" name="topMenu1" href="javascript:clickTopMenu(1)">';
		Html += '<span class="glyphicon glyphicon-search"></span></a>';
		Html += '<a style="color:#A6A6A6;" name="topMenu2" href="javascript:clickTopMenu(2)">';
		Html += '<span class="glyphicon glyphicon-flag"></span></a>';
		Html += '<a style="color:#A6A6A6;" name="topMenu3" href="javascript:clickTopMenu(3)">';
		Html += '<span class="glyphicon glyphicon-bell"></span></a>';
		Html += '<a style="color:#A6A6A6;" name="topMenu4" href="javascript:callPanel()">';
		Html += '<span class="glyphicon glyphicon-cog"></span></a>';

		$('.header_main').html(Html).trigger("create");
	} else if (page == 'cell') {
		Html += '<a style="color:black;" href="javascript:history.back()">';
		Html += '<span class="glyphicon glyphicon-arrow-left"></span></a>';
		Html += '<a style="color:#A6A6A6;" name="cellTopMenu1" href="javascript:clickCellTopMenu(1)">';
		Html += '<span class="glyphicon glyphicon-home"></span></a>';
		Html += '<a style="color:#A6A6A6;" name="cellTopMenu2" href="javascript:clickCellTopMenu(2)">';
		Html += '<span class="glyphicon glyphicon-calendar"></span></a>';
		Html += '<a style="color:#A6A6A6;" name="cellTopMenu3" href="javascript:clickCellTopMenu(3)">';
		Html += '<span class="glyphicon glyphicon-book"></span></a>';

		$('.header_cell').html(Html).trigger("create");
	}
	
}

// 우측 메뉴를 만든다.
function loadRightMenu() {
	var Html = "";
	Html  = '<div class="packet_menu packet_menu_header"> ';
	Html += '<span class="glyphicon glyphicon-send"></span>광주 소모임';
	Html += '</div>';
	Html += '<div class="packet_menu" onclick="moveProfile()"><a> 프로필 </a></div>';
	//Html += '<div class="packet_menu"><a> 설 정 </a></div>';
	Html += '<div class="packet_menu" onclick="moveAdvice()"><a> 개 선 </a></div>';
	Html += '<div class="packet_menu" onclick="logoutCheck()"><a data-ajax="false"> 로그아웃 </a></div>';
	/*Html += '<div class="packet_menu"><a>----------------------------- </a></div>';
	Html += '<div class="packet_menu"><a href="javascript:alert(getLocal(\'userKey\'))"> 키값 확인 </a></div>';
	Html += '<div class="packet_menu"><a href="javascript:controlLocal(\'userKey\')"> 키값 조작 </a></div>';
	*/
	$('.right-panel').html(Html).trigger("create");
}

// 프로필 화면으로 이동한다.
function moveProfile() {
	movePage('#pageProfileModify');
	$(".profileModifyForm").css("display", "none");
	setTimeout("$('.profileModifyForm').slideDown(1000)", 500);
	
	startProfile();
}

// 개선 화면으로 이동한다.
function moveAdvice() {
	movePage('#pageAdvice');

	$(".adviceContent").css("display", "none");
	setTimeout("$('.adviceContent').slideDown(1000)", 500);
}

// 패널을 부른다.
function callPanel() {
	$( ".right-panel" ).panel( "open" );
}

// 메인 패널 세팅
function settingMainPanel() {
	$( document ).on( "pagecreate", "#pageMain", function() {
			$( document ).on( "swipeleft", "#pageMain", function( e ) {
					if ( $( ".ui-page-active" ).jqmData( "panel" ) !== "open" ) {
								$( ".right-panel" ).panel( "open" );
					}
			});
	});
}

// 위 : main // 아래 : cell
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

// 탑 메뉴 클릭
function clickTopMenu(num) {
	setLocal("topMenuNumber", num);
	getLastTopMenuNumber();
}

// 선택한 탑 메뉴 불러오기
function getLastTopMenuNumber() {
	var num = getLocal("topMenuNumber");
	$(".header a").removeClass("ui-active");
	$("a[name=topMenu"+num+"]").addClass("ui-active");

	callMainContent(num); // 메인 컨텐츠
}

// 메인 컨텐츠 불러오기
function callMainContent(num) {
	$(".somoim").css("display", "none");
	$(".myMoim").css("display", "none");
	$(".alarm").css("display", "none");

	if (num == 1) { // 소모임
		callContentSomoim();
	} else if (num == 2) { // 내모임
		callContentMyMoim();
	} else { // 설정
		callContentAlarm();
	}
}

// 소모임 불러오기
function callContentSomoim() {
	//$(".somoim").css("display", "block");
	$('.somoim').fadeIn(500);
}

// 내모임 불러오기
function callContentMyMoim() {
	//$(".myMoim").css("display", "block");
	$('.myMoim').fadeIn(500);
	startMyMoim();
}

// 알람 불러오기
function callContentAlarm() {
	//$(".alarm").css("display", "block");
	$('.alarm').fadeIn(500);
	startAlarm();
}

/* // [STR] 셀 // *//* // [STR] 셀 // *//* // [STR] 셀 // *//* // [STR] 셀 // */

// 셀 탑 메뉴 클릭 이벤트
function clickCellTopMenu(num) {
	$(".cellHome").css("display", "none");
	$(".cellMeeting").css("display", "none");
	$(".cellBoard").css("display", "none");

	cellTopMenuAddActive(num); // 색칠

	if (num == 1) { // HOME
		callContentCellHome();
	} else if (num == 2) { // 정모
		callContentCellMeeting();
	} else { // 게시판
		callContentCellBoard();
	}
}

// HOME 불러오기
function callContentCellHome() {
	//$(".cellHome").css("display", "block");
	$('.cellHome').slideDown(1000);
	callCellHome(); // 모임 홈
}

// 정모 불러오기
function callContentCellMeeting() {
	$(".cellMeeting").css("display", "block");
	//('.cellMeeting').slideDown(500);
	callMeeting(); // 정모
}

// 게시판 불러오기
function callContentCellBoard() {
	$(".cellBoard").css("display", "block");
	//('.cellBoard').slideDown(500);
	callBoard(); // 게시판
}

// 모임의 경우 HOME로 이동함
function moveAbsoluteCellHome() {
	callContentCellHome(); // HOME
	$("a[name=cellTopMenu1]").addClass("ui-active");
}

// 셀 탑메뉴 색칠하기
function cellTopMenuAddActive(num) {
	if (num != 0) {
		cellTopMenuNumberAddActive = num;
	}

	$(".header_cell a").removeClass("ui-active");
	$("a[name=cellTopMenu"+cellTopMenuNumberAddActive+"]").addClass("ui-active");
}

// 주소 값 가져오기
function getAddressValue() {
	temp = location.href.split("?");
	data = temp[1].split(":");
	number = data[0];

	return number;
}

// 검색 폼 열기
function callSearchForm() {
	modal({
		type: 'prompt',
		title: '검색',
		text: '소모임명을 검색하십시오.',
		callback: function(result) {
			if (result == false) return;
			searchCellList(result);
		}
	});
}

// 검색 결과 리스트를 출력한다.
function searchCellList(result) {
	$.mobile.changePage( "#pageSearch", { transition: "flip", changeHash: true });
}
