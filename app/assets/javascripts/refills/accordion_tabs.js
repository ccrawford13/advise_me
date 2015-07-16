$(document).ready(function() {
  $(".accordion-tabs").each(function(index) {
    $(this).children("li").first().children("a").addClass("is-active").next()
      .addClass("is-open").show();
  });

  $(".accordion-tabs").on("click", "li > a", function(event) {
    if (!$(this).hasClass("is-active")) {
      event.preventDefault();
      var accordionTabs = $(this).closest(".accordion-tabs");
      accordionTabs.find(".is-open").removeClass("is-open").hide();

      $(this).next().toggleClass("is-open").toggle();
      accordionTabs.find(".is-active").removeClass("is-active");
      $(this).addClass("is-active");
    } else {
      event.preventDefault();
    }
  });
});

$(document).ready(function() {
  // if modal button is clicked
  // default first accordion tab as open and displayed
  $("#student__new").on("click", function() {
    $(".student__accordion-tabs").children("li").first().children(
        "a")
      .addClass(
        "is-active").next()
      .addClass("is-open").show();
  });

  // other action will remain the same when toggling between classes
  $(".student__accordion-tabs").each(function(index) {
    $(this).children("li").first().children("a").addClass("is-active").next()
      .addClass("is-open").show();
  });

  $(".student__accordion-tabs").on("click", "li > a", function(event) {
    if (!$(this).hasClass("is-active")) {
      event.preventDefault();
      var accordionTabs = $(this).closest(
        ".student__accordion-tabs");
      accordionTabs.find(".is-open").removeClass("is-open").hide();

      $(this).next().toggleClass("is-open").toggle();
      accordionTabs.find(".is-active").removeClass("is-active");
      $(this).addClass("is-active");
    } else {
      event.preventDefault();
    }
  });
});
