HTMLWidgets.widget({

  name: 'divwheelnav',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    var chart = new wheelnav(el.id, null, 600,600);
    var subchart = new wheelnav("wheel2", chart.raphael);
    return {

      renderValue: function(x) {
        
  
        // create a wheelnav and set options
        // note that via the c3.js API we bind the chart to the element with id equal to chart1
        var qa = x.question_answer;
        var list_logos = x.logos;
        var logos_colors = x.colors_logos;
        function get_logos(y){
          var directory_logo = "imgsrc:./"+y+".jpg";
          return directory_logo;
        }
        var i;
        var wheeldata = [];
        for (i=0; i<list_logos.length;i++){
          wheeldata.push(get_logos(list_logos[i]));
        }
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
        var subwheeldata = Array(wheeldata.length).fill("");
        var colorpalette = {
          defaultpalette: new Array(color(qa[0]), color(qa[1]), color(qa[2]), color(qa[3]),
          color(qa[4]),color(qa[5]),color(qa[6]),color(qa[7]))};
        // var wheel_new = new wheelnav("divwheelnav");
        chart.slicePathFunction = slicePath().DonutSlice;
        chart.clockwise = false;
        chart.wheelRadius = 200;
        chart.clickModeRotate = false;
        chart.colors = logos_colors;
        
        subchart.slicePathFunction = slicePath().DonutSlice;
        subchart.slicePathCustom = slicePath().DonutSliceCustomization();
        subchart.minRadius= chart.wheelRadius;
        subchart.slicePathCustom.minRadiusPercent = 0.65;
        subchart.slicePathCustom.maxRadiusPercent = 0.75;
        subchart.sliceSelectedPathCustom = subchart.slicePathCustom;
        subchart.sliceInitPathCustom = subchart.slicePathCustom;
        subchart.spreaderRadius= 85;
        subchart.clickModeRotate= false;
        subchart.clockwise=false;
        subchart.markerPathFunction = markerPath().PieLineMarker;
        subchart.markerEnable = true;
        subchart.colors = colorpalette.defaultpalette;
        
        chart.createWheel(wheeldata);
        subchart.createWheel(subwheeldata);
        
        
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