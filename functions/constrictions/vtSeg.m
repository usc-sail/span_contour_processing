function [Xul,Yul,Xll,Yll,Xtongue,Ytongue,Xalveolar,...
    Yalveolar,Xpalatal,Ypalatal,Xvelum,Yvelum,Xvelar,...
    Yvelar,Xphar,Yphar,Xepig,Yepig] = vtSeg(contourdata, file_name, frame_number, ds, sim_switch)
    
    if ~sim_switch
        X=contourdata.X((contourdata.files == file_name & contourdata.frames == frame_number)',:);
        Y=contourdata.Y((contourdata.files == file_name & contourdata.frames == frame_number)',:);
    else
        X=contourdata.Xsim((contourdata.files == file_name & contourdata.frames == frame_number)',:);
        Y=contourdata.Ysim((contourdata.files == file_name & contourdata.frames == frame_number)',:);
    end
    
    % Lips
    Xul = X(ismember(contourdata.sections_id,15));
    Yul = Y(ismember(contourdata.sections_id,15));
    Xll = X(ismember(contourdata.sections_id,4));
    Yll = Y(ismember(contourdata.sections_id,4));
    Xul = interp1(Xul,1:ds:length(Xul));
    Yul = interp1(Yul,1:ds:length(Yul));
    Xll = interp1(Xll,1:ds:length(Xll));
    Yll = interp1(Yll,1:ds:length(Yll));
    
    % Tongue
    Xtongue = X(ismember(contourdata.sections_id,2));
    Ytongue = Y(ismember(contourdata.sections_id,2));
    Xtongue=interp1(Xtongue,1:ds:length(Xtongue));
    Ytongue=interp1(Ytongue,1:ds:length(Ytongue));
    
    % Epiglottis
    Xepig = X(ismember(contourdata.sections_id,1));
    Yepig = Y(ismember(contourdata.sections_id,1));
    Xepig=interp1(Xepig,1:ds:length(Xepig));
    Yepig=interp1(Yepig,1:ds:length(Yepig));
    
    % Palate
    Xalveolar = X(ismember(contourdata.sections_id,11));
    Yalveolar = Y(ismember(contourdata.sections_id,11));
    Xpalatal =  X(ismember(contourdata.sections_id,11));
    Ypalatal =  Y(ismember(contourdata.sections_id,11));
    Xvelum = X(ismember(contourdata.sections_id,12));
    Yvelum = Y(ismember(contourdata.sections_id,12));
    Xphar = X(ismember(contourdata.sections_id,[7 8]));
    Yphar = Y(ismember(contourdata.sections_id,[7 8]));
    Xalveolar = interp1(Xalveolar,1:ds:length(Xalveolar));
    Yalveolar = interp1(Yalveolar,1:ds:length(Yalveolar));
    Xpalatal = interp1(Xpalatal,1:ds:length(Xpalatal));
    Ypalatal = interp1(Ypalatal,1:ds:length(Ypalatal));
    Xvelum = interp1(Xvelum,1:ds:length(Xvelum));
    Yvelum = interp1(Yvelum,1:ds:length(Yvelum));
    Xphar = interp1(Xphar,1:ds:length(Xphar));
    Yphar = interp1(Yphar,1:ds:length(Yphar));
    
    % trim...
    Xalveolar = Xalveolar(1:3*ds^-1); 
    Yalveolar = Yalveolar(1:3*ds^-1);
    Xpalatal = Xpalatal(5*ds^-1:end-ds^-1);
    Ypalatal = Ypalatal(5*ds^-1:end-ds^-1);
    Xvelar = Xvelum(1:2*ds^-1);
    Yvelar = Yvelum(1:2*ds^-1);
    Xphar = Xphar(15*ds^-1:end); 
    Yphar = Yphar(15*ds^-1:end);
    
end