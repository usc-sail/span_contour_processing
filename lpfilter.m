function y=lpfilter(x,cutoff,Fs)

if length(x)>31
    
    order = 10;
    
else
    
    order = floor((length(x)-1)/3);
    
end;

fNorm = cutoff / (Fs/2);
[b,a] = butter(order, fNorm, 'low');
y = filtfilt(b, a, x);
