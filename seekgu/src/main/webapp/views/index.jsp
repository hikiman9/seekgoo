<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>
    <title>Shop Homepage - Start Bootstrap Template</title>
    <!-- Favicon-->
    <link rel="icon" type="image/x-icon" href="<c:url value="/assets/favicon.png"/>"/>
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="<c:url value="/css/styles.css"/>" rel="stylesheet"/>
    <!-- Bootstrap core JS-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        let index = {
            init: function(){
                let boardtype = $('#boardtype').val();
                let spans = document.querySelectorAll('.menus .menu');
                spans.forEach(span =>{
                    span.style.color = 'gray';
                })
                spans[boardtype - 1].style.color = 'black';
                spans[boardtype - 1].style.textDecoration = 'underline';
            },
        };

        $(function(){
           index.init();
        });
    </script>
</head>
<body>
<!-- Navigation-->
<nav class="navbar navbar-expand-lg navbar-light bg-light p-0">
    <div class="container px-4 px-lg-5">
        <a class="navbar-brand" href="<c:url value="/seekgu"/> ">
            <img src="<c:url value="/assets/logo_black.png"/>" alt="로고 이미지">
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span
                class="navbar-toggler-icon"></span></button>
        <c:choose>
            <c:when test="${sessionScope.memberId == null}">
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-3 mb-2 mb-lg-0 ms-lg-auto">
                        <li class="nav-item fs-12"><a class="nav-link active" href="<c:url value="/member/login"/>">Login</a></li>
                        <li class="nav-item fs-12"><a class="nav-link active" href="<c:url value="/member/signup"/>">Sign Up</a></li>
                    </ul>
                </div>
            </c:when>
            <c:otherwise>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-3 mb-2 mb-lg-0 ms-lg-auto">
                        <li class="nav-item fs-12"><a class="nav-link active" href="#">${sessionScope.memberNickName}</a></li>
                        <li class="nav-item fs-12"><a class="nav-link active" href="<c:url value="/member/logout"/>">Logout</a></li>
                    </ul>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</nav>
<!-- Header-->
<header class=" main-banner">
    <div class="container px-4 px-lg-5">
        <div class="text-center text-white">
            <img src="<c:url value = "/assets/logo_white.png"/>" style="width: 200px;">
            <p class="lead fw-normal text-white mb-0 fw-bolder"></p>
        </div>
    </div>
</header>
<input id="boardtype" type="hidden" value="${boardType}">
<div class="text-center mt-5 fs-4 menus">
    <span class="p-3 menu fw-bolder fs-14" onclick="location.href = '<c:url value="/seekgu"/>'">모집중</span>
    <span class="p-3 menu fw-bolder fs-14" onclick="location.href = '<c:url value="/seekgu/done"/>'">식구들</span>
    <c:choose>
        <c:when test="${sessionScope.memberId == null}">
            <span class="p-3 menu fw-bolder fs-14" onclick="location.href = '<c:url value="/seekgu"/>'; alert('로그인 후 사용해주세요')">나의 식구</span>
        </c:when>
        <c:otherwise>
            <span class="p-3 menu fw-bolder fs-14" onclick="location.href = '<c:url value="/seekgu/my?memberIdx="/>${sessionScope.memberId}'">나의 식구</span>
        </c:otherwise>
    </c:choose>
</div>
<c:choose>
    <c:when test="${sessionScope.memberId == null}">
        <button id="write-button"><a onclick="alert('로그인 후 이용해주세요')">모집하기</a></button>
    </c:when>
    <c:otherwise>
        <button id="write-button"><a href="<c:url value="/seekgu/write"/>">모집하기</a></button>
    </c:otherwise>
</c:choose>
<!-- Section-->
<section class="py-3">
    <div class="container px-4 px-lg-5 mt-5">
        <div class="row gx-4 gx-lg-5  row-cols-md-3 justify-content-center">
            <!--  모집 미리보기 글 들어가는 위치  -->
            <c:choose>
                <c:when test="${not empty seekguList}">
                    <c:forEach var="seekgu" items="${seekguList}">
                        <div class="col mb-5">
                            <div class="card h-100">
                                <!-- Sale badge-->
                                <c:choose>
                                    <c:when test="${seekgu.isRecruiting}">
                                        <div class="badge bg-success text-white position-absolute"
                                             style="top: 0.5rem; right: 0.5rem">
                                            모집중
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="badge bg-danger text-white position-absolute"
                                             style="top: 0.5rem; right: 0.5rem">
                                            모집완료
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="card-body p-4">
                                    <div class="text-center">
                                        <!-- 모집 글 제목-->
                                        <h5 class="fw-bolder">${seekgu.boardTitle}️</h5>
                                        <!-- Product reviews-->
                                        <div class="d-flex justify-content-center small text-warning mb-2">
                                                ${seekgu.boardRestaurantName} (${seekgu.boardMealTime})
                                        </div>
                                        <!-- 현재 모집인원 / 최대 모집 인원-->
                                        <span class="text-muted p-3">참여인원 ${seekgu.boardMemberCount} / ${seekgu.boardMax}</span><br>

                                        <c:choose>
                                            <c:when test="${seekgu.isRecruiting}">
                                                <span id="timer${seekgu.boardIdx}" class="badge timer-background text-center fs-6 p-3 mt-2">
                                                </span>
                                                <script>
                                                    function writeTime${seekgu.boardIdx}(){
                                                        let timerElement = document.getElementById('timer${seekgu.boardIdx}');
                                                        timerElement.textContent = makeTime${seekgu.boardIdx}();
                                                    }

                                                    function makeTime${seekgu.boardIdx}(){
                                                        let currentTime = new Date().getTime()/1000;
                                                        let regTime = new Date('${seekgu.boardStartTime}').getTime()/1000;
                                                        let limitTime = ${seekgu.boardLimitTime} * 60;
                                                        let leftTime = parseInt(regTime + limitTime - currentTime);

                                                        let minutes = Math.floor(leftTime / 60);
                                                        let seconds = leftTime % 60;

                                                        if (minutes < 0 && seconds < 0){
                                                            return '모집 마감';
                                                        } else if (minutes < 10 && seconds < 10){
                                                            return 'TIMER : 0' + minutes + " : 0" + seconds;
                                                        } else if (minutes < 10){
                                                            return 'TIMER : 0' + minutes + " : " + seconds;
                                                        } else if (seconds < 10){
                                                            return 'TIMER : ' + minutes + " : 0" + seconds;
                                                        }
                                                        return 'TIMER : ' + minutes + " : " + seconds;
                                                    }

                                                    writeTime${seekgu.boardIdx}();
                                                    var interval${seekgu.boardIdx} = setInterval(writeTime${seekgu.boardIdx}, 1000);

                                                </script>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge timer-background text-center fs-6 p-3 mt-2">
                                                    모집 마감
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <!-- 모집 글 상세보기-->
                                <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                    <div class="text-center"><a class="btn btn-outline-dark mt-auto" href="<c:url value="/seekgu/detail?seekguIdx="/>${seekgu.boardIdx} ">모집
                                        상세보기</a></div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center">
                        <div>
                            <img src="<c:url value = "/assets/empty.jpg"/>" style="width: 200px;">
                            <h3>텅...</h3>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</section>
<!-- Footer-->
<footer class="py-5 bg-dark">
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>

</body>
</html>
