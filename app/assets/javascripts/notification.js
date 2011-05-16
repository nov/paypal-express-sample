$(function () {
  var parse = function (flash) {
    try {
      return JSON.parse(flash);
    } catch(e) {
      return {text: flash};
    }
  };

  var notify = function (flash, options) {
    if (typeof flash == 'string') {
      flash = JSON.parse(flash);
    }
    $.jGrowl(flash.text, $.extend(flash, options));
  };

  $.notify = {
    error: function (flash) {
      notify(flash, {theme: 'error'});
    },
    warn: function (flash) {
      notify(flash, {theme: 'warn'});
    },
    notice: function (flash) {
      notify(flash, {theme: 'notice'});
    },
    all: function () {
      if ($.cookie('flash.error')) {
        $.notify.error($.cookie('flash.error'));
        $.cookie('flash.error', null, {path: '/'});
      }
      if ($.cookie('flash.warn')) {
        $.notify.warn($.cookie('flash.warn'));
        $.cookie('flash.warn', null, {path: '/'});
      }
      if ($.cookie('flash.notice')) {
        $.notify.notice($.cookie('flash.notice'));
        $.cookie('flash.notice', null, {path: '/'});
      }
    }
  };

  $.notify.all();
});
