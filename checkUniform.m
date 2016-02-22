dist = zeros(1,7);
for i=1:1000
    sum = 0;
    for j=1:7
        sum = sum + (randi(5)-1);
    end
    number = round(sum/6) + 1;
    dist(number) = dist(number) + 1;
end

plot(dist);
ylim([0,1000]);