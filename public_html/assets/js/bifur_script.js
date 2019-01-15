function bifur_saddle (b, a){

  console.log(b,a)
    var layout = {
        backgroundcolor :'#f2f3f4',
        showlegend: true,
          legend: {
            x: 0,
            y: 1
          },
       xaxis: {
         title: 'Fixed points',
         range: [-2.,2.],
        showgrid: false
       },
       yaxis: {
         showline:false,
           showticklabels: false,
         range: [0,0],
        showgrid: false
       },
       showgrid: false,
       paper_bgcolor: 'rgba(0,0,0,0)',
       plot_bgcolor: 'rgba(0,0,0,0)',
       font:{
               color: 'white',
               size: '16'
       }
     }


     var true_a ;
     if(a==1){
       true_a = -0.8;
     }else if (a==2) {
        true_a = -0.5;
     }else if (a==3) {
        true_a = 0;
     }else if (a==4) {
        true_a = 0.5;
     }else{
        true_a = 0.8;
     }

    var data = [];
    if(true_a==0){

      var arrow_left = {
            x: [-1.33,-0.66,0.66,1.33],
            y: [0,0,0,0],
            mode: 'markers',
              showlegend: true,
            marker: {
                   symbol: 'triangle-left',
                   size: 20,
                   color: 'grey',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'convergence',

          };



      var alpha_zero = {
            x: [0],
            y: [0],
            mode: 'markers',
            showlegend: true,
            marker: {
                   size: 20,
                   color: 'orange',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'saddle'
          };
      data = [alpha_zero,arrow_left];
    }else if(true_a>0){
      var arrow_left = {
            x: [-Math.sqrt(true_a)*2,Math.sqrt(true_a)*(-1.5),Math.sqrt(true_a)*(1.5),Math.sqrt(true_a)+Math.sqrt(true_a)],
            y: [0,0,0,0],
            mode: 'markers',
            showlegend: false,
            marker: {
                   symbol: 'triangle-left',
                   size: 20,
                   color: 'grey',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'convergence'
          };

          var arrow_right = {
                x: [Math.sqrt(true_a)*(-1/2), 0,Math.sqrt(true_a)*(1/2)],
                y: [0,0,0],
                mode: 'markers',
                showlegend: true,
                marker: {
                       symbol: 'triangle-right',
                       size: 20,
                       color: 'grey',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name: 'convergence'
              };

      var rep = {
            x: [-Math.sqrt(true_a)],
            y: [0],
            mode: 'markers',
            showlegend: true,
            marker: {
                   size: 20,
                   color: 'rgb(128,0,128)',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name:'repelling fixed point'
          };
      var att = {
            x: [Math.sqrt(true_a)],
            y: [0],
            mode: 'markers',
            showlegend: true,
            marker: {
                   size: 20,
                   color: 'rgb(0,255,255)',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name:'attracting fixed point'
          };
      data = [rep,att,arrow_left,arrow_right];
    };
    console.log(data);


  Plotly.newPlot("bifur_saddle",  data,layout);
};


function bifur_trans (b, a){

  console.log(b,a)
    var layout = {
        backgroundcolor :'#f2f3f4',
        showlegend: true,
          legend: {
            x: 0,
            y: 1
          },
       xaxis: {
         title: 'Fixed points',
         range: [-2.,2.],
        showgrid: false
       },
       yaxis: {
         showline:false,
           showticklabels: false,
         range: [0,0],
        showgrid: false
       },
       showgrid: false,
       paper_bgcolor: 'rgba(0,0,0,0)',
       plot_bgcolor: 'rgba(0,0,0,0)',
       font:{
               color: 'white',
               size: '16'
       }
     }


     var true_a ;
     if(a==1){
       true_a = -0.8;
     }else if (a==2) {
        true_a = -0.5;
     }else if (a==3) {
        true_a = 0;
     }else if (a==4) {
        true_a = 0.5;
     }else{
        true_a = 0.8;
     }

    var data = [];
    if(true_a==0){

      var arrow_left = {
            x: [-1.33,-0.66,0.66,1.33],
            y: [0,0,0,0],
            mode: 'markers',
              showlegend: true,
            marker: {
                   symbol: 'triangle-left',
                   size: 20,
                   color: 'grey',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'convergence',

          };



      var alpha_zero = {
            x: [0],
            y: [0],
            mode: 'markers',
            showlegend: true,
            marker: {
                   size: 20,
                   color: 'orange',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'saddle'
          };
      data = [alpha_zero,arrow_left];
    }else if(true_a>0){
      var arrow_left = {
            x: [(true_a)*(-2),(true_a)*(-1.5),(true_a)*(-1),(true_a)*(-0.5),(true_a)*(1.5),(true_a)*(2)],
            y: [0,0,0,0,0,0],
            mode: 'markers',
            showlegend: false,
            marker: {
                   symbol: 'triangle-left',
                   size: 20,
                   color: 'grey',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'convergence'
          };

          var arrow_right = {
                x: [(true_a)*(1/2)],
                y: [0],
                mode: 'markers',
                showlegend: true,
                marker: {
                       symbol: 'triangle-right',
                       size: 20,
                       color: 'grey',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name: 'convergence'
              };

          var rep = {
                x: [0],
                y: [0],
                mode: 'markers',
                showlegend: true,
                marker: {
                       size: 20,
                       color: 'rgb(128,0,128)',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name:'repelling fixed point'
              };
          var att = {
                x: [true_a],
                y: [0],
                mode: 'markers',
                showlegend: true,
                marker: {
                       size: 20,
                       color: 'rgb(0,255,255)',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name:'attracting fixed point'
              };
          data = [rep,att,arrow_left,arrow_right];
    }else{
          var arrow_left = {
                x: [2.*true_a,1.5*(true_a),(true_a)*(-0.5),(true_a)*(-1.),(true_a)*(-1.5),(true_a)*(-2.)],
                y: [0,0,0,0,0,0],
                mode: 'markers',
                showlegend: false,
                marker: {
                       symbol: 'triangle-left',
                       size: 20,
                       color: 'grey',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name: 'convergence'
              };

          var arrow_right = {
                x: [(true_a)*(1/2)],
                y: [0],
                mode: 'markers',
                showlegend: true,
                marker: {
                       symbol: 'triangle-right',
                       size: 20,
                       color: 'grey',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name: 'convergence'
              };

      var rep = {
            x: [true_a],
            y: [0],
            mode: 'markers',
            showlegend: true,
            marker: {
                   size: 20,
                   color: 'rgb(128,0,128)',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name:'repelling fixed point'
          };
      var att = {
            x: [0],
            y: [0],
            mode: 'markers',
            showlegend: true,
            marker: {
                   size: 20,
                   color: 'rgb(0,255,255)',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name:'attracting fixed point'
          };
      data = [rep,att,arrow_left,arrow_right];

    };
    console.log(data);


  Plotly.newPlot("bifur_trans",  data, layout);
};





function bifur_super (b, a){

  console.log(b,a)
    var layout = {
        backgroundcolor :'#f2f3f4',
        showlegend: true,
          legend: {
            x: 0,
            y: 1
          },
       xaxis: {
         title: 'Fixed points',
         range: [-2.,2.],
        showgrid: false
       },
       yaxis: {
         showline:false,
           showticklabels: false,
         range: [0,0],
        showgrid: false
       },
       showgrid: false,
       paper_bgcolor: 'rgba(0,0,0,0)',
       plot_bgcolor: 'rgba(0,0,0,0)',
       font:{
               color: 'white',
               size: '16'
       }
     }


     var true_a ;
     if(a==1){
       true_a = -0.8;
     }else if (a==2) {
        true_a = -0.5;
     }else if (a==3) {
        true_a = 0;
     }else if (a==4) {
        true_a = 0.5;
     }else{
        true_a = 0.8;
     }

    var data = [];
    if(true_a<=0){
      var arrow_left = {
            x: [1.33,0.66],
            y: [0,0],
            mode: 'markers',
              showlegend: true,
            marker: {
                   symbol: 'triangle-left',
                   size: 20,
                   color: 'grey',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'convergence',

          };
          var arrow_right = {
                x: [-0.66,-1.33],
                y: [0,0],
                mode: 'markers',
                  showlegend: true,
                marker: {
                       symbol: 'triangle-right',
                       size: 20,
                       color: 'grey',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name: 'convergence',

              };

      var alpha_zero = {
            x: [0],
            y: [0],
            mode: 'markers',
            showlegend: true,
            marker: {
                   size: 20,
                   color: 'rgb(0,255,255)',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'attracting fixed point'
          };
      data = [alpha_zero,arrow_left,arrow_right];
    }else {
      var arrow_right = {
        x: [-1.5*Math.sqrt(true_a),0.5*Math.sqrt(true_a)],
        y: [0,0],
        mode: 'markers',
          showlegend: true,
        marker: {
               symbol: 'triangle-right',
               size: 20,
               color: 'grey',
               line: { width: 0.5},
               opacity: 0.8},
               name: 'convergence',

      };
      var arrow_left = {
            x: [1.5*Math.sqrt(true_a),-0.5*Math.sqrt(true_a)],
            y: [0,0],
            mode: 'markers',
              showlegend: true,
            marker: {
                   symbol: 'triangle-left',
                   size: 20,
                   color: 'grey',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'convergence',

          };

          var att = {
                x: [-Math.sqrt(true_a),Math.sqrt(true_a)],
                y: [0,0],
                mode: 'markers',
                showlegend: true,
                marker: {
                       size: 20,
                       color: 'rgb(0,255,255)',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name:'attracting fixed point'
              };
          var rep = {
                x: [0],
                y: [0],
                mode: 'markers',
                showlegend: true,
                marker: {
                       size: 20,
                       color: 'rgb(128,0,128)',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name:'repelling fixed point'
              };
          data = [rep,att,arrow_left,arrow_right];
    }
  console.log(data);
  Plotly.newPlot("bifur_super",  data, layout);
};



function bifur_sub (b, a){

  console.log(b,a)
    var layout = {
        backgroundcolor :'#f2f3f4',
        showlegend: true,
          legend: {
            x: 0,
            y: 1
          },
       xaxis: {
         title: 'Fixed points',
         range: [-2.,2.],
        showgrid: false
       },
       yaxis: {
         showline:false,
           showticklabels: false,
         range: [0,0],
        showgrid: false
       },
       showgrid: false,
       paper_bgcolor: 'rgba(0,0,0,0)',
       plot_bgcolor: 'rgba(0,0,0,0)',
       font:{
               color: 'white',
               size: '16'
       }
     }


     var true_a ;
     if(a==1){
       true_a = -0.8;
     }else if (a==2) {
        true_a = -0.5;
     }else if (a==3) {
        true_a = 0;
     }else if (a==4) {
        true_a = 0.5;
     }else{
        true_a = 0.8;
     }

    var data = [];
    if(true_a>=0){

      var arrow_left = {
            x: [-1.33,-0.66],
            y: [0,0],
            mode: 'markers',
              showlegend: true,
            marker: {
                   symbol: 'triangle-left',
                   size: 20,
                   color: 'grey',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'convergence',

          };
          var arrow_right = {
                x: [0.66,1.33],
                y: [0,0],
                mode: 'markers',
                  showlegend: true,
                marker: {
                       symbol: 'triangle-right',
                       size: 20,
                       color: 'grey',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name: 'convergence',

              };

      var alpha_zero = {
            x: [0],
            y: [0],
            mode: 'markers',
            showlegend: true,
            marker: {
                   size: 20,
                   color: 'rgb(128,0,128)',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'repelling fixed point'
          };
      data = [alpha_zero,arrow_left,arrow_right];
    }else {
      var arrow_left = {
        x: [-1.5*Math.sqrt(-true_a),0.5*Math.sqrt(-true_a)],
        y: [0,0],
        mode: 'markers',
          showlegend: true,
        marker: {
               symbol: 'triangle-left',
               size: 20,
               color: 'grey',
               line: { width: 0.5},
               opacity: 0.8},
               name: 'convergence',

      };
      var arrow_right = {
            x: [1.5*Math.sqrt(-true_a),-0.5*Math.sqrt(-true_a)],
            y: [0,0],
            mode: 'markers',
              showlegend: true,
            marker: {
                   symbol: 'triangle-right',
                   size: 20,
                   color: 'grey',
                   line: { width: 0.5},
                   opacity: 0.8},
                   name: 'convergence',

          };

          var rep = {
                x: [-Math.sqrt(-true_a),Math.sqrt(-true_a)],
                y: [0,0],
                mode: 'markers',
                showlegend: true,
                marker: {
                       size: 20,
                       color: 'rgb(128,0,128)',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name:'repelling fixed point'
              };
          var att = {
                x: [0],
                y: [0],
                mode: 'markers',
                showlegend: true,
                marker: {
                       size: 20,
                       color: 'rgb(0,255,255)',
                       line: { width: 0.5},
                       opacity: 0.8},
                       name:'attracting fixed point'
              };
          data = [rep,att,arrow_left,arrow_right];
    }

  console.log(data);
  Plotly.newPlot("bifur_sub",  data, layout);
};
