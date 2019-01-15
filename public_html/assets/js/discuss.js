function discuss(){


  function makeplot(dis_bif) {
     var data_filename = '1_1_1_7_3.csv';
     var data_filename2 = '1_1_1_8_3.csv';
     var all_data = [];
     console.log('teste discuss'+data_filename)
     Plotly.d3.csv("assets/js/ll/"+data_filename, function(data){ processData(data) } );
     Plotly.d3.csv("assets/js/ll/"+data_filename2, function(data2){ processData(data2) } );
      makePlotly(all_data);
   };

   function processData(allRows) {

           var flag = true;
           var test_points =[];
           var z = [];
           for (var i=0; i<allRows.length; i++) {
             var row = allRows[i];
             var size = 0, key;
             for (key in row) {
               if(flag){
                   test_points.push(key);
               }
                 if (row.hasOwnProperty(key)) size++;
             }
             flag = false;
             var z_part = [];
               for (var j=0; j<size; j++) {
                  var keys = Object.keys(row);
                  var new_ele = row[keys[j]];
                  // console.log(new_ele);
                  if(new_ele=="-Inf"){
                     new_ele = -1000;
                  }
                  if(new_ele< -1000){
                     new_ele = -1000;
                  }
                   z_part.push(new_ele);
                 }
             z.push(z_part);
           }
           var trace1 = {
                       z: z,
                       x: test_points,
                       y: test_points,
                       ncontours: 27,
                       colorscale: [[0, 'rgba(128, 128, 128 ,0.0)'],   [1, 'rgba( 179, 0, 59, 0.5)']],
                       type: 'contour',
                       name: 'log-likelihood'
                     };
           // console.log( 'true_xes',true_xes, 'true_yes',true_yes, 'z',z, "test_points", test_points);
           all_data.push(trace1);

   }

   function makePlotly( all_frams){

           // var trace2 = {
           //             x: [true_xes[a-1]],
           //             y: [true_yes[i-1]],
           //             mode: 'markers',
           //             name: 'True value',
           //             line: {color: 'grey'},
           //             type: 'scatter',
           //             marker: {size: 20,
           //                     "symbol": ["x"]}
           //             };
           // var data = [trace1, trace2];
           // var layout = {
           //     // title: 'Log-Likelihood',
           //     backgroundcolor :'#f2f3f4',
           //     showlegend: true,
           //       legend: {
           //         y: -0.2
           //       },
              // xaxis: {
              //   title: 'α',
              //   range: [-2,2],
              //  showgrid: false
              // },
              // yaxis: {
              //   title: 'Initial Condition',
              //   range: [-2,2],
              //  showgrid: false
              // },
           //    showgrid: false,
           //    paper_bgcolor: 'rgba(0,0,0,0)',
           //    plot_bgcolor: 'rgba(0,0,0,0)',
           //    font:{
           //            color: 'white',
           //            size: '16'
           //    }
           // }

        var frames = all_frams;
         Plotly.plot('discuss_saddle', [{
           x: frames[0].x,
           y: frames[0].y,
            z: frames[0].z,
            ncontours: 27,
            colorscale: [[0, 'rgba(128, 128, 128 ,0.0)'],   [1, 'rgba( 179, 0, 59, 0.5)']],
            type: 'contour'
         }], {
           xaxis: {
             title: 'α',
             range: [-2,2],
            showgrid: false
           },
           yaxis: {
             title: 'Initial Condition',
             range: [-2,2],
            showgrid: false
           },
           showgrid: false,
              paper_bgcolor: 'rgba(0,0,0,0)',
              plot_bgcolor: 'rgba(0,0,0,0)',
              font:{
                      color: 'white',
                      size: '16'
              },
           updatemenus: [{
             buttons: [
               {method: 'animate', args: [['sine']], label: 'sine'},
               {method: 'animate', args: [['cosine']], label: 'cosine'},
               {method: 'animate', args: [['circle']], label: 'circle'}
             ]
           }]
         }).then(function() {
           Plotly.addFrames('discuss_saddle', frames);
         });
           // Plotly.newPlot('discuss_saddle',  frames,layout);
   };
   makeplot(1);
};
