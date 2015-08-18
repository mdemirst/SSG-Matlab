function padding = zeroPad(i)
if(i<10)
    padding = '0000';
elseif(i<100)
    padding = '000';
else
    padding = '00';
end