// = require jquery

$( document ).ready(function() {
    if ( isNaN($("#status_id").val()))
        $("#status_2").attr("class", "order-by__tab is-active part-regulation-tab");
    else
        $("#status_"+$("#status_id").val()).attr("class", "order-by__tab is-active part-regulation-tab");

    $('[data-open="processEmbed"]').hide();

    //hoome section correction - meetings count
    var meetings_home = $(".home-pam__lowlight").find(".home-pam__data").first();
    var last_home = $(".home-pam__highlight").last();
    $(meetings_home).appendTo(last_home);
});
