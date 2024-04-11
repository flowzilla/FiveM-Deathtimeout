$(document).ready(function () {
    $(".main").hide();

    let countdownInterval;

    window.addEventListener('message', function (event) {
        const data = event.data;

        switch (data.action) {
            case "show":
                $(".main").show();
                document.getElementsByClassName("text")[0].innerHTML = 'Du bist für <span id="time" class="time">' + formatTime(data.seconds) + '</span> Kampfunfähig';
                startCountdown(data.seconds);
                break;
            case "hide":
                stopCountdown();
                $(".main").hide();
                break;
        }
    });

    function startCountdown(seconds) {
        clearInterval(countdownInterval);

        countdownInterval = setInterval(function () {
            seconds--;

            if (seconds <= 0) {
                stopCountdown();
                $(".main").hide();
            }

            $(".text .time").text(formatTime(seconds));
        }, 1000);
    }

    function stopCountdown() {
        clearInterval(countdownInterval);
    }

    function formatTime(seconds) {
        const hours = Math.floor(seconds / 3600);
        seconds %= 3600;
        const minutes = Math.floor(seconds / 60);
        seconds %= 60;


        const formattedHours = String(hours).padStart(2, '0');
        const formattedMinutes = String(minutes).padStart(2, '0');
        const formattedSeconds = String(seconds).padStart(2, '0');

        if (hours > 0) {
            return formattedHours + ":" + formattedMinutes + ":" + formattedSeconds;
        } else {
            return formattedMinutes + ":" + formattedSeconds;
        }
    }
});