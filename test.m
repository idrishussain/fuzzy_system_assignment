%Create a FIS, setting the name of the fis to accalculator, and other the
%defuzz method to centroid. 
ac_fis = newfis('accalculator.fis','mamdani','min','max','min','max','centroid');

%Add input variables ie room temperature and room humidity to the created
%fuzzy inference system. Here, we also specify the range which the various
%inputs would fall into, and say that room temperature would always fall
%between 0 and 50, while room humidity is on a scale of 0 to 100
ac_fis = addvar(ac_fis, 'input', 'room_temperature', [0 50]);
ac_fis = addvar(ac_fis, 'input', 'room_humidity', [0 100]);

%Add output variable ie ac temperature and ac fan speed. Similar to above,
%we also state the range of values for which these variables would fall
%into
ac_fis = addvar(ac_fis, 'output', 'ac_temperature', [16 30]);
ac_fis = addvar(ac_fis, 'output', 'acHumidAction', [-5 5]);

%In this section we add membership functions for each of the variables. The
%membership function is used to tell what classes exist under a given
%variable, and what range of values make a given instance fall within one
%of the classes. The trapezium membership function would be used for most
%of the cases.

%Add membership functions for room_temnperature variable. For each of the
%functions, specify the dimensions of the trapezium which represents the
%function. 
ac_fis = addmf(ac_fis, 'input', 1, 'Cold', 'trapmf', [0 10 11 12.5]);
ac_fis = addmf(ac_fis, 'input', 1, 'Cool', 'trapmf', [11 14 20 25]);
ac_fis = addmf(ac_fis, 'input', 1, 'Normal', 'trapmf', [24 26.5 28 37.5]);
ac_fis = addmf(ac_fis, 'input', 1, 'Warm', 'trapmf', [28 31 34 40]);
ac_fis = addmf(ac_fis, 'input', 1, 'Hot', 'trapmf', [37.5 39 41 50]);

%Add membership functions for humidity variable
ac_fis = addmf(ac_fis, 'input', 2, 'VeryDry', 'trapmf', [0 0 10 15]);
ac_fis = addmf(ac_fis, 'input', 2, 'Dry', 'trapmf', [10 20 25 32]);
ac_fis = addmf(ac_fis, 'input', 2, 'Moist', 'trapmf', [30 40 50 52]);
ac_fis = addmf(ac_fis, 'input', 2, 'Wet', 'trapmf', [50 60 70 72]);
ac_fis = addmf(ac_fis, 'input', 2, 'VeryWet', 'trapmf', [71 80 100 100]);

%Add membership functions for output variable: ac temperature
ac_fis = addmf(ac_fis, 'output', 1, 'Cold', 'trapmf', [16 18 20 21]);
ac_fis = addmf(ac_fis, 'output', 1, 'Cool', 'trapmf', [20 21 23 24]);
ac_fis = addmf(ac_fis, 'output', 1, 'Normal', 'trapmf', [23 23.5 24.5 25]);
ac_fis = addmf(ac_fis, 'output', 1, 'Warm', 'trapmf', [24.5 25 27 28]);
ac_fis = addmf(ac_fis, 'output', 1, 'Hot', 'trapmf', [26.5 27 29 30]);

%Add membership functions for output variable: ac humidifier
ac_fis = addmf(ac_fis, 'output', 2, 'Dehumidify', 'trapmf', [-5 -3 -1 0]);
ac_fis = addmf(ac_fis, 'output', 2, 'Stop', 'trapmf', [-1 -0.5 0.5 1]);
ac_fis = addmf(ac_fis, 'output', 2, 'Humidify', 'trapmf', [0 1 3 5]);

%Here, we create the set of rules which would be used for fuzy system. For
%each rule in the rulelist, the 6 numbers in the rule signify the (1. room
%temperature where 1 represents cold and 5 represents hot, 2. humidity
%where 1 represents Verydry and 5 represents very wet, 3. ac temperature
%output where 1 represents cold and 5 represents hot, 4. humidifier value
%where 1 represents dehumidifier activated and 3 represents humidifier
%activated,4. The weight of the rule to the overall developement of the fuzzy system, 5. The operator, where 1 represents AND and 2 represents OR.

rulelist = [ ...
1 1 5 3 1 1; 1 2 4 3 0.6 1; 1 3 4 2 0.4 1; 1 4 4 2 0.4 1; 1 5 4 1 0.9 1;...
2 1 4 3 0.5 1; 2 2 4 3 0.4 1; 2 3 4 2 0.4 1; 2 4 4 1 0.15 1; 2 5 4 1 0.5 1;...
3 1 3 3 0.4 1; 3 2 3 3 0.4 1; 3 3 3 2 0.4 1; 3 4 3 1 0.4 1; 3 5 3 1 0.4 1;...
4 1 2 3 0.5 1; 4 2 2 3 0.4 1; 4 3 2 2 0.4 1; 4 4 2 1 0.4 1; 4 5 2 1 0.9 1;...
5 1 1 3 1 1; 5 2 1 2 0.4 1; 5 3 1 1 0.15 1; 5 4 1 1 0.9 1; 5 5 1 1 1 1];

%Add the rules to the fuzzy inference system here
ac_fis = addrule(ac_fis, rulelist);

%Here, we pring out the rules in plain english
showrule(ac_fis)

%Plot the membership functions(what the decider for each variable would
%look like. Essentially, given a value for any of the variables, how would
%i tbe termined what class the value falls into?)
subplot(2,2,1); plotmf(ac_fis,'input', 1)
subplot(2,2,2); plotmf(ac_fis,'input', 2)
subplot(2,2,3); plotmf(ac_fis,'output', 1)
subplot(2,2,4); plotmf(ac_fis,'output', 2) 



%Evaluate the FIS on some input data. here, the input is the room
%temperature and the room humidity. After this input is read,each input
%would be classified, and the fuzzy system would be applied in deciding the
%best temperature to set the room to based on that input. This information
%would be stored in y when the evalfis is called. 
input_data = [...
13.6 18;...
26.7 60;...
46.3 65;...
17.6 35;...
27.3 40;...
19  45;...
18.4 60;...
24.4 65;...
29.1 22;...
30.5 30;...
28.1 100;...
15.6 18;...
22.2 60;...
27.3 100
30.5 35;...
28.1 40;...
15.6 45;...
22.2 60;...
16.6 65;...
20.3 22;...
17.6 30;...
];

y = evalfis(input_data,ac_fis);
