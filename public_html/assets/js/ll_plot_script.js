function ll_plot(d,b,o,n,a,i,s){
//d = divelement id
//b = bifurcation id
//o = observation
//n = noise
//a = alpha
//i = init
//s = sde noise

    //reads a csv file specified by passed args
    function makeplot() {
      var data_filename = "";
      if(s==1){
          data_filename = b+"_"+o+"_"+n+"_"+a+"_"+i+".csv";

      }else{
        // console.log("s "+s);
          data_filename = b+"_"+o+"_"+n+"_"+a+"_"+i+"_"+s+".csv";
      }
            console.log("/assets/js/ll/"+data_filename);
            // Plotly.d3.csv("file:///project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/"+data_filename, function(data){ processData(data) } );
            //"file:///project/home17/er4517/Project_2/Project_Bifur/data/ll/"+
            Plotly.d3.csv("assets/js/ll/"+data_filename, function(data){ processData(data) } );
    };

    //processes the data of the read file to get the test points and plot values z
    function processData(allRows) {
            //true values for alpha and init , NOT testpoints e.g. axis for this plot!
              // console.log('allRows'+allRows)
            var true_xes =  [-1.5,-.8,-.5,-.2,0.,.2,.5,.8,1.5];
            var true_yes =   [ -1,-.6,-.4,-.1,0.,.1,.4,.6,1.];
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
            // console.log( 'true_xes',true_xes, 'true_yes',true_yes, 'z',z, "test_points", test_points);
            makePlotly( true_xes, true_yes, z , test_points);
    }

    //plotting contourplot and true value as marker
    function makePlotly( true_xes, true_yes, z , test_points){
            var trace1 = {
                        z: z,
                        x: test_points,
                        y: test_points,
                        ncontours: 27,
                        colorscale: [[0, 'rgba(128, 128, 128 ,0.0)'],   [1, 'rgba( 179, 0, 59, 0.5)']],
                        type: 'contour',
                        name: 'log-likelihood'
                      };
            var trace2 = {
                        x: [true_xes[a-1]],
                        y: [true_yes[i-1]],
                        mode: 'markers',
                        name: 'True value',
                        line: {color: 'grey'},
                        type: 'scatter',
                        marker: {size: 20,
                                "symbol": ["x"]}
                        };
            var data = [trace1, trace2];
            var layout = {
              	// title: 'Log-Likelihood',
              	backgroundcolor :'#f2f3f4',
                showlegend: true,
                  legend: {
                    y: -0.2
                  },
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
               }
            }
            var divid ="myDiv";
            if(b=="1"){
                 if(d=="2"){
                    divid=divid+"2";
                 }
                 divid="saddle_"+divid;
            }else if (b=="2") {
                  if(d=="2"){
                     divid=divid+"2";
                  }
                divid="trans_"+divid;
            }else if (b=="3") {
                if(d=="2"){
                   divid=divid+"2";
                }
                  divid="super_"+divid;
            }else{
                if(d=="2"){
                   divid=divid+"2";
                }
                divid="sub_"+divid;
            }

            if(d=="10"){
                divid="example_pp";

            }

            Plotly.newPlot(divid,  data,layout);
    };
makeplot();
};
