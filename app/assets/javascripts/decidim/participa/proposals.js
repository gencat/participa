// = require jquery

$( document ).ready(function() {

    $("form").submit(function (e) {
        var newValue = $("#filter_category_id").val();
        $(".category_description").each(function(i, obj) {
            $(this).hide();
        });
        $("#category_description_" + newValue).show();
    });

});