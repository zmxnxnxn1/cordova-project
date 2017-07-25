// 소모임 매칭
function startSomoim() {
	if (matchingLoadingCheck == 0) { // 0 : 매칭 가능 , 1 : 매칭 중
		controlMatchingLoader(); // 매칭 로딩 시작
		matchingLoadingCheck = 1;
	}
}

// 매칭 로딩바를 컨트롤한다.
function controlMatchingLoader() {
	openMatchingLoaderBar();

	var waitTime = Math.floor(Math.random() * 3000) + 1;
	setTimeout("closeMatchingLoaderBar()", waitTime+2000);
}

// 매칭 로딩을 출력한다.
function openMatchingLoaderBar() {
	var $this = $(".matching-loader"),
	theme = $this.jqmData( "theme" ) || $.mobile.loader.prototype.options.theme,
	msgText = $this.jqmData( "msgtext" ) || $.mobile.loader.prototype.options.text,
	textVisible = $this.jqmData( "textvisible" ) || $.mobile.loader.prototype.options.textVisible,
	textonly = !!$this.jqmData( "textonly" );
	html = $this.jqmData( "html" ) || "";
	$.mobile.loading( "show", {
		text: msgText,
		textVisible: textVisible,
		theme: theme,
		textonly: textonly,
		html: html
	});
}

// 매칭 로딩 바를 닫고 모임을 찾는다.
function closeMatchingLoaderBar() {
	$.mobile.loading( "hide" );
	matchingSelect();
}

// 소모임 매칭 찾기
function matchingSelect() {

	var userKey = getLocal('userKey'); // 유저키

	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_matching_select.jsp",
		dataType:'JSON',
		data:{"userKey":userKey},
		success:function(data) {
			if (data["cellSeq"] == 0) {
				modal({
					type: 'error',
					title: '',
					text: "가입할 모임이 없습니다. 직접 모임을 만들어보세요!",
					callback: function(result) {
						cellUserList();
					}
				}); // End of modal
			} else {
				setLocal('cellNumber', data["cellSeq"]);
				matchingEnd();
			}

			matchingLoadingCheck = 0; // 매칭 완료
		}
	});
}

// 검색한 모임을 자동으로 가입시키고 이동시킨다.
function matchingEnd() {
	
	var userKey = getLocal('userKey'); // 유저키
	var cellSeq = getLocal('cellNumber'); // 모임번호
	
	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_userJoin.jsp",
		dataType:'JSON',
		data:{"userKey":userKey, "cellSeq":cellSeq},
		success:function(data) {
			moveCell(cellSeq); // 가입한 모임으로 이동
			clickCellTopMenu(1);

			modal({
				type: 'success',
				title: '완료',
				text: "매칭이 완료되어 소모임에 가입했습니다."
			}); // End of modal
		}
	});
}

// 소모임 검색기능을 시작한다.
function startSearch() {
	searchSomoim();
}

// 소모임 검색 SELECT
function searchSomoim() {

	var searchText = $("input[name=searchText]").val(); // 검색어

	$.ajax ({
		type:"GET",
		url:jspFileRoute + "packet_cell_search.jsp",
		dataType:'JSON',
		data:{"searchText":searchText},
		success:function(data) {

			var Html = "";

			if (data["result"].length == 0) { // 검색 결과가 없을 경우
				Html +='<div style="text-align:center">검색 결과가 없습니다.</div>';
			} else {
				Html +='<ul data-role="listview" data-inset="true">';
				for (key in data["result"]) {
					Html += '<li><a href="javascript:moveCell('+data["result"][key]["seq"]+')">'+data["result"][key]["cellName"]+'</a></li>';
				}
				Html += '</ul>';
			}
			
			$(".searchList").html(Html).trigger("create");
		}
	});
}