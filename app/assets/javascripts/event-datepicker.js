$(document).ready(function() {
    $('#datetimepicker-start-date, #datetimepicker-end-date').datetimepicker({
      format: "DD/MM/YYYY HH:mm",
      icons: {
        time: "icon-clock-2",
        date: "icon-calendar",
        up: "icon-arrow-up",
        down: "icon-arrow-down"
      }
    });
    $("#datetimepicker-start-date").on("dp.change", function (e) {
      $('#datetimepicker-end-date').data("DateTimePicker").minDate(e.date);
    });
    $("#datetimepicker-end-date").on("dp.change", function (e) {
      $('#datetimepicker-start-date').data("DateTimePicker").maxDate(e.date);
    });
});