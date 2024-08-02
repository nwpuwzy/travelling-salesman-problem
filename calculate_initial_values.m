function y = calculate_initial_values(x, a, k)
    a = 250;
    k = 0.005;
    if x <= a
        y = x;
    else
        y = a * exp(-k * (x - a)) + 2;
    end
end
