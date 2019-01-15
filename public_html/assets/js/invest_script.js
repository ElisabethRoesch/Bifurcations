function invest_saddle(investdiv){

// console.log("hi");
  var test_points_x = [0.0,0.5,1.0,1.5,2.0]
  var test_points_y_stable = [];
  var test_points_y_unstable = [];
  for (i in test_points_x){
       // console.log(Math.sqrt(i));
       // console.log(-Math.sqrt(i));
       test_points_y_stable.push(Math.sqrt(i));
       test_points_y_unstable.push(-Math.sqrt(i));
  };
  var stable_saddle = {
        x: test_points_x,
        y: test_points_y_stable,
        type: 'scatter',
        mode: 'lines',
        name: 'attracting fixed point',
        line: {color:'green'}
   };
   var unstable_saddle = {
         x: test_points_x,
         y: test_points_y_unstable,
         type: 'scatter',
         mode: 'lines',
         name: 'repelling fixed point',
         line: {color:'red'}
    };

    var layout = {
      backgroundcolor :'#f2f3f4',
      showlegend: true,
        legend: {
          x: 0,
          y: 1
        },
     xaxis: {
       title: 'Alpha',
       // range: [-2.,2.],
      showgrid: false
     },
     yaxis: {
       showline:false,
       // showticklabels: false,
       // range: [0,0],
      showgrid: false
     },
     showgrid: false,
     paper_bgcolor: 'rgba(0,0,0,0)',
     plot_bgcolor: 'rgba(0,0,0,0)',
     font:{
             color: 'white',
             size: '16'
     }
   };
   console.log("hi",stable_saddle, unstable_saddle  );
   var data = [stable_saddle, unstable_saddle];
   Plotly.newPlot(investdiv,  data, layout);
};
