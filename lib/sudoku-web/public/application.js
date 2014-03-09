(function() {
  $(function() {

    var SubmitButton = Backbone.Marionette.ItemView.extend({
      initialize: function () {
        this.bindUIElements();
      },
      events: {
        "click" : "startSpinner"
      },
      startSpinner: function (event) {
        var spinner = this.getSpinner();
        this.$el.empty();
        spinner.spin(this.el);
      },
      getSpinner: function() {
        var opts = {
          lines: 7, 
          length: 5, 
          width: 2, 
          radius: 4
        };
        return new Spinner(opts);
      }
    });

    window.bacon = new SubmitButton({el: $(".btn-submit")});

  });
})();