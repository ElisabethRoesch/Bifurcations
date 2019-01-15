//d: div, b: bifurcationid, a:alpha, i:init
function plot_feel(d,b,a,i){
  var sde = true
  var divid ="feel";
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
      };
   var data_filename = b+"_"+a+"_"+i+".csv";
   console.log(b,a,i,data_filename);
   Plotly.d3.csv("assets/js/feel_data/"+data_filename, function(data){ processData2(data) } );

   // reads data from file
   function processData2(allRows2) {
           var feel_x = [];
           var feel_y = [];
           for (var i=0; i<allRows2.length; i++) {
             var row = allRows2[i];
             var size = 0, key;
             for (key in row) {
                 if (row.hasOwnProperty(key)) size++;
             }
             var temp_row = [];
               for (var j=0; j<size; j++) {
                  var keys = Object.keys(row)
                   temp_row.push(row[keys[size-1-j]]);
                   if(i==0){
                     feel_x.push(keys[size-1-j]);
                   }
                 }
             feel_y.push(temp_row);
           }
           makePlotly2( feel_x, feel_y);
   };

   function makePlotly2(xes, yes){
         Plotly.purge(divid);
         var true_xes = [-1.5,-.8,-.5,-.2,0.,.2,.5,.8,1.5];
         var fixpoints = [];
         var bifur_para = true_xes[a-1];
         var sub_active = false;
         //depending on bifurcaztion type fixpoints are calculated.
         if(b==1){
              if(bifur_para==0){
                  console.log('a',a,'bifur_para',bifur_para);
                  fixpoints.push(0);

              }else if(bifur_para>0){
                  fixpoints.push(Math.sqrt(bifur_para));
                  fixpoints.push(-Math.sqrt(bifur_para));
              }else{
                   console.log("nothing");
              }
         }else if (b==2) {
              if(bifur_para==0){
                   console.log('a',a,'bifur_para',bifur_para);
                   fixpoints.push(0);
              }else if(bifur_para>=0){
                   fixpoints.push(bifur_para);
                   fixpoints.push(0);
              }else{
                   fixpoints.push(0);
                   fixpoints.push(bifur_para);
              }
          }else if (b==3) {
                if(bifur_para<=0){
                  fixpoints.push(0);
                }else{
                  fixpoints.push(Math.sqrt(bifur_para));
                  fixpoints.push(0);
                  fixpoints.push(-Math.sqrt(bifur_para));
                }
          }else{
               console.log("sub is set");
                sub_active =true;
                if(bifur_para>=0){
                  fixpoints.push(0);
                }else{
                  fixpoints.push(Math.sqrt(-bifur_para));
                  fixpoints.push(0);
                  fixpoints.push(-Math.sqrt(-bifur_para));
                }
          };
         var attracting_1, repelling_1, attracting_2;
         var data = [];
         var true_sys = {
             x: xes,
               y: yes[0],
               type: 'scatter',
               mode: 'lines+markers',
               marker: {
                      symbol: 'dot',
                      size: 15,
                      color: 'grey',
                      line: { width: 0.5},
                      opacity: 0.8},

               name: 'true system',
               line: {color:'grey'}
         };
         if (sub_active){
                    if(bifur_para>=0){
                      var constant_1 = new Array(11);
                      constant_1.fill(fixpoints[0]);
                      attracting_1 = {
                         x: xes,
                         y: constant_1,
                         type: 'scatter',
                         mode: 'lines',
                         name: 'repelling fixpoint',
                         line: {color:'rgb(128,0,128)'}
                       };
                       data = [attracting_1, true_sys];
                    }else{
                        // console.log("in sub ");
                      var constant_1 = new Array(11);
                      constant_1.fill(fixpoints[0]);
                      attracting_1 = {
                         x: xes,
                         y: constant_1,
                         type: 'scatter',
                         mode: 'lines',
                         name: 'repelling fixpoint',
                         line: {color:'rgb(128,0,128)'}
                       };
                       var constant_2 = new Array(11);
                       constant_2.fill(fixpoints[1]);
                       var repelling_1 = {
                           x: xes,
                             y: constant_2,
                             type: 'scatter',
                             mode: 'lines',
                             name: 'attracting fixpoint',
                             line: {color:'#00ffff'}
                       };
                       var constant_3 = new Array(11);
                       constant_3.fill(fixpoints[2]);
                       var attracting_2 = {
                           x: xes,
                             y: constant_3,
                             type: 'scatter',
                             mode: 'lines',
                             name: 'repelling fixpoint',
                             line: {color:'rgb(128,0,128)'}
                       };
                       data = [attracting_1, repelling_1, attracting_2,true_sys];
                    }
          }else{
                    if(fixpoints.length>0){

                        var constant_1 = new Array(11);
                        constant_1.fill(fixpoints[0]);
                        attracting_1 = {
                           x: xes,
                           y: constant_1,
                           type: 'scatter',
                           mode: 'lines',
                           name: 'attracting fixpoint',
                           line: {color:'#00ffff'}
                         };
                    }
                     if(fixpoints.length>1){
                       var constant_2 = new Array(11);
                       constant_2.fill(fixpoints[1]);
                       var repelling_1 = {
                           x: xes,
                             y: constant_2,
                             type: 'scatter',
                             mode: 'lines',
                             name: 'repelling fixpoint',
                             line: {color:'rgb(128,0,128)'}
                       };
                     }
                     if(fixpoints.length>2){
                       var constant_3 = new Array(11);
                       constant_3.fill(fixpoints[2]);
                       var attracting_2 = {
                           x: xes,
                             y: constant_3,
                             type: 'scatter',
                             mode: 'lines',
                             name: 'attracting fixpoint',
                             line: {color:'#00ffff'}
                       };
                     }

                    if (fixpoints.length == 0){
                      data = [true_sys]
                    }else if(fixpoints.length == 1){
                      if(a==5){
                        if(b==1|b==2){
                          attracting_1 = {
                             x: xes,
                             y: constant_1,
                             type: 'scatter',
                             mode: 'lines',
                             name: 'saddle fixed point',
                             line: {color:'orange'}
                           };
                          data = [attracting_1, true_sys];
                        }else if(b==3){
                          attracting_1 = {
                             x: xes,
                             y: constant_1,
                             type: 'scatter',
                             mode: 'lines',
                             name: 'attracting fixed point',
                             line: {color:'#00ffff'}
                           };
                          data = [attracting_1, true_sys];
                        }else{
                          attracting_1 = {
                             x: xes,
                             y: constant_1,
                             type: 'scatter',
                             mode: 'lines',
                             name: 'repelling fixed point',
                             line: {color:'rgb(128,0,128)'}
                           };
                          data = [attracting_1, true_sys];

                        }

                      }
                      data = [attracting_1, true_sys];
                    }else if (fixpoints.length == 2){
                      data = [attracting_1, repelling_1,true_sys];
                    }else{
                      data = [attracting_1, repelling_1, attracting_2,true_sys];
                    }
            }
          var col1 ='rgba(0,0,0,0)' ;
          var col2 = 'rgba(0,0,0,0)';
            // if(sde){
            //         col1='#000000';
            //         col2='#000000';
            //         var ad = yes[0];
            //         var bd = yes[0];
            //         var x_var1 = ad.map(function(item, index) {return item - 0.05*(bd[index]); });
            //         console.log('x_var1',x_var1,"\n");
            //         var true_sys_005 = {
            //               x: xes,
            //               y: x_var1,
            //               type: 'scatter',
            //               name: 'variance1',
            //               fill: 'tonexty',
            //               // mode: 'none',
            //               // opacity: 1.,
            //               line: {color:'#b3ccff'}
            //         };
            //         var ad2 = yes[0];
            //         var bd2 = yes[0];
            //         var x_var2 = ad2.map(function(item2, index2) {return item2 - (-0.05)*(bd2[index2]); });
            //         var true_sys_095 = {
            //               x: xes,
            //               y: x_var2,
            //               type: 'scatter',
            //               fill: 'tonexty',
            //               name: 'variance2',
            //               line: {color:'#b3ccff'}
            //         };
            //         console.log('x_var2',x_var2,"\n");
            //         data.push(true_sys_095);
            //         data.push(true_sys_005);
            // }
         var layout_feel = {
              xaxis: {showgrid: false , title:'time'},
              yaxis: {showgrid: false,   title:'x'},
              font:{
                      color: '#ffffff',
                      size: '16'
              },
              showlegend: true,
              legend: {orientation : 'h',y: -0.3,x:0.95,
              yanchor : 'bottom',xanchor :'right'},
              showgrid: false,
              paper_bgcolor: col1,
              plot_bgcolor: col2,
              // title: "deterministic system 1",
              // titlecolor:"black"
        };
        Plotly.plot(divid, data, layout_feel);
    };
};
