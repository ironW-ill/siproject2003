<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>국회를 생각하는 사람들 &#124; 민주당</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="민주당">
<meta name="description" content="국회를 생각하는 사람들">

<link rel="stylesheet" href="resources/common/css/Thethinkers.css">
<script src="resources/common/js/libs/browser.min.js"></script>
<script src="resources/common/js/libs/jquery.min.js"></script>
<script src="resources/common/js/libs/plugins.js"></script>
<script src="resources/common/js/pub/pub_ui.js"></script>
<script src="resources/common/js/pub/pub_grid.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js"></script>
<!--  See http://de.cdnjs.com/libraries/jqgrid -->
<link href="http://cdnjs.cloudflare.com/ajax/libs/jqgrid/4.6.0/css/ui.jqgrid.css" type="text/css" rel="stylesheet" media="screen"/>
<script src ="http://cdnjs.cloudflare.com/ajax/libs/jqgrid/4.6.0/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script type="text/javascript">


////////////////////////////////////////////////////////////////////////////
///////////////////////////////Jqgrid///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

var jsonlist = JSON.parse('${paramList}');
	
$(function (){
	$("#grid").jqGrid({
		datatype: "local",
		data: jsonlist,
		mtype: 'POST',
		colNames: ["이름", "평가", "정당", "선거구",  "당선횟수" , "위원회"],
		colModel: [
			{ name:"name" , index:"name", width:90, align : "center", frozen : true},
			{ name:"evaluation" , width:100, align : "left"},
			{ name:"party" , width:150, align : "left" },
			{ name:"election" , width:200, align : "left" },
			{ name:"electioncnt" , width:100, align : "center" },
			{ name:"committee" , width:700, align : "left" },
		],
		autowidth: true,
		height: 550,
		rowNum: jsonlist.length,
		rowList: [10,20,30],
		viewrecords: true,
		sortorder: "desc",
		shrinkToFit: false,
		
	
		//특정 하나의 cell을 눌르면 동작하는 function
		onCellSelect: function(rowid,icol,cellcontent,e){	
				
			//한국어만 가져오게
        	var law_name = cellcontent.replace(/[^\uAC00-\uD7AF\u1100-\u11FF\u3130-\u318F]/gi,"");
				
        	if(icol==0){ // 0번째 열 == 의원이름
        		//committeedetail Controller로 이동
				return window.location.href = "/assembly/committeedetail/" + law_name;
        	}
		}
	});
	jQuery("#grid").jqGrid('setFrozenColumns');	
});

////////////////////////////////////////////////////////////////////////////
////////////////////////////////Ajax////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

var ajax = new XMLHttpRequest();


// [Ajax_1] - 정당(party), 지역구(district),
// 			  소속의원회(committee), 의원이름(keyword) 검색

// onkeyup()과 onchange()를 사용하여 키보드가 눌리거나 체크박스가 선택할 때마다 동작하도록 설정
//
function searchFunction() {
	var keyword = document.getElementById('keyword');
	var district = document.getElementById('district');
	var committee = document.getElementById('committee');
	var party = document.getElementById('party');
	
    ajax.onreadystatechange = callbackajaxjson;
    ajax.open("GET", "/assembly/searchLawmaker?keyword="+ encodeURIComponent(keyword.value)
    		+"&district="+encodeURIComponent(district.value) 
    		+"&committee="+encodeURIComponent(committee.value)
    		+"&party="+encodeURIComponent(party.value));
    ajax.setRequestHeader("Accept", "application/json");
    ajax.send();
}

//[Ajax_1(callback)] - 정당(party), 지역구(district),
//					   소속의원회(committee), 의원이름(keyword) 검색
function callbackajaxjson() {
    if (ajax.readyState == 4) {

        arr = JSON.parse(ajax.responseText);
        
        jQuery("#grid").setGridParam(arr).trigger("reloadGrid");
        
    	jQuery("#grid").jqGrid("clearGridData", true);	

    	//검색호출 완료 후 리로드
    	$("#grid").jqGrid('setGridParam', {
    		datatype: "local",
    		data: arr,
    		mtype: 'POST',
    	}).trigger('reloadGrid');
        
    }
}




// [Ajax_4] - 로그인한 유저가 어떤의원을 좋아요
function likelawmaker(lawmakername){
	
	var name = lawmakername;
	
    ajax.onreadystatechange = likecallbackajaxjson;
    ajax.open("GET", "/assembly/likeAjax?name="+ encodeURIComponent(name),true);
    ajax.setRequestHeader("Accept", "application/json");
    ajax.send();
    
}
// [Ajax_4(callback)] - 로그인한 유저가 어떤의원을 좋아요
function likecallbackajaxjson() {
    if (ajax.readyState == 4) {
        alert("좋아요!!")
       	window.location.reload();
    }
}


// [Ajax_5] - 로그인한 유저가 어떤의원을 싫어요
function hatelawmaker(lawmakername){
	var name = lawmakername;
	
    ajax.onreadystatechange = hatecallbackajaxjson;
    ajax.open("GET", "/assembly/hateAjax?name="+ encodeURIComponent(name),true);
    ajax.setRequestHeader("Accept", "application/json");
    ajax.send();
}
// [Ajax_5(callback)] - 로그인한 유저가 어떤의원을 싫어요
function hatecallbackajaxjson() {
    if (ajax.readyState == 4) {
        alert("싫어요!!")
        window.location.reload();
    }
}




// [Ajax_6] - 로그인한 유저가 어떤의원이 좋아졌어요
function modifylikelawmaker(lawmakername){
	var name = lawmakername;
	ajax.onreadystatechange = modifylikecallbackajaxjson;
    ajax.open("GET", "/assembly/modifyLikeAjax?name="+ encodeURIComponent(name),true);
    ajax.setRequestHeader("Accept", "application/json");
    ajax.send();
}
// [Ajax_6(callback)] - 로그인한 유저가 어떤의원이 좋아졌어요
function modifylikecallbackajaxjson(){
	if (ajax.readyState == 4) {
        alert("좋아졌어요!!")
        window.location.reload();
    }
}


// [Ajax_7] - 로그인한 유저가 어떤의원이 싫어졌어요
function modifyhatelawmaker(lawmakername){
	var name = lawmakername;
	ajax.onreadystatechange = modifyhatecallbackajaxjson;
    ajax.open("GET", "/assembly/modifyHateAjax?name="+ encodeURIComponent(name),true);
    ajax.setRequestHeader("Accept", "application/json");
    ajax.send();
}
// [Ajax_7(callback)] - 로그인한 유저가 어떤의원이 싫어졌어요
function modifyhatecallbackajaxjson(){
	if (ajax.readyState == 4) {
        alert("싫어졌어요!!")
       	window.location.reload();
    }
}
</script>


<!-- dropdown css style -->
<style>
         .dropdown {
             position: relative;
             display: inline-block;
         }
         .dropdown-content {
             display: none;
             position: static;

             margin-bottom: auto;
         }
         .dropdown:hover .dropdown-content { display: block; }
</style>

</head>
<body>
<div class="wrapper">

    <!-- s: header -->
    <header class="header in-sec">
        <div class="header-group">
            <div class="left-area">
                
            </div>
            <h1 class="header-tit">의원현황</h1>
            <div class="right-area">
               
            </div>
        </div>
        <!-- s: tab -->
        <div class="tab swiper-container">
			<ul class="tab-nav swiper-wrapper">
                <li class="swiper-slide is-selected"><a href="javascript:;" data-role="tab">기초정보</a></li>
                <li class="swiper-slide"><a href="javascript:;" class="badge" data-role="tab">평가</a></li>
                <li class="swiper-slide"><a href="javascript:;" data-role="tab">의정활동</a></li>
                <li class="swiper-slide"><a href="javascript:;" data-role="tab">재산변동</a></li>
                <li class="swiper-slide"><a href="javascript:;" data-role="tab">후원</a></li>
            </ul>
        </div>
        <!-- e: tab -->
    </header>
	<!-- e: header -->


	<!-- s: container -->
	<div class="container">
		<!-- s: content -->
		<div id="content" class="content header-expand bg-gray"> <!-- 헤더에 탭 있는 경우 header-expand, 배경 있는경우 bg-gray -->
			<div class="in-sec">
				<!-- s: search control -->
                <div class="search-control" id="search" style="display:none">
					<div class="grid">
						<div class="col col-3">
							<div class="select-area">
								<select name="" id="party" onchange="searchFunction()" class="form-select">
									<option value="">정당</option>
									<option value="더불어민주당">더불어민주당</option>
									<option value="미래통합당">미래통합당</option>
									<option value="미래한국당">미래한국당</option>
									<option value="민생당">민생당</option>
									<option value="민중당">민중당</option>
									<option value="우리공화당">우리공화당</option>
									<option value="정의당">정의당</option>
								</select>
							</div>
						</div>
						<div class="col col-9">
							<div class="select-area">
                       			 	<input type="text" name="district" id="district" onkeyup="searchFunction()" placeholder="지역구">
							</div>
						</div>
					</div>
					<div class="select-area">
                        <input type="text" name="committee" id="committee" onkeyup="searchFunction()" placeholder="소속위원회">
					</div>
                    <div class="form-area">
                        <input type="text" name="keyword" id="keyword" onkeyup="searchFunction()" placeholder="의원 이름">
                    </div>
                </div>
				<!-- e: search control -->

				<!-- s: section container -->
                <section class="section-container">
					<!-- s: grid -->
					<div class="grid-area">
						<p class="cate">전체 의원</p>
	
						<table id="grid"></table>
					</div>

				</section>
				<!-- e: section container -->
			</div>
		</div>
		<!-- s: content -->
	</div>
	<!-- s: container -->
</div>

</body>
</html>