HTMLWidgets.widget({

  name: 'divwheelnav',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        var wheeldata = ["0", "1", "2", "3"];
  
        // create a wheelnav and set options
        // note that via the c3.js API we bind the chart to the element with id equal to chart1
        var wheel_new = new wheelnav("divWheel");
        el.chart = wheel_new.createWheel(wheeldata);
        // el.wheel = wheel_new;
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});