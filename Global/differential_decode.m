function b = differential_decode(x)

map_diff_enc_64qam = [...
    2 1 0 1 0; 2 1 1 1 0; 2 0 1 1 0; 2 0 0 1 0; 1 1 0 0 0; 1 1 0 0 1; 1 1 0 1 1; 1 1 0 1 0;
    2 1 0 1 1; 2 1 1 1 1; 2 0 1 1 1; 2 0 0 1 1; 1 1 1 0 0; 1 1 1 0 1; 1 1 1 1 1; 1 1 1 1 0;
    2 1 0 0 1; 2 1 1 0 1; 2 0 1 0 1; 2 0 0 0 1; 1 0 1 0 0; 1 0 1 0 1; 1 0 1 1 1; 1 0 1 1 0;
    2 1 0 0 0; 2 1 1 0 0; 2 0 1 0 0; 2 0 0 0 0; 1 0 0 0 0; 1 0 0 0 1; 1 0 0 1 1; 1 0 0 1 0;
    3 0 0 1 0; 3 0 0 1 1; 3 0 0 0 1; 3 0 0 0 0; 0 0 0 0 0; 0 0 1 0 0; 0 1 1 0 0; 0 1 0 0 0;
    3 0 1 1 0; 3 0 1 1 1; 3 0 1 0 1; 3 0 1 0 0; 0 0 0 0 1; 0 0 1 0 1; 0 1 1 0 1; 0 1 0 0 1;
    3 1 1 1 0; 3 1 1 1 1; 3 1 1 0 1; 3 1 1 0 0; 0 0 0 1 1; 0 0 1 1 1; 0 1 1 1 1; 0 1 0 1 1;
    3 1 0 1 0; 3 1 0 1 1; 3 1 0 0 1; 3 1 0 0 0; 0 0 0 1 0; 0 0 1 1 0; 0 1 1 1 0; 0 1 0 1 0;];
MAPdiff = map_diff_enc_64qam;
MAPhead = [0 0; 0 1; 1 1; 1 0];
xm = MAPdiff(x(:)+1,:);
out0 = xm(:,1);
out1 = MAPhead( mod(diff(out0),4) + 1, :);
b = [out1, xm(2:end,2:end)];

function s = bit2sym(b,mn)
n = log2(mn);
b = fliplr(b);
for k = 1:n
    b(:,k) = b(:,k) * (2^(k-1));
end
s = sum(b,2) + 1;