function y = quantnum(x,q)

if x<2^-16
    %y=2^-16
    y = quantize(q,x);
else
    y = quantize(q,x);
end

if (q.NOverflows>0)
    q.NOverflows = 0;
    disp(strcat('Overflows number (QRD) = ',num2str(q.NOverflows)));
end