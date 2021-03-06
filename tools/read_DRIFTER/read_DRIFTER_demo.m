%It required kml_shapefile
%https://www.mathworks.com/matlabcentral/fileexchange/25104-kml-matlab-shapefile-conversion
%https://www.mathworks.com/matlabcentral/fileexchange/10915-deg2utm
%line 198 and line 209 needs to comment out
clear; clc

%% Read drifter from kml
kmlFile='./data/drifter_1_10_11_12MAI_Cmdt_Fernandes.kml';
[pts_struc] = kml_shapefile(kmlFile);
%get longitude and latitude and ignore the last points 
lon = pts_struc(1).X(1:end-8);
lat = pts_struc(1).Y(1:end-8);
%Transform to UTM
[x,y,utmzone] = deg2utm(lat,lon);
%Get euclidean distance in KM from the starting point
distances = sqrt((x-x(1)).^2 + (y-y(1)).^2);
%Get didstances diferences between a point and other
d_diff = (diff(distances));

%% Extract time 
for i=2:length(lon)+1
mat_date(i-1,1)= datenum(pts_struc(i).name,'yyyy-mm-ddHH:MM:SS');
end
%tranform to datetime format
str_date=datetime(datestr(mat_date));
%get the diferences in minutes
dt=abs(seconds(diff(str_date)));

%% Get velocities
Velocity = d_diff./dt;
%%
plot(lon,lat)
hold on
for i=1:1:length(lon)-1
    text(lon(i),lat(i),num2str(Velocity(i)))
    hold on
end
 plot_google_map('MapScale', 1)
 %%
 %plot()