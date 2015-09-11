function padding = zeroPad(i)
if(i<10)
    padding = '000';
elseif(i<100)
    padding = '00';
elseif(i < 1000)
    padding = '0';
else
    padding = '';
end