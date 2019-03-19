HTMLWidgets.widget({

  name: 'divwheelnav',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    var chart = new wheelnav(el.id);
    return {

      renderValue: function(x) {
        var wheeldata = ['imgsrc:./ODD1.jpg', 'imgsrc:./ODD1.jpg', 'imgsrc:./ODD3.jpg','imgsrc:./ODD1.jpg','imgsrc:./ODD1.jpg',
        'imgsrc:./ODD1.jpg','imgsrc:./ODD1.jpg','imgsrc:./ODD1.jpg'];
  
        // create a wheelnav and set options
        // note that via the c3.js API we bind the chart to the element with id equal to chart1
        var question_answer = x.question_answer
        function color(y){
          var green = "#2D9E46";
          var red = "#D63C22";
          if (y===0){
            return red;
          }
          else{
            return green;
          }
        }
        var colorpalette = {
          defaultpalette: new Array(color(x.question_1), color(x.question_2), color(x.question_3), color(x.question_4),
          color(x.question_5),color(x.question_6),color(x.question_7),color(x.question_8))}
        // var wheel_new = new wheelnav("divwheelnav");
        chart.slicePathFunction = slicePath().DonutSlice;
        chart.colors = colorpalette.defaultpalette;
        chart.createWheel(wheeldata);
        //el.innerText = "ODDDDO";
        // el.wheel = wheel_new;
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      },
      s:chart

    };
  }
});