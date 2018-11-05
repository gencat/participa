// = require jquery
/**
 * Slick carousel configuration
 */
jQuery(document).ready(function () {
	if(jQuery('.slick-carousel').length){
		jQuery('.slick-carousel').slick({
			autoplay: true,
			autoplaySpeed: 8000,
			infinite: true,
			speed: 600,
			adaptativeHeight: false,
			dots: true
		});
	}
})