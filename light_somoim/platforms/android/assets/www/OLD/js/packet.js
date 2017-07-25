
// 기본 스크립트
(function () {
// initializes touch and scroll events
    var supportTouch = $.support.touch,
        scrollEvent = "touchmove scroll",
        touchStartEvent = supportTouch ? "touchstart" : "mousedown",
        touchStopEvent = supportTouch ? "touchend" : "mouseup",
        touchMoveEvent = supportTouch ? "touchmove" : "mousemove";
 
    // handles swipe up and swipe down
    $.event.special.swipeupdown = {
        setup: function () {
            var thisObject = this;
            var $this = $(thisObject);
 
            $this.bind(touchStartEvent, function (event) {
                var data = event.originalEvent.touches ?
                        event.originalEvent.touches[ 0 ] :
                        event,
                    start = {
                        time: (new Date).getTime(),
                        coords: [ data.pageX, data.pageY ],
                        origin: $(event.target)
                    },
                    stop;
 
                function moveHandler(event) {
                    if (!start) {
                        return;
                    }
 
                    var data = event.originalEvent.touches ?
                        event.originalEvent.touches[ 0 ] :
                        event;
                    stop = {
                        time: (new Date).getTime(),
                        coords: [ data.pageX, data.pageY ]
                    };
 
                    // prevent scrolling
                    if (Math.abs(start.coords[1] - stop.coords[1]) > 10) {
                        event.preventDefault();
                    }
                }
 
                $this
                    .bind(touchMoveEvent, moveHandler)
                    .one(touchStopEvent, function (event) {
                        $this.unbind(touchMoveEvent, moveHandler);
                        if (start && stop) {
                            if (stop.time - start.time < 1000 &&
                                Math.abs(start.coords[1] - stop.coords[1]) > 30 &&
                                Math.abs(start.coords[0] - stop.coords[0]) < 75) {
                                start.origin
                                    .trigger("swipeupdown")
                                    .trigger(start.coords[1] > stop.coords[1] ? "swipeup" : "swipedown");
                            }
                        }
                        start = stop = undefined;
                    });
            });
        }
    };

    //Adds the events to the jQuery events special collection
    $.each({
        swipedown: "swipeupdown",
        swipeup: "swipeupdown"
    }, function (event, sourceEvent) {
        $.event.special[event] = {
            setup: function () {
                $(this).bind(sourceEvent, $.noop);
            }
        };
    });
})();

//스크롤 시에 상단 투명하게
$(function(){
	$(window).scroll(function(){
		var sTop=$(this).scrollTop();
		if(sTop>365){
			$(".packet_header").css("opacity","1");
			$(".packet_header").css("border-bottom","solid 1px orange");
		} else {
			$(".packet_header").css("opacity","0.6");
			$(".packet_header").css("border-bottom","0px");
		}
	});
	
	$(".packet_cell_day").bind("tap, click",function(){
		location.href="packet_userList_view.html";	
	});
	
	$(document).on("pagechange", function(){   
	    $('#meetCreate').on("swipeleft", function( event ){ 
	    	
	    });
	    $('#meetCreate').on("swipeup", function( event ){ 
	    	history.back('-1');	
	    });
	});
});

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

$(document).ready(function() {
	defaultJspFileRoute(); // JSP 기본 경로 설정
});

//JSP 파일 기본 경로를 설정한다.
function defaultJspFileRoute() {
	jspFileRoute = "http://localhost:8080/JSON_OUTPUT/";
	//jspFileRoute = "http://doubleah.com:9000/examples/somoim/";
}

// 시작 세팅
function settingApplication() {
	loadRightMenu(); // 우측 메뉴
	loadBottomMenu(); // 하단 메뉴
}

// 우측 메뉴를 만든다.
function loadRightMenu() {
	var Html = "";
	Html  = '<div class="packet_menu packet_menu_header"> ';
	Html += '<a href="packet_userList_view.html" data-ajax="false"><span class="glyphicon glyphicon-user"></span></a>';
	Html += '<span class="glyphicon glyphicon-comment"></span>';
	Html += '<span class="glyphicon glyphicon-th-large"></span>';
	Html += '<span class="glyphicon glyphicon-cog"></span>';
	Html += '</div>';
	Html += '<div class="packet_menu"><a href="index.html" data-ajax="false"> 홈 </a></div>';
	Html += '<div class="packet_menu"><a href="javascript:movePage(\'packet_cell_list.html\')" data-ajax="false"> 소모임 </a></div>';
	Html += '<div class="packet_menu">내모임 </div>';
	Html += '<div class="packet_menu">----------------------------- </div>';
	Html += '<div class="packet_menu"><a href="javascript:logout()" data-ajax="false"> 로그아웃 </a></div>';
	Html += '<div class="packet_menu"><a href="javascript:checkKeyValue()"> 키값 확인 </a></div>';
	Html += '<div class="packet_menu"><a href="javascript:userKeyChange()"> 키값 조작 </a></div>';
	Html += '<div class="packet_menu"><a href="javascript:movePage(\'Z_packet_userList_view.html\')"> 유저 리스트 </a></div>';
	Html += '<div class="packet_menu"><a href="javascript:movePage(\'Z_packet_userProfile_view.html\')"> 프로필 뷰 </a></div>';
	
	$('#panel1').html(Html);
}

// 하단 메뉴를 만든다.
function loadBottomMenu() {
	var Html = "";
	Html += '<a style="color:#A6A6A6;" class="bottom-menu-1" href="javascript:moveHome()" data-ajax="false">';
	Html += '<span class="glyphicon glyphicon-home"></span></a>';
	Html += '<a style="color:#A6A6A6;" class="bottom-menu-2" href="javascript:moveCell()" data-ajax="false">';
	Html += '<span class="glyphicon glyphicon-plane"></span></a>';
	Html += '<a style="color:#A6A6A6;" class="bottom-menu-3" href="javascript:alert(\'준비중\')" data-ajax="false">';
	Html += '<span class="glyphicon glyphicon-user"></span></a>';
	Html += '<a style="color:#A6A6A6;" class="bottom-menu-4" href="javascript:moveAlarm()" data-ajax="false">';
	Html += '<span class="glyphicon glyphicon-flash"></span></a>';
	
	$('.packet_footer').html(Html);
}

// 페이지를 이동한다.
function movePage(page) {
	location.href = page;
}

// 모임 내부에서 페이지를 이동할 때 필요하다. // 모임seq 값도 로컬저장소로 할것을... 오류가ㅠㅠ
function moveCellBoardPage(page) {
	var cellSeq = location.hash.replace(/^#/, ''); // 모임 seq
	movePage(page+"#"+cellSeq);
}

// 룸 화면으로 이동
function moveHome() {
	location.href="packet_room_home.html";
}

// 소모임 화면으로 이동
function moveCell() {
	location.href="packet_cell_list.html";
}

// 알람 화면으로 이동
function moveAlarm() {
	location.href="packet_alarm_list.html";
}

// 로그아웃
function logout() {
	window.localStorage.removeItem("userKey");
	movePage("index.html");
}

// 로컬공간에서 유저의 키 가져오기
function getUserStorageKey() {
	var userKey = window.localStorage.getItem("userKey");
	return userKey;
}

// 유저키값을 확인한다. -admin
function checkKeyValue() {
	alert(window.localStorage.getItem("userKey"));
	console.log(window.localStorage.getItem("userKey"));
}

// 유저키값을 조작한다. -admin
function userKeyChange() {
	var keyValue = prompt('키값을 입력하세요.', '1');
	window.localStorage.setItem("userKey", keyValue);
}

// 유저키값을 설정한다.
function setUserKey(keyValue) {
	window.localStorage.setItem("userKey", keyValue);
}


// 모임 탑 메뉴를 클릭하면 페이지를 이동한다.
function changeCellTopMenuActive(type) {
	var cellSeq = location.hash.replace(/^#/, ''); // 모임 seq
	
	type == 1 ? movePage("packet_cell_home.html#"+cellSeq) : "";
	type == 2 ? movePage("packet_cell_boardList.html#"+cellSeq) : "";
	type == 3 ? "" : "";
}

// 게시글 SEQ를 확인한다.
function checkBoardSeq() {
	alert(window.localStorage.getItem("boardSeq"));
	console.log(window.localStorage.getItem("boardSeq"));
}

//게시글 SEQ를 수정한다.
function setBoardSeq(value) {
	window.localStorage.setItem("boardSeq", value);
}

//게시글 SEQ를 가져온다.
function getBoardSeq() {
	return window.localStorage.getItem("boardSeq");
}


