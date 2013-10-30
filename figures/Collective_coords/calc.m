
BSLACOM = [68.44 69.48 18.49]';
CitACOM = [72.88 57.97 49.78]';
Lys34   = [87.48 48.62 50.38]';
Pro71   = [79.95 58.94 35.70]'; 
Thr199  = [68.95 55.81  5.91]';

x = Lys34 - CitACOM;
y = Pro71 - CitACOM;

y = y - (x'*y)/(norm(x)^2)*x;
y = (y / norm(y) * norm(x));

z = rand(3,1);
z = z - (x'*z)/(norm(x)^2)*x;
z = z - (y'*z)/(norm(y)^2)*y;
z = (z / norm(z) * norm(x));



Ref = Thr199 - BSLACOM;
Ref = Ref / norm(Ref) * norm(x);





x1 = (CitACOM + x)'
y1 = (CitACOM + y)'
z1 = (CitACOM + z)'

x1 = (BSLACOM + x)'
y1 = (BSLACOM + y)'
z1 = (BSLACOM + z)' 

Ref = (BSLACOM + 2*Ref)'
