window.onload = function() {
    if ($("#participatory_process_participatory_process_group_id").val() == "1") {
       $("#participatory_process_type_id").parent().parent().hide();
    }
    $( "#participatory_process_participatory_process_group_id" ).change(function() {
        if ($(this).val() == "1") {
          $("#participatory_process_type_id").parent().parent().hide();
          $("#participatory_process_type_id").val("");
        } else {
          $("#participatory_process_type_id").parent().parent().show();
        }
    });
}