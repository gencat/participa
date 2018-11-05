$( document ).ready(function() {

    $(".scope_selected").each(function(i, obj) {
        if ($( "#filter_scope_id_"+$(this).val() ).length) {
            $( "#filter_scope_id_"+$(this).val() ).prop('checked', true);
        }
    });

    if ($("#happened_selected").val() == 1) {
        $("#post_happened_1").prop('checked', true);
    } else if ($("#happened_selected").val() == 0){
        $("#post_happened_0").prop('checked', true);
    } else {
        $("#post_happened_0").prop('checked', true);
    }

    if ($("#date_selected").length) {
        $("#meetingsDate option:eq("+$("#date_selected").val()+")").prop('selected', true);
    }
    $( "#meetingsSearch" ).find("input").click(function() {
        $( "#btnMeetingsSubmit" ).click();
    });

    $( "#happenedMeetings" ).find("input").click(function() {
        $( "#btnMeetingsSubmit" ).click();
    });

    $( "#meetingsDate" ).change(function() {
        $( "#btnMeetingsSubmit" ).click();
    });

    $( "#meetingsProcess" ).change(function() {
        $( "#btnMeetingsSubmit" ).click();
    });

    if ($('input[name="post[happened]"]:checked').val() == "1") {
        $("#dateMeetings").hide();
    }
});
