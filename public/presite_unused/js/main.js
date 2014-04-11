
$(function() {
    $('.sponsor-list').each(function() {
        var listItems = $(this).children('li').detach();
        var tmp = [];
        listItems.each(function() {
            tmp.push(this);
        });
        tmp.sort(function() {
            return Math.round(Math.random()) - 0.5;
        });
        for (var i = 0, len = tmp.length; i < len; i++) {
            $(this).append(tmp[i]);
        }
    }).css('display', 'block');

    $('#cover-image').on('inview', function(event, isInView, visiblePartX, visiblePartY) {
        if (window.matchMedia( "(min-width: 769px)" ).matches) {
            if (isInView) {
                $('#site-logo').hide(500);
            } else {
                $('#site-logo').show(500);
            }
        }
    });
});
