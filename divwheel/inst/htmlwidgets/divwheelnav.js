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
          var blue = "#B0E0E6";
          var white = "#FFFFFF";
          if (y===0){
            return red;
          }
          else if(y==2){
            return blue;
          }
          else if(y==3){
            return white;
          }
          else{
            return green;
          }
        }
        var subwheeldata = Array(wheeldata.length).fill("");
        var colorpalette = [];
        for (i=0; i<list_logos.length; i++){
          colorpalette.push(color(qa[i]));
        }
        // var wheel_new = new wheelnav("divwheelnav");
        chart.clockwise = false;
        chart.wheelRadius = 200;
        chart.slicePathFunction = slicePath().DonutSlice;
        chart.slicePathCustom = slicePath().DonutSliceCustomization();
        chart.slicePathCustom.minRadiusPercent = 0.50;
        chart.slicePathCustom.maxRadiusPercent = 0.95;
        chart.sliceSelectedPathCustom = chart.slicePathCustom;
        chart.sliceInitPathCustom = chart.slicePathCustom;
        chart.clickModeRotate = false;
        chart.sliceTransformFunction  = sliceTransform().MoveMiddleTransform;
        chart.colors = logos_colors;
        
        subchart.slicePathFunction = slicePath().DonutSlice;
        subchart.slicePathCustom = slicePath().DonutSliceCustomization();
        subchart.minRadius= chart.wheelRadius;
        subchart.slicePathCustom.minRadiusPercent = 0.65;
        subchart.slicePathCustom.maxRadiusPercent = 0.75;
        subchart.sliceSelectedPathCustom = subchart.slicePathCustom;
        subchart.sliceInitPathCustom = subchart.slicePathCustom;
        subchart.sliceTransformFunction  = sliceTransform().MoveMiddleTransform;
        subchart.spreaderRadius= 85;
        subchart.clickModeRotate= false;
        subchart.clockwise=false;
        subchart.markerPathFunction = markerPath().PieLineMarker;
        subchart.markerEnable = true;
        subchart.colors = colorpalette;
        
        chart.initWheel(wheeldata);
        for (i=0; i<list_logos.length; i++){
          chart.navItems[i].titleRotateAngle = -(360/list_logos.lenght)*i;
        }
        subchart.initWheel(subwheeldata);
        
        chart.createWheel();
        subchart.createWheel();
        
        
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