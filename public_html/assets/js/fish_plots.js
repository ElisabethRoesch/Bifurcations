function fish(id,sumstat_fish,log_data){
 function makeplot() {
    var data_filename = "";
    data_filename =id+"_"+sumstat_fish+".csv";
      console.log('data_filename'+data_filename)
    Plotly.d3.csv("assets/js/fish_data/"+data_filename, function(data){ processData(data) } );
  };

  function processData(allRows) {
       //key_init is one init condition!!!!!!!!!!!!!!!
          var flag = true;
          var z = [];
          var key_inits = Object.keys(allRows[0]);
          // console.log('key_inits ' + key_inits);
          for (var i=0; i<allRows.length; i++) {
               var row_as_obj = allRows[i];
               var row_as_array = [];
               for (var j=0; j<key_inits.length; j++) {
                    var to_add = (row_as_obj[key_inits[j]]);
                    if(log_data==1){
                              if(to_add>1){
                                   to_add= Math.log(to_add)
                              }else if (to_add<-1){
                                   to_add= -Math.log(Math.abs(to_add));
                              }else{
                                   to_add=0
                              }
                    }
                    row_as_array.push(to_add);
               }
               z.push(row_as_array);
          }
          //transpose
          z=z[0].map((col, i) => z.map(row => row[i]));
          // console.log(z);
          makePlotly(z);
  }

   function makePlotly(z){
      var trace1 = {
                       z: z,
                      x: [-3.0, -2.9, -2.8, -2.7, -2.6, -2.5, -2.4, -2.3, -2.2, -2.1, -2.0, -1.9, -1.8, -1.7, -1.6, -1.5,
                           -1.4, -1.3, -1.2, -1.1, -1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0, 0.1, 0.2,
                           0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2,
                           2.3, 2.9, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0],
                         y: [-2.0, -1.9, -1.8, -1.7, -1.6, -1.5, -1.4, -1.3, -1.2, -1.1, -1.0, -0.9, -0.8, -0.7, -0.6, -0.5,
                               -0.4, -0.3, -0.2, -0.1, 0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4,
                               1.5, 1.6, 1.7, 1.8, 1.9, 2.0],
                       ncontours: 22,
                       colorscale: [[0, 'rgba( 	45, 55, 50,0.0)'] ,   [1, 'rgba(   	15, 80, 199, 0.5)']],
                       type: 'contour',

                     };

      var z = 0;
      var b = "";
      var d = "";
      if (id == 1){
           b = "Saddle Node";
           // z = z1;
           d = "fdiv1";
           nco = 20;
      }else if (id == 2) {
           b = "Transcritical";
           // z = z2;
           d = "fdiv2";
           nco = 100;
      }else if (id == 3) {
           b = "Super-critical Pitchfork";
           // z = z3;
           d = "fdiv3";
           nco = 100;
      }else{
           b = "Sub-critical Pitchfork";
           // z = z4;
           d = "fdiv4";
           nco = 100;
      }
       var data_fish = [trace1];
       var layout_fish = {
           xaxis: {showgrid: false , 	 title: 'α '},
           yaxis: {showgrid: false,    title: 'Initial Condition'},
           font:{ color: '#ffffff',    size: '16'},
           showlegend: true,
           legend: {orientation : 'h',y: -0.3,x:0.95, yanchor : 'bottom',xanchor :'right'},
           showgrid: false,
           paper_bgcolor: 'rgba(0,0,0,0)' ,
           plot_bgcolor: 'rgba(0,0,0,0)' ,
     };
   Plotly.newPlot(d, data_fish, layout_fish);
   };
   makeplot();
};
