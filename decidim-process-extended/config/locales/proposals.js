// = require jquery

$( document ).ready(function() {

    $( "#filter_category_id" ).change(function() {
        var newValue = $(this).val();
        $(".category_description").each(function(i, obj) {
            $(this).hide();
        });
        $("#category_description_" + newValue).show();
    });

});