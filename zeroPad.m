function padding = zeroPad(i)
if(i<10)
    padding = '000';
elseif(i<100)
    padding = '00';
else
    padding = '0';
end