<%-- 
    Document   : game
    Created on : Mar 18, 2016, 11:29:00 PM
    Author     : Chong
--%>

<%@page import="edu.pitt.is1017.spaceinvaders.ScoreTracker"%>
<%@page import="edu.pitt.is1017.spaceinvaders.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alien Invasion - Game</title>
        <script src="assets/js/jquery-2.2.2.min.js"></script>
        <script src="assets/js/jquery.cookie.js"></script>
        <link rel="stylesheet" href="assets/css/style.css" type="text/css" />
        <%
            String userID = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("userID")) {
                        userID = cookie.getValue() + "";
                        int userIDInt = Integer.parseInt(userID);
                        User newUser = new User(userIDInt);
                        ScoreTracker sTracker = new ScoreTracker(newUser);
                        String gameID = sTracker.getGameID();
                        Cookie gameIDCookie = new Cookie("gameID", gameID);
                        response.addCookie(gameIDCookie);
                    }
                }
            }
            if (userID == null) {
                response.sendRedirect("index.jsp");
            }
        %>
        <script>
            var userID;
            var gameID;

            var docWidth;
            var docHeight;
            var TOP_MARGIN = 10;
            var LEFT_MARGIN = 10;

            var SHOT_WIDTH = 12;
            var SHOT_HEIGHT = 23;

            var TBLWIDTH;
            var TBLHEIGHT;

            var direction = 1;

            var bulletIdSeed = 1;

            $tblAliens = null;
            $ship = null;

            var alienList = [];
            var intervalAllAliens = null;
            var intervalBullet = null;
            var intervalCollision = null;

            var bulletClip = [];

            var alienDestroyed = 0;
            var message = "";

            $(document).ready(function () {
                userID = $.cookie("userID");
                gameID = $.cookie("gameID");

                $tblAliens = $('#tblAliens');
                docWidth = $(document).width();
                docHeight = $(document).height();
                /* for (var i = 0; i < alienList.length; i++){
                 console.log(alienList[i].position());
                 } */

                $ship = $('#ship');

                docWidth = $(document).width();
                docHeight = $(document).height();

                $(window).resize(function () {
                    docWidth = $(document).width();
                    docHeight = $(document).height();
                    initElements();
                });

                $(document).keydown(function (evt) {
                    evt.preventDefault();
                    // console.log(evt.keyCode);
                    if (evt.keyCode == 37) {
                        var pos = $ship.position();
                        if ((pos.left - 10) >= LEFT_MARGIN) {
                            $ship.css('left', (pos.left - 10) + "px");
                        }
                    }
                    if (evt.keyCode == 39) {
                        var pos = $ship.position();
                        if ((pos.left + 10) <= (docWidth - LEFT_MARGIN - $ship.width())) {
                            $ship.css('left', (pos.left + 10) + "px");
                        }
                    }
                    if (evt.keyCode == 32) {
                        // console.log("fire bullet");
                        createBullet();
                    }
                });

                initElements();
                intervalAllAliens = setInterval(moveAllAliens, 300);

                // intervalBullet = setInterval(moveBullet, 100);

                // intervalCollision = setInterval(detectCollision, 100);

            });

            $(window).on('beforeunload', function () {
                saveScore(userID, gameID, 0);
            });

            function saveScore(userID, gameID, score) {
                var url = "ws/ws_savescore";
                var coods = {
                    "userID": userID,
                    "gameID": gameID,
                    "score": score
                }
                $.post(url, coods, function (save) {

                })
            }

            function detectCollision(bullet) {
                //for (var i = 0; i < bulletClip.length; i++) {
                // if (bulletClip[i] !== null) {
                $bullet = $('#' + bullet.bulletID);
                var bulletCoor = {
                    left: $bullet.position().left,
                    right: $bullet.position().left + $bullet.width(),
                    top: $bullet.position().top,
                    bottom: $bullet.position().top + $bullet.height()
                };
                for (var j = 0; j < alienList.length; j++) {
                    if (alienList[j] !== null) {
                        $alien = alienList[j];
                        var alienCoor = {
                            left: $alien.position().left + $tblAliens.position().left,
                            right: $alien.position().left + $alien.width() + $tblAliens.position().left,
                            top: $alien.position().top + $tblAliens.position().top,
                            bottom: $alien.position().top + $alien.height() + $tblAliens.position().top
                        };
                        // console.log(bulletCoor, alienCoor);
                        if (intersectRect(alienCoor, bulletCoor)) {
                            // console.log("Clide");
                            removeBullet(bullet);
                            removeAlien(j);
                            saveScore(userID, gameID, 1);
                            alienDestroyed++;
                            if (alienDestroyed === 60)
                                playerWin();
                        }
                    }
                }
                // }
                // }
            }

            function playerWin() {
                saveScore(userID, gameID, 0);
                leaderBoard("You win!\n");
            }

            function playerLose() {
                saveScore(userID, gameID, 0);
                leaderBoard("You lose!\n");
            }

            function leaderBoard(headerMessage) {
                var message = "";
                $.getJSON('ws/ws_readscores', function (data) {
                    for (var i = 0; i < data.leaders.length; i++) {
                        message += "" + data.leaders[i].lastName + " "
                                + data.leaders[i].firstName + " "
                                + data.leaders[i].highestScore + "\n";
                    }

                    if (!alert(headerMessage + message)) {
                        window.location.reload();
                    }

                });
            }

            function removeBullet(bullet) {
                $shot = $('#' + bullet.bulletID);
                // console.log($shot);
                // $shot.css('display', 'none');
                clearInterval(bullet.intervalID);
                $shot.remove();
                bulletClip.shift();                
                // bulletClip[i] = null;
            }

            function removeAlien(j) {
                $alien = alienList[j];
                // $alien.remove();
                // alienList.shift();                
                $alien.css('display', 'none');
                alienList[j] = null;
            }

            // code from http://stackoverflow.com/questions/2752349/fast-rectangle-to-rectangle-intersection
            function intersectRect(r1, r2) {
                return !((r2.left > r1.right) ||
                        (r2.right < r1.left) ||
                        (r2.top > r1.bottom) ||
                        (r2.bottom < r1.top));
            }

            function createBullet() {
                $shot = $('<img>');
                $shot.attr("src", "assets/images/shot.gif");
                $shot.attr("id", bulletIdSeed);

                $shot.css({
                    "position": "absolute",
                    "left": ($ship.position().left + ($ship.width() / 2) - (SHOT_WIDTH / 2)) + "px",
                    "top": ($ship.position().top - SHOT_HEIGHT) + "px"
                });
                // console.log($shot.width());
                $('body').append($shot);

                var bullet = {
                    "bulletID": bulletIdSeed,
                    "intervalID": 0,
                    "bulletObj": $shot
                }

                bulletIdSeed++;

                bulletClip.push($shot);

                bullet.intervalID = setInterval(moveBullet, 100, bullet);
            }

            function moveBullet(bullet) {
                $firedBullet = $('#' + bullet.bulletID);

                var posY = $firedBullet.position().top;

                var newPosY = posY - 10;

                if (newPosY > 5) {
                    $firedBullet.css("top", newPosY + "px");
                    detectCollision(bullet);

                } else {
                    saveScore(userID, gameID, -1);
                    clearInterval(bullet.intervalID);
                    $firedBullet.remove();
                    bulletClip.shift();
                }

                /* for (var i = 0; i < bulletClip.length; i++) {
                 $bullet = bulletClip[i];
                 if ($bullet !== null) {
                 $bullet.css("top", ($bullet.position().top - 10) + "px");
                 if ($bullet.position().top < 0) {
                 removeBullet(i);
                 saveScore(userID, gameID, -1);
                 }
                 // console.log($bullet);
                 }
                 // console.log("Fire");
                 } **/

                // clearInterval(intervalBullet);
                // intervalBullet = setInterval(moveBullet, bulletClip.length * 100);
            }

            function initElements() {
                drawAllAliens();
                $ship = $('#ship');

                $ship.css("top", (docHeight - $ship.height() - TOP_MARGIN) + "px");
                $ship.css("left", (docWidth / 2 - $ship.width() / 2) + "px");
            }

            function drawAllAliens() {
                // console.log($tblAliens);
                for (var i = 0; i < 5; i++) {
                    $tr = $('<tr></tr>');
                    for (var j = 0; j < 12; j++) {
                        $td = $('<td></td>');
                        $alien = $('<img>');
                        $alien.attr('src', 'assets/images/alien.gif');
                        // $alien.attr('id', 'alien_'+((i+1)*(j+1)));
                        alienList.push($alien);
                        $td.append($alien);
                        $tr.append($td);
                    }
                    // console.log($tr);
                    $tblAliens.append($tr);
                }
                // console.log(alienList.length);
                TBLHEIGHT = $tblAliens.height();
                TBLWIDTH = $tblAliens.width();
            }

            function moveAllAliens() {
                var pos = $tblAliens.position();

                $tblAliens.css("left", (pos.left + 10 * direction) + "px");
                // console.log(docWidth - LEFT_MARGIN);
                // console.log(pos.left);
                if (direction > 0) {
                    if ((pos.left + 10) >= (docWidth - LEFT_MARGIN - TOP_MARGIN - TBLWIDTH)) {
                        direction = -1;
                        $tblAliens.css("top", (pos.top + 10) + "px");
                    }
                } else {
                    if ((pos.left - 10) <= LEFT_MARGIN) {
                        $tblAliens.css("top", (pos.top + 10) + "px");
                        direction = 1;
                    }
                }

                if ((pos.top + 10) > (docHeight - $ship.height() - TBLHEIGHT))
                    playerLose();
                //console.log(pos.top, docHeight);

                /** for (var i = 0; i < alienList.length; i++){
                 $alien = alienList[i];
                 console.log($tblAliens.position(), $alien.position());
                 } */

            }

        </script>
    </head>
    <body>
        <table id="tblAliens"></table>
        <img src="assets/images/ship.gif" id="ship" />
    </body>
</html>
