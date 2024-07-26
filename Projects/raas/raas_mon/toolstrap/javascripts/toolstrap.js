$(function() {
  // Applies height to '.main section' when shorter than available screen real estate
  // Add class="full-height" to <body> to trigger
  var div = ".full-height .main > section";
  if ($(div).length) {
    $(window).resize(function() {
      if ($(div).height() < $(window).height()) {
        $(div).css("min-height", $(window).height() - $(div).offset().top - ($(div).outerHeight(true) - $(div).height()));
      }
    });
    $(window).resize();
  }

  // CLOSE ALERTS
  $(".alert .icon-close").click(function(e){
    e.preventDefault();
    $(this).parent().hide();
  });

  // TOGGLE ACCORDIONS
  $(".accordion > .accordion-trigger").click(function(e){
    if ($(e.target).attr('href')) {
      e.handleEvent();
    } else {
      e.preventDefault();
      $(this).parent().toggleClass("open");
    }
  });

  // TABS & TAB BUTTONS
  $(".tabs a, .tab-buttons a").click(function(e){
    e.preventDefault();
    $(this).parent().addClass('active').siblings().removeClass('active');
    $($(this).attr("href")).addClass("active").siblings().removeClass('active');
  });

  // TAB BUTTON MENUS
  $(".tab-button-menu .has-menu > a").click(function(e){
    e.preventDefault();
    if ($(this).hasClass('active')) {
      $(this).removeClass('active').siblings('.modal-menu').removeClass('is-visible');
      $(this).parent('.active').removeClass('active');
    } else {
      $('.has-menu.active').removeClass('active');
      $('.has-menu a.active').removeClass('active');
      $('.modal-menu.is-visible').removeClass('is-visible');
      $(this).addClass('active').siblings('.modal-menu').addClass('is-visible');
    }
  });

  // hide tab button menu when clicking outside
  $(document).click(function(e) {
    // srcElement is not available in Firefox; target is not available in IE
    var target = e.target || e.srcElement;
    if (!$(target).is('.has-menu a.active') && !$(target).is('.modal-menu.is-visible a')) {
      $('.has-menu.active').removeClass('active');
      $('.has-menu a.active').removeClass('active');
      $('.modal-menu.is-visible').removeClass('is-visible');
    }
  });

  // MODALS
  // show the modal on clicking a modal trigger
  $(document).on('click', '[data-modal-id]', function(e){
    e.preventDefault();
    var targetModal = '#' + $(this).data('modal-id');
    $('.modal').removeClass('show-modal');
    $('.modal-open').removeClass('modal-open');
    $(targetModal).addClass('show-modal');
    $('body').addClass('modal-open');
  });

  // hide the modal on clicking the close icon
  $(document).on('click', '.close-modal', function(e){
    e.preventDefault();
    $('.show-modal').removeClass('show-modal');
    $('.modal-open').removeClass('modal-open');
  });

  // hide the modal on clicking outside the modal
  $(document).on('click', '.modal', function(e){
    // srcElement is not available in Firefox; target is not available in IE
    var target = e.target || e.srcElement;
    if ($(target).closest('.modal-body').length === 0) {
      $('.show-modal').removeClass('show-modal');
      $('.modal-open').removeClass('modal-open');
    }
  });

  // hide the modal on pressing esc key
  $('body').bind('keyup.modal',function(event){
    if ( event.which === 27 ) {
      $('.show-modal').removeClass('show-modal');
      $('.modal-open').removeClass('modal-open');
     }
  });

  // TOOLTIPS
  // (work in progress)
  $(".has-tooltip").hover(
    function () {
      // $(this).children(".tooltip").wrap('<span class="tooltip-wrapper" />');
      $(this).children(".tooltip").delay(300).fadeIn(200);
    },
    function () {
      // $(this).children(".tooltip").unwrap();
      $(this).children(".tooltip").clearQueue();
      $(this).children(".tooltip").delay(200).fadeOut(200);
    }
  );

  $("[data-placement='top-left']").each(function() {
    var tooltipYoffset = $(this).outerHeight() + 10;
    $(this).attr('style', 'top: -' + tooltipYoffset + 'px; left: 0');
  });

  $("[data-placement='top']").each(function() {
    var tooltipYoffset = $(this).outerHeight() + 10;
    var tooltipXoffset = $(this).parent().outerWidth() / 2 - $(this).outerWidth() / 2;
    $(this).attr('style', 'top: -' + tooltipYoffset + 'px; left: ' + tooltipXoffset + 'px');
  });

  $("[data-placement='top-right']").each(function() {
    var tooltipYoffset = $(this).outerHeight() + 10;
    $(this).attr('style', 'top: -' + tooltipYoffset + 'px; right: 0');
  });

  $("[data-placement='right-top']").each(function() {
    var tooltipXoffset = $(this).parent().outerWidth() + 10;
    var tooltipYoffset = $(this).outerHeight() / 2;
    $(this).attr('style', 'top: -' + tooltipYoffset + 'px; left: ' + tooltipXoffset + 'px');
  });

  $("[data-placement='right']").each(function() {
    var tooltipYoffset = $(this).parent().outerHeight() / 2 - $(this).outerHeight() / 2;
    var tooltipXoffset = $(this).parent().outerWidth() + 10;
    $(this).attr('style', 'top: ' + tooltipYoffset + 'px; left: ' + tooltipXoffset + 'px');
  });

  $("[data-placement='right-bottom']").each(function() {
    var tooltipXoffset = $(this).parent().outerWidth() + 10;
    var tooltipYoffset = $(this).outerHeight() / 2;
    $(this).attr('style', 'bottom: -' + tooltipYoffset + 'px; left: ' + tooltipXoffset + 'px');
  });

  $("[data-placement='bottom']").each(function() {
    var tooltipYoffset = $(this).outerHeight() + 10;
    var tooltipXoffset = $(this).parent().outerWidth() / 2 - $(this).outerWidth() / 2;
    $(this).attr('style', 'bottom: -' + tooltipYoffset + 'px; left: ' + tooltipXoffset + 'px');
  });

  $("[data-placement='left']").each(function() {
    var tooltipYoffset = $(this).parent().outerHeight() / 2 - $(this).outerHeight() / 2;
    var tooltipXoffset = $(this).parent().outerWidth() + 10;
    $(this).attr('style', 'top: ' + tooltipYoffset + 'px; right: ' + tooltipXoffset + 'px');
  });

});
