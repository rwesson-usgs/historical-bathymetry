function B = nmea2matlab( filename)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
fid = fopen(filename)
i = 0
tline = fgetl(fid);
while ischar(tline)
    nmea_code = NaN;
    hr = NaN;
    min= NaN;
    sec = NaN;
    lat = NaN;
    lon = NaN;
    dep = NaN;
    temp = NaN;
%    disp(tline);
    [token, remain] = strtok(tline, ',');
    if     strcmp(token,'$INGGA')
        nmea_code = 1;
        [timestr,remain] = strtok(remain, ',');
        if length(timestr)>=6
            hr = str2num(timestr(1:2));
            min = str2num(timestr(3:4));
            sec = str2num(timestr(5:6));
            [latstr,remain] = strtok(remain,',');
            lat = str2num(latstr(1:2))+str2num(latstr(3:9))/60.;
            [n_or_s,remain] = strtok(remain,',');
            if strcmp(n_or_s,'S') 
                lat = -lat;
            end
            [lonstr,remain] = strtok(remain,',');
            lon = str2num(lonstr(1:3))+str2num(lonstr(4:10))/60.;
            [e_or_w,remain] = strtok(remain,',');
            if strcmp(e_or_w,'W')
                lon = -lon;
            end
        end

    elseif strcmp(token,'$INGLL') 
        nmea_code = 2;
        [latstr,remain] = strtok(remain,',');
        if length(latstr)>=9
            lat = str2num(latstr(1:2))+str2num(latstr(3:9))/60.;
            [n_or_s,remain] = strtok(remain,',');
            if strcmp(n_or_s,'S') 
                lat = -lat;
            end
            [lonstr,remain] = strtok(remain,',');
            lon = str2num(lonstr(1:3))+ str2num(lonstr(4:10))/60.;
            [e_or_w,remain] = strtok(remain,',');
            if strcmp(e_or_w,'W')
            lon = -lon;
            end
            [timestr,remain] = strtok(remain, ',');
            hr = str2num(timestr(1:2));
            min = str2num(timestr(3:4));
            sec = str2num(timestr(5:6));
        end
        
    elseif strcmp(token,'$INDPT')
        nmea_code = 3;
        depstr = strtok(remain, ',');
        dep = str2num(depstr);
        if isempty(dep)
            dep = NaN;
        end
        
    elseif strcmp(token,'$INMTW')
       
        nmea_code = 4;
        tempstr = strtok(remain,',');
        temp = str2num(tempstr);
        
    elseif strcmp(token,'$INRMC')
        nmea_code = 5;
        [timestr,remain] = strtok(remain, ',');
        if length(timestr)>=6
            hr = str2num(timestr(1:2));
            min = str2num(timestr(3:4));
            sec = str2num(timestr(5:6));
            [status_str,remain] = strtok(remain,',');
            [latstr,remain] = strtok(remain,',');
            lat = str2num(latstr(1:2))+str2num(latstr(3:9))/60.;
            [n_or_s,remain] = strtok(remain,',');
            if strcmp(n_or_s,'S') 
            lat = -lat;
            end
            [lonstr,remain] = strtok(remain,',');
            lon = str2num(lonstr(1:3))+str2num(lonstr(4:10))/60.;
            [e_or_w,remain] = strtok(remain,',');
            if strcmp(e_or_w,'W')
                lon = -lon;
            end
        end
    elseif strcmp(token,'$INZDA')
        nmea_code = 6;
        [timestr,remain] = strtok(remain, ',');
        if length(timestr)>=6
            hr = str2num(timestr(1:2));
            min = str2num(timestr(3:4));
            sec = str2num(timestr(5:6));
        end

    end
    i = i + 1;
    [nmea_code,hr,min,sec,lat,lon,dep,temp];
    B(i,:) =[nmea_code,hr,min,sec,lat,lon,dep,temp];
    tline = fgetl(fid);
end

fclose(fid);

end

