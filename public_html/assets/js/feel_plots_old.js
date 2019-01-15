
//d: div, b: bifurcationid, a:alpha, i:init
function plot_feel(b,a,i){
  var divid ="feel";
  var fixpoint = Math.sqrt(a);
  if(b=="1"){
      divid="saddle_"+divid;
  }else if (b=="2") {
     divid="trans_"+divid;
   }else if (b=="3") {
       divid="super_"+divid;
   }else{
       divid="sub_"+divid;
   };
   // var data_filename = b+"_"+a+"_"+i+".csv";
   var data_filename = "wer"+".csv";
   console.log("Function plot_feel");
   console.log(b,a,i,data_filename);
   Plotly.d3.csv("file:///project/home17/er4517/Project_2/Project_Bifur/frontend/html5up-dimension/assets/js/"+data_filename, function(data){ processData2(data) } );

   // reads data from file
   function processData2(allRows2) {
     var x = [];
     console.log(allRows2);
     var y = [];
     for (var i=0; i<allRows2.length; i++) {
       var row = allRows2[i];
       var size = 0, key;
       for (key in row) {
           if (row.hasOwnProperty(key)) size++;
       }
       var z_part = [];
         for (var j=0; j<size; j++) {
            var keys = Object.keys(row)
             z_part.push(row[keys[size-1-j]]);
             if(i==0){
               x.push(keys[size-1-j]);
             }
           }
       y.push(z_part);
     }
     makePlotly2( x, y);
   };

   function makePlotly2(xes, yes){
     console.log( 'Xes',xes,'Yes',yes);
     var frames = [
     {name: 'test 0',   data: [{x: [], y: []}]},
     {name: 'test 1',   label: 'test system2',data: [{x: [], y: []}]},
     {name: 'test 2',  label: 'test system3',data: [{x: [], y: []}]},
     {name: 'test 3',  label: 'test system4', data: [{x: [], y: []}]},
     {name: 'test 4',   label: 'test system5', data: [{x: [], y: []}]},
     {name: 'test 5', label: 'test system6',  data: [{x: [], y: []}]},
     ];
     var n = 13;
     for (var i = 2; i < n; i++) {
       var t = i / (n - 1) * 2 - 1;

       // A  wave:
       frames[0].data[0].x[i] = xes[i];
       frames[0].data[0].y[i] = yes[0][i];

       // A cosine wave:
       frames[1].data[0].x[i] = xes[i];
       frames[1].data[0].y[i] = yes[1][i];

       // A circle:
       frames[2].data[0].x[i] = xes[i];
       frames[2].data[0].y[i] = yes[2][i];

       // A  wave:
       frames[3].data[0].x[i] = xes[i];
       frames[3].data[0].y[i] = yes[3][i];

       // A cosine wave:
       frames[4].data[0].x[i] = xes[i];
       frames[4].data[0].y[i] = yes[4][i];

       // A circle:
       frames[5].data[0].x[i] = xes[i];
       frames[5].data[0].y[i] = yes[5][i];
     }

     var frames2 = [
     {name: 'test 02',   data: [{x: [], y: []}]},
     {name: 'test 12',   label: 'test system2',data: [{x: [], y: []}]}
     ];
     var n = 13;
     for (var i = 2; i < n; i++) {
       var t = i / (n - 1) * 2 - 1;

       // A  wave:
       frames2[0].data[0].x[i] = xes[i];
       frames2[0].data[0].y[i] = yes[0][i];

       // A cosine wave:
       frames2[1].data[0].x[i] = xes[i];
       frames2[1].data[0].y[i] = yes[1][i];

     }

     Plotly.purge(divid);
     var data_feel = [{
       x: [0,1,2,3,4,5,6,7,8,9,10],
       y: [0,0,0,0,0,0,0,0,0,0,0]
     }]
     var layout_feel = {
       xaxis: {range: [0, 10],showgrid: false , title:'time'},
       yaxis: {range: [-2, 10],showgrid: false,   title:'x' },
       updatemenus: [
        {
            y: 0.8,
            buttons: [
              {method: 'animate', args: [['test 0','test 1']], label: 'Init 0'},
              {method: 'animate', args: [['test 1']], label: 'test 1'},
              {method: 'animate', args: [['test 2']], label: 'test 2'},
              {method: 'animate', args: [['test 3']], label: 'test 3'},
              {method: 'animate', args: [['test 4']], label: 'test 4'},
              {method: 'animate', args: [['test 5']], label: 'test 5'}
            ]
        },
        {
         buttons: [
           {method: 'animate', args: [['test 02']], label: 'Alpha 02'},
           {method: 'animate', args: [['test 12']], label: 'test 12'},

         ]
       }],
       font:{
               color: '#0099ff',
               size: '16'
       },
       showlegend: true,
       showgrid: false,
       paper_bgcolor: 'rgba(0,0,0,0)',
       plot_bgcolor: 'rgba(0,0,0,0)'
     };
     Plotly.plot(divid, data_feel,layout_feel ).then(function() {
       var trace0 = {
          x: [0,1,2,3,4,5,6,7,8,9,10],
          y: [fixpoint, fixpoint, fixpoint,fixpoint, fixpoint, fixpoint, fixpoint, fixpoint, fixpoint,fixpoint, fixpoint],
          type: 'scatter',
          mode: 'lines',
          name: 'attracting fixpoint',
          line: {color:'green'}
      };
      var trace1 = {
          x: [0,1,2,3,4,5,6,7,8,9,10],
            y: [-fixpoint, -fixpoint, -fixpoint,-fixpoint, -fixpoint, -fixpoint, -fixpoint, -fixpoint, -fixpoint,-fixpoint, -fixpoint],
            type: 'scatter',
            mode: 'lines',
            name: 'repelling fixpoint',
            line: {color:'red'}
      };
      var trace2 = {
          x: [0,1,2,3,4,5,6,7,8,9,10],
            y: [-1, -1,-1,-1,1,1,1,1,1,1,1],
            type: 'scatter',
            name: 'true system',
            line: {color:'blue'}
      };
      var data = [trace0, trace1, trace2];
       Plotly.addFrames(divid, frames2);
       Plotly.addFrames(divid, frames);
       Plotly.plot(divid, data);
     });
   };
};

