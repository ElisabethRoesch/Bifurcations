function relation(){
      var true_sys = {
          x:  [0.1,2.1],
            y: [1.1,0.1],
            type: 'scatter',
            mode: 'lines',
            name: 'Linear relationship',
            line: {color:'grey'}
      };

       var col1 ='rgba(0,0,0,0)' ;
       var col2 = 'rgba(0,0,0,0)';

      var layout_feel = {
           xaxis: {showgrid: false , title:' squared euclidean distance(y,μ(θ)) ', range:[-0.1,2.2] , showline:false,showticklabels: false},
           yaxis: {showgrid: false,   title:'approximated log-likelihood ', range:[-0.1,1.2] , showline:false,showticklabels: false},
           font:{
                   color: '#ffffff',
                   size: '16'
           },
           showlegend: true,
           legend: {
                 // orientation : 'h',y: -0.3,x:0.95,
           yanchor : 'bottom',xanchor :'right'},
           showgrid: false,
           paper_bgcolor: col1,
           plot_bgcolor: col2,
           // title: "deterministic system 1",
           // titlecolor:"black"
     };
     Plotly.plot('relation', [true_sys], layout_feel);
 };
