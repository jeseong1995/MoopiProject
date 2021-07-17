<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset='utf-8' />
<!-- Toolbar CDN -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
<script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>

<!-- 풀캘린더 -->
<link href='https://use.fontawesome.com/releases/v5.0.6/css/all.css' rel='stylesheet'>
<link href='/css/fullcalendar.min.css' rel='stylesheet' />
<link href='/css/fullcalendar.print.min.css' rel='stylesheet' media='print' />
<script src='/javascript/moment.min.js'></script>
<script src='/javascript/jquery.min.js'></script>
<script src='/javascript/fullcalendar.js'></script>
<script src='/javascript/theme-chooser.js'></script>
<script src='/javascript/locales-all.min.js'></script>
<script>
var mtNo ="";
var mtName="";
var mtContent="";
var userId="";
var mtStart="";
var mtEnd="";
var mtMaxCount="";
var mtAddr="";
var mtConstructor="";
var mmNo="";

function fncAddMtView() {
	alert("정모를 생성합니다.");
	var displayValue = "<h6>"
	+"<form class='form-horizontal' name='detailForm'>"
	+"<input type='hidden' name='mmNo' value='${mmNo}'>" 
	+"정모이름 :" +"<input type='text' name='mtName'>" + "<br>"
	+"정모내용 :"+"<input type='text' name='mtContent'>" + "<br>"
	+"주최자 :"+ "<input type='text' name='userId' value='${user.userId}'>" + "<br>"
	+"정모시작일 :" +"<input type='datetime-local'  name='mtStart'>"+"<br>"
	+"정모종료일 :" +"<input type='datetime-local' name='mtEnd'>"+"<br>"
	+"정모 총 인원 :"+ "<input type='text' name='mtMaxCount'>" + "<br>"
	+"<input type='hidden' name='mtCurrentCount' value='1'>" + "<br>"
	+"정모 장소 :"+"<input type='text' name='mtAddr'>" + "<br>"
	+"<a onClick='fncAddMt()'>등록하기</a>"+ "<br>"
	+"</form>"
	+"</h6>";
	$("#getDate").slideUp('slow');
	$("#addDate").html(displayValue);
	$("#addDate").fadeIn('slow');
}

function fncUptMtView() {
	alert("정모를 수정합니다.");
	if(mtConstructor == userId){
		var displayValue = "<h6>"
			+"<form class='form-horizontal' name='detailForm'>"
			+"<input type='hidden' name='mtNo' value=''>"
			+"<input type='hidden' name='mmNo' value=''>"
			+"정모이름 :" +"<input type='text' name='mtName' value=''>"+"<br>"
			+"정모내용 :"+"<input type='text' name='mtContent' value=''>"+"<br>"
			+"주최자 :"+ "<input type='text' name='userId' value=''>" + "<br>"
			+"정모시작일 :" +"<input type='datetime-local'  name='mtStart' value='' >"+"<br>"
			+"정모종료일 :" +"<input type='datetime-local' name='mtEnd' value='' >"+"<br>"
			+"정모 총 인원 :"+ "<input type='text' name='mtMaxCount' value=''>" + "<br>"
			//+"정모 현재 인원 :"+ "<input type='text' name=''>" + "<br>"
			+"정모 장소 :"+"<input type='text' name='mtAddr'>" + "<br>"
			+"<a onClick='fncUptMt()'>수정하기</a>"+ "<br>"
			+"</form>"
			+"</h6>";
			$("#getDate").slideUp('slow');
			$("#addDate").html(displayValue);
			$("#addDate").fadeIn('slow');
			$("input[name=mtNo]").val(mtNo);
			$("input[name=mmNo]").val(mmNo);
			$("input[name=mtName]").val(mtName);
			$("input[name=mtContent]").val(mtContent);
			$("input[name=userId]").val(mtConstructor);
			$("input[name=mtStart]").val(mtStart);
			$("input[name=mtEnd]").val(mtEnd);
			$("input[name=mtMaxCount]").val(mtMaxCount);
			$("input[name=mtAddr]").val(mtAddr);	
	}else{
		alert("정모 주최자 ID와 동일하지 않습니다.");
	}
	
	
}

function fncDeleteMt(userId) {
	if(mtConstructor == userId){
		self.location ="/meeting/deleteMeeting?mtNo="+mtNo
	}else{
		alert("정모 주최자 ID와 동일하지 않습니다.");
	}
	
	
	//$("form").attr("method", "POST").attr("action", "/meeting/addMeeting").submit();
}


function fncAddMt() {
	alert("등록완료");
	$("form").attr("method", "POST").attr("action", "/meeting/addMeeting").submit();
}

function fncUptMt() {
	alert("정모를수정합니다");
	$("form").attr("method", "POST").attr("action", "/meeting/updateMeeting").submit();
}

function fncApplyMt(mtNo, userId){
	alert("해당 정모에 참가하겠습니다.");
	$.ajax( 
			{
				url : "/meeting/json/applyMeeting/"+mtNo+"/"+userId,
				method : "GET" ,
				dataType : "json" ,
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				success : function(JSONData , status) {
					alert("정모참여완료");
					$("#mtCurrentCount").val(JSONData.mtCurrentCount);
				}
		}); //ajax 종료
}//fncApplyMt 종료


function fncLeaveMt(mtNo, userId){
	alert("해당 정모에 참가를 취소하겠습니다. 한번 취소하시면 다시 참여하실수 없습니다. ");
	$.ajax( 
			{
				url : "/meeting/json/leaveMeeting/"+mtNo+"/"+userId,
				method : "GET" ,
				dataType : "json" ,
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				success : function(JSONData , status) {
					alert("정모참여 취소완료");
					$("#mtCurrentCount").val(JSONData.mtCurrentCount);
				}
		}); //ajax 종료
}//fncLeavMt 종료


function fncGetMEFL(mtNo){
	alert(mtNo);
	$.ajax( 
			{
				url : "/meeting/json/listMEFL/"+mtNo,
				method : "GET" ,
				dataType : "json" ,
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				success : function(JSONData , status) {
					alert(JSONData.list.length);
					$( "h5" ).remove();	
					let displayValue = '';
					for(var i=0;i < JSONData.list.length;i++){
					displayValue += "<h5>"
										+"유저ID	: "+JSONData.list[i].meflId.userId+"<br/>"
										+"이름  : "+JSONData.list[i].meflId.userName+"<br/>"
										+"나이  : "+JSONData.list[i].meflId.age+"<br/>"
										+"성별  : "+JSONData.list[i].meflId.gender+"<br/>"
										+"FullAddr  : "+JSONData.list[i].meflId.fullAddr+"<br/>"
										+"addr  : "+JSONData.list[i].meflId.addr+"<br/>"
										+"닉네임 		: "+JSONData.list[i].meflId.nickname+"<br/>"
										+"주소 		: "+JSONData.list[i].meflId.addr+"<br/>"
										+"프로필이미지 : "+JSONData.list[i].meflId.profileImage+"<br/>"
										+"자기소개 : "+JSONData.list[i].meflId.profileContent+"<br/>"
										+"뱃지   	   : "+JSONData.list[i].meflId.badge+"<br/>"
										+"MEFL넘버  : "+JSONData.list[i].meflNo+"<br/>"
										+"MEFL타입  : "+JSONData.list[i].meflType+"<br/>"
										+"타겟넘버   : "+JSONData.list[i].targetNo+"<br/>"
										+"참여일자   : "+JSONData.list[i].joinRegDate+"<br/>"
										+"</h5>";
							
						
						} //for문끝
						$( "#getMEFL" ).append(displayValue);
				}
		}); //ajax 종료
	
}


$(document).ready(function() {

    initThemeChooser({

      init: function(themeSystem) {
        $('#calendar').fullCalendar({
          themeSystem: themeSystem,
          googleCalendarApiKey: 'AIzaSyAow_exiK7v12TdQlYOv1U-ttFlSpWlU2Q',
          aspectRatio: 2,
          height:700,
          contentHeight:700,
          header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay,listMonth'
          },
          weekNumbers: true,
          //navLinks: true, // can click day/week names to navigate views
          editable: true,
          selectable: true,
          selectMirror: true,
          dateClick: function(info) {
        	  alert("정모를 생성합니다.")
          },
          eventClick: function(event) {
        	mmNo = event.no;
        	mtNo = event.id;
        	mtName = event.title;
        	mtStart = event.start;
        	mtEnd = event.end;
        	mtContent = event.description;
        	mtMaxCount = event.maxCount;
        	mtConstructor = event.constructor;
        	mtAddr = event.addr;
      	    //alert(mtNo);
      	    console.log(mtConstructor);
      	   	//userId = ${user.userId};
      	  $.ajax( 
    				{
    					url : "/meeting/json/getMeeting/"+mtNo,
    					method : "GET" ,
    					dataType : "json" ,
    					headers : {
    						"Accept" : "application/json",
    						"Content-Type" : "application/json"
    					},
    					success : function(JSONData , status) {
    						//alert(status);
    						//alert("JSONData : \n"+JSONData);
    						$( "h5" ).remove();	
    						$("#addDate").slideUp('slow');
    						$("#mtName").val(JSONData.mtName);
    						$("#userId").val(JSONData.mtConstructor.userId);
    						$("#mtContent").val(JSONData.mtContent);
    						$("#mtStart").val(JSONData.mtStart);
    						$("#mtEnd").val(JSONData.mtEnd);
    						$("#mtMaxCount").val(JSONData.mtMaxCount);
    						$("#mtCurrentCount").val(JSONData.mtCurrentCount);
    						$("#mtAddr").val(JSONData.mtAddr);
    						$("#getDate").slideDown('slow');
    					}
    			}); //ajax 종료
      	  },
          eventLimit: true, // allow "more" link when too many events
          events: [
        	  <c:forEach items="${list}" var="meeting">
              {
            	no:"${meeting.mmNo}",
            	id: "${meeting.mtNo}",
                title: "${meeting.mtName}",
                start: "${meeting.mtStart}",
                end: "${meeting.mtEnd}",
                description: "${meeting.mtContent}",
                maxCount : "${meeting.mtMaxCount}",
                currentCount : "${meeting.mtCurrentCount}",
                constructor : "${meeting.mtConstructor.userId}",
                addr: "${meeting.mtAddr}"
                
              },
              </c:forEach>
          ],
          timeFormat: 'h(:mm)a'
        });
      },
      editable: true,
      change: function(themeSystem) {
        $('#calendar').fullCalendar('option', 'themeSystem', themeSystem);
      }

    });

  });

</script>
<style>

  body {
    margin: 0;
    padding: 0;
    font-size: 14px;
    padding-top: 50px;
  }

  #top,
  #calendar.fc-unthemed {
    font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
  }

  #top {
    background: #eee;
    border-bottom: 1px solid #ddd;
    padding: 0 10px;
    line-height: 40px;
    font-size: 12px;
    color: #000;
  }

  #top .selector {
    display: inline-block;
    margin-right: 10px;
  }

  #top select {
    font: inherit; /* mock what Boostrap does, don't compete  */
  }

  .left { float: left }
  .right { float: right }
  .clear { clear: both }

  #calendar {
    max-width: 1000px;
    margin: 40px auto;
    padding: 0 10px;
    float: left;
  }
  
  #getDate {
  	float: left;
  	width: 500px;
  }

</style>
</head>
<body>

<!-- ToolBar Start ///////////////////////////////////// -->
<jsp:include page="../layout/toolbar.jsp" />
<jsp:include page="../layout/moimToolbar.jsp"/>
<!-- ToolBar End /////////////////////////////////////-->

<h3>정모일정 확인 캘린다입니다...${user.userId}님 안녕하십니까..
<button type="button" class="btn btn-success" onClick="fncAddMtView()">정모 생성하기</button>
</h3>
  <div id='top'>

    <div class='left'>

      <div id='theme-system-selector' class='selector'>
        Theme System:

        <select>
          <option value='jquery-ui'>테마 변경 하기</option>
        </select>
      </div>

      <div data-theme-system="jquery-ui" class='selector' style='display:none'>
        Theme Name:

        <select>
          <option value='black-tie'>Black Tie</option>
          <option value='blitzer'>Blitzer</option>
          <option value='cupertino' selected>Cupertino</option>
          <option value='dark-hive'>Dark Hive</option>
          <option value='dot-luv'>Dot Luv</option>
          <option value='eggplant'>Eggplant</option>
          <option value='excite-bike'>Excite Bike</option>
          <option value='flick'>Flick</option>
          <option value='hot-sneaks'>Hot Sneaks</option>
          <option value='humanity'>Humanity</option>
          <option value='le-frog'>Le Frog</option>
          <option value='mint-choc'>Mint Choc</option>
          <option value='overcast'>Overcast</option>
          <option value='pepper-grinder'>Pepper Grinder</option>
          <option value='redmond'>Redmond</option>
          <option value='smoothness'>Smoothness</option>
          <option value='south-street'>South Street</option>
          <option value='start'>Start</option>
          <option value='sunny'>Sunny</option>
          <option value='swanky-purse'>Swanky Purse</option>
          <option value='trontastic'>Trontastic</option>
          <option value='ui-darkness'>UI Darkness</option>
          <option value='ui-lightness'>UI Lightness</option>
          <option value='vader'>Vader</option>
        </select>
      </div>

      <span id='loading' style='display:none'>잠시 기다려 주세요...</span>

    </div>


    <div class='clear'></div>
  </div>

  <div id='calendar'></div>
  
  <div id="addDate">
  </div>
  
  <div id="getDate">
	<!--  상세정보 div Start /////////////////////////////////////-->
	<div class="container">
	정모이름 : <input type='text' id='mtName'><br>
	정모내용 :<input type='text' id='mtContent'><br>
	주최자 : <input type='text' id='userId'><br>
	정모시작일 :<input type='text'  id='mtStart'><br>
	정모종료일 :<input type='text' id='mtEnd'><br>
	정모 총 인원 :<input type='text' id='mtMaxCount'><br>
	정모 현재 인원 :<input type='text' id='mtCurrentCount'>
	<button type="button" class="btn btn-default" onClick="fncGetMEFL(mtNo)">참여한사람보기</button>
	<br>
	정모 장소 :<input type='text' id='mtAddr'><br>
	
	
	<button type="button" class="btn btn-success" onClick="fncApplyMt(mtNo, '${user.userId}')">참가</button>
	<button type="button" class="btn btn-success" onClick="fncLeaveMt(mtNo, '${user.userId}')">참가취소</button>
	<button type="button" class="btn btn-primary" onClick="fncUptMtView('${user.userId}')">수정</button>
	<button type="button" class="btn btn-danger" onClick="fncDeleteMt('${user.userId}')">삭제</button>	
	<a href="https://accounts.google.com/o/oauth2/v2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcalendar%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcalendar.readonly&access_type=offline&include_granted_scopes=true&response_type=code&state=state_parameter_passthrough_value&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Fmeeting%2FreceiveCode&client_id=674136097926-gmjcrr1v85j17s88t3pi2fodfp72hvk9.apps.googleusercontent.com" >★</a>

		
 	</div> <!-- 컨테이너 div종료 --> 
		<div id="getMEFL" style="padding-top: 30px"></div>
 </div> <!-- getDate div 종료 -->
<jsp:include page="../layout/searchbar.jsp"></jsp:include>

</body>
</html>
