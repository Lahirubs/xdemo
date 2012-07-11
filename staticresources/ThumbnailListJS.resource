(function($) {
  $V.ThumbnailListController = $V.Component.extend({
  init: function(config) {
    this._super(config);
  },
  prepare: function() {
    this._super();
  },
  render: function() {
    this._super();
    // Load records from the server, and give it a function to handle the response.
    $.mobile.showPageLoadingMsg();
    var serverRecords = this.requestRecords(this.requestRecordsHandler);
    $.mobile.hidePageLoadingMsg();
  },
  requestRecords: function(responseHandler) {
    // Specify any parameter values for the component’s Apex controller.
    var configProxy = {
      sObjectType: this.config.sObjectType,
      imageUrlField: this.config.imageUrlField,
      labelField: this.config.labelField,
      subLabelField: this.config.subLabelField,
      sortByField: this.config.sortByField
    };
    $V.App.getFn(this.config.serverCtlrName).getRecordsForConfig(
      this.config,
      // Callback
      (function(that, fn) {
        return function(result, event) {
          fn.apply(that, arguments);
        };
      })(this, responseHandler)
    );
  },
  requestRecordsHandler: function(result, event) {
    // See what the response looks like.
    $V.App.log.debug(this.config.serverCtlrName + '.getRecords response: ', result);
    // Transform the response list of records to match the template.
    var model = {};
    model.records = [];
    for (var i = 0; i < result.length; i++) {
      var record = result[i];
      model.records.push(record);
    }
    $V.App.log.debug('Finished model: ', model);
    // Push the data into the template. This templating engine is called
    //   ICanHaz, which is a wrapper around Mustache templating.
    // This command looks for a template stored as HTML inside
    //   <script id="rowItemTempl" type="text/html"><script> tags.
    var listItemsMarkup = ich.rowItemTempl(model, true);
    $V.App.log.debug('Template result: ', listItemsMarkup);
    // Render the markup to the DOM.
    $ul = this.$me.find('ul');
    $ul.html(listItemsMarkup);
    // After mark up is rendered, do other stuff, like apply events.
    this.applyEvents($ul);
  }
  });
})(jQuery);
